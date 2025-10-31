const std = @import("std");
const rl = @import("raylib");
const Background = @import("Background.zig");

const GameOverScreen = @This();

background: *Background,
texture: rl.Texture2D,
sound: rl.Sound,
score: i32,
speed: f32,

pub fn init(background: *Background, score: i32, speed: f32) !GameOverScreen {
    const texture = try rl.loadTexture("assets/sprites/gameover.png");
    const sound = try rl.loadSound("assets/audio/die.wav");

    return GameOverScreen{
        .background = background,
        .texture = texture,
        .sound = sound,
        .score = score,
        .speed = speed,
    };
}

pub fn run(self: *GameOverScreen) bool {
    rl.playSound(self.sound);

    while (rl.getKeyPressed() == .null and !rl.windowShouldClose()) {
        rl.beginDrawing();
        rl.clearBackground(rl.Color.blue);
        self.background.update(self.speed);
        rl.drawTexture(self.texture, 70, 200, rl.Color.white);
        rl.drawText("Press any key to play again", 70, 500, 25, rl.Color.white);

        var buf: [64]u8 = undefined;
        const score_text = std.fmt.bufPrintZ(&buf, "Score: {d}", .{self.score}) catch "Score: 0";

        rl.drawText(score_text, 70, 405, 50, rl.Color.black);
        rl.drawText(score_text, 70, 400, 50, rl.Color.white);
        rl.drawText("[ESC] Exit", 10, 10, 30, rl.Color.white);
        rl.endDrawing();
    }

    // Return true if window should close, false if player wants to restart
    return rl.windowShouldClose();
}

pub fn deinit(self: *GameOverScreen) void {
    rl.unloadTexture(self.texture);
    rl.unloadSound(self.sound);
}
