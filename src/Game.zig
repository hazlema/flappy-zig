const std = @import("std");
const rl = @import("raylib");
const Background = @import("Background.zig");
const Bird = @import("Bird.zig");
const Obstacles = @import("Obstacles.zig");
const Score = @import("Score.zig");
const GameOverScreen = @import("GameOverScreen.zig");
const MainMenu = @import("MainMenu.zig");
const Difficulty = @import("Difficulty.zig");

const Game = @This();

/// Game states - where are we in the game flow?
pub const State = enum {
    menu, // Showing the main menu
    playing, // Actively playing the game
    game_over, // Dead, showing game over screen
};

allocator: std.mem.Allocator,
run: bool,
state: State,
current_difficulty: Difficulty.Level,
screen_width: i32,
screen_height: i32,
bird: Bird,
background: Background,
obstacles: Obstacles,
score: Score,
initial_speed: f32,
speed: f32,

pub fn init(allocator: std.mem.Allocator) !Game {
    const screen_width = 500;
    const screen_height = 1000;

    rl.initWindow(screen_width, screen_height, "Flappy Bird - Zig");
    rl.initAudioDevice();
    rl.setTargetFPS(60);

    const initial_speed: f32 = 3.0;
    const default_difficulty = Difficulty.Level.medium;

    return Game{
        .allocator = allocator,
        .run = true,
        .state = .menu, // Start in menu state!
        .current_difficulty = default_difficulty,
        .screen_width = screen_width,
        .screen_height = screen_height,
        .bird = try Bird.init(default_difficulty),
        .background = try Background.init(),
        .obstacles = try Obstacles.init(allocator, default_difficulty),
        .score = try Score.init(),
        .initial_speed = initial_speed,
        .speed = initial_speed,
    };
}

/// Start a new game with the given difficulty
fn startNewGame(self: *Game, difficulty: Difficulty.Level) void {
    // Clear old game state
    self.score.restart();
    self.speed = self.initial_speed;
    self.background.pickNewBackground();

    // Recreate bird with new difficulty settings
    self.bird.deinit(); // Clean up old bird
    self.bird = Bird.init(difficulty) catch unreachable; // Create new bird

    // Recreate obstacles with new difficulty settings
    self.obstacles.deinit(); // Clean up old obstacles
    self.obstacles = Obstacles.init(self.allocator, difficulty) catch unreachable; // Create new obstacles

    // Transition to playing state
    self.state = .playing;
}

pub fn restart(self: *Game) void {
    self.obstacles.clear();
    self.bird.initPosition();
    self.bird.is_dead = false;
    self.bird.speed_y = 10;
    self.speed = self.initial_speed;
    self.score.restart();
    self.background.pickNewBackground();
}

pub fn isRunning(self: *Game) bool {
    return self.run and !rl.windowShouldClose();
}

pub fn update(self: *Game) !void {
    // State machine - different behavior based on current state
    switch (self.state) {
        .menu => try self.updateMenu(),
        .playing => try self.updatePlaying(),
        .game_over => try self.updateGameOver(),
    }
}

/// Handle the menu state
fn updateMenu(self: *Game) !void {
    var menu = try MainMenu.init(&self.background, self.screen_width, self.screen_height);
    defer menu.deinit();

    // Run menu and get selected difficulty (or null if closed)
    const selected = menu.run();

    if (selected) |difficulty| {
        // Player selected a difficulty - start the game!
        self.current_difficulty = difficulty;
        self.startNewGame(difficulty);
    } else {
        // Window was closed
        self.run = false;
    }
}

/// Handle the playing state
fn updatePlaying(self: *Game) !void {
    rl.beginDrawing();
    rl.clearBackground(rl.Color.blue);

    self.background.update(self.speed);
    try self.obstacles.update(self.speed);

    // check if we passed the obstacle (first one is closest)
    if (self.obstacles.obstacles.items.len > 0) {
        self.score.update(&self.obstacles.obstacles.items[0], &self.bird, &self.speed);
    }

    self.bird.update(self.speed);
    self.bird.checkCollisions(self.background.base_y, self.obstacles.obstacles.items);

    // Check if bird died - transition to game over state
    if (self.bird.is_dead) {
        self.state = .game_over;
    }

    rl.endDrawing();
}

/// Handle the game over state
fn updateGameOver(self: *Game) !void {
    var game_over = try GameOverScreen.init(&self.background, self.score.value, self.speed);
    defer game_over.deinit();

    const should_close = game_over.run();

    if (should_close) {
        self.run = false;
    } else {
        // Restart with same difficulty
        self.startNewGame(self.current_difficulty);
    }
}

pub fn deinit(self: *Game) void {
    self.bird.deinit();
    self.background.deinit();
    self.obstacles.deinit();
    self.score.deinit();
    rl.closeAudioDevice();
    rl.closeWindow();
}
