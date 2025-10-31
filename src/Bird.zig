const std = @import("std");
const rl = @import("raylib");
const Obstacle = @import("Obstacles.zig").Obstacle;
const Difficulty = @import("Difficulty.zig");

const Bird = @This();

sprites: [4]rl.Texture2D,
pos_x: f32,
pos_y: f32,
speed_y: f32,
sprite_index: usize,
timer: i32,
width: f32,
height: f32,
is_dead: bool,
jump_force: f32,
jump_amount: f32,
jump_sound: rl.Sound,

pub fn init(difficulty: Difficulty.Level) !Bird {
    const up_flap = try rl.loadTexture("assets/sprites/upflap.png");
    const mid_flap = try rl.loadTexture("assets/sprites/midflap.png");
    const down_flap = try rl.loadTexture("assets/sprites/downflap.png");

    const jump_sound = try rl.loadSound("assets/audio/wing.wav");

    // Get jump amount based on difficulty!
    const jump_amount = difficulty.getJumpAmount();

    return Bird{
        .sprites = [4]rl.Texture2D{ mid_flap, down_flap, mid_flap, up_flap },
        .pos_x = 100,
        .pos_y = 250,
        .speed_y = 10,
        .sprite_index = 0,
        .timer = 0,
        .width = 68,
        .height = 48,
        .is_dead = false,
        .jump_force = 0,
        .jump_amount = jump_amount, // Now uses difficulty setting!
        .jump_sound = jump_sound,
    };
}

pub fn initPosition(self: *Bird) void {
    self.pos_y = 250;
    self.pos_x = 100;
}

pub fn updateAnimation(self: *Bird) void {
    self.timer += 1;
    if (self.timer > 5 and !self.is_dead) {
        self.timer = 0;
        self.sprite_index += 1;
        if (self.sprite_index >= self.sprites.len) {
            self.sprite_index = 0;
        }
    }
}

pub fn updatePosition(self: *Bird, speed: f32) void {
    if (!self.is_dead) {
        self.pos_y += self.speed_y;
        self.pos_y -= self.jump_force;
        self.speed_y *= 1.015;
    } else {
        self.pos_x -= speed;
    }
}

pub fn pollEvent(self: *Bird) void {
    if (rl.getCharPressed() != 0) { // jumping
        rl.playSound(self.jump_sound);
        self.jump_force += self.jump_amount;
        self.speed_y = 10;
        if (self.jump_force > self.jump_amount) {
            self.jump_force = 20;
        }
    }
    if (self.jump_force > 0) {
        self.jump_force *= 0.96; // jump force decreasing over time
    }
}

pub fn colidesWithObstacle(self: *Bird, o: Obstacle) bool {
    return (self.pos_x >= (o.x - self.width - o.width) and self.pos_x <= o.x and
        !(self.pos_y >= o.y and self.pos_y <= o.y + o.gap - self.height));
}

pub fn checkCollisions(self: *Bird, ground_y: f32, obstacles: []Obstacle) void {
    // with the ground
    if (self.pos_y >= ground_y - self.height) {
        self.is_dead = true;
    } else {
        // and obstacles
        for (obstacles) |o| {
            if (self.colidesWithObstacle(o)) {
                self.is_dead = true;
            }
        }
    }
}

pub fn update(self: *Bird, speed: f32) void {
    rl.drawTexture(self.sprites[self.sprite_index], @intFromFloat(self.pos_x), @intFromFloat(self.pos_y), rl.Color.white);
    if (!self.is_dead) {
        self.updateAnimation();
    }
    self.updatePosition(speed);
    self.pollEvent();
}

pub fn deinit(self: *Bird) void {
    for (self.sprites) |s| {
        rl.unloadTexture(s);
    }
    rl.unloadSound(self.jump_sound);
}
