const std = @import("std");
const rl = @import("raylib");
const Obstacle = @import("Obstacles.zig").Obstacle;
const Bird = @import("Bird.zig");

const Score = @This();

point_sound: rl.Sound,
value: i32,

pub fn init() !Score {
    const point_sound = try rl.loadSound("assets/audio/point.wav");

    return Score{
        .point_sound = point_sound,
        .value = 0,
    };
}

pub fn draw(self: *Score) void {
    var buf: [32]u8 = undefined;
    const text = std.fmt.bufPrintZ(&buf, "{d}", .{self.value}) catch "0";

    // twice for shadow effect
    rl.drawText(text, 220, 30, 100, rl.Color.black);
    rl.drawText(text, 220, 25, 100, rl.Color.white);
}

pub fn restart(self: *Score) void {
    self.value = 0;
}

pub fn update(self: *Score, obstacle: *Obstacle, bird: *Bird, speed: *f32) void {
    self.draw();
    if (obstacle.x - obstacle.width <= bird.pos_x and !obstacle.passed) {
        obstacle.passed = true;
        self.value += 1;
        rl.playSound(self.point_sound);
        speed.* += 0.2; // for dat spice
    }
}

pub fn deinit(self: *Score) void {
    rl.unloadSound(self.point_sound);
}
