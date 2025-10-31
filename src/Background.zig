const std = @import("std");
const rl = @import("raylib");

const Background = @This();

background_day: rl.Texture2D,
background_night: rl.Texture2D,
background: rl.Texture2D,
base_y: f32,
base_x: f32,
base_width: f32,
base: rl.Texture2D,

pub fn init() !Background {
    const background_day = try rl.loadTexture("assets/sprites/backgroundDay.png");
    const background_night = try rl.loadTexture("assets/sprites/backgroundNight.png");
    const base = try rl.loadTexture("assets/sprites/base.png");

    var bg = Background{
        .background_day = background_day,
        .background_night = background_night,
        .background = background_day,
        .base_y = 776,
        .base_x = 0,
        .base_width = 672,
        .base = base,
    };

    bg.pickNewBackground();
    return bg;
}

pub fn pickNewBackground(self: *Background) void {
    const rand = rl.getRandomValue(0, 1);
    self.background = if (rand > 0) self.background_day else self.background_night;
}

pub fn drawBase(self: *Background, speed: f32) void {
    self.base_x -= speed;
    rl.drawTexture(self.base, @intFromFloat(self.base_x), @intFromFloat(self.base_y), rl.Color.white);
    rl.drawTexture(self.base, @intFromFloat(self.base_x + 500), @intFromFloat(self.base_y), rl.Color.white);
    if (self.base_x <= -500) {
        self.base_x = -10;
    }
}

pub fn update(self: *Background, speed: f32) void {
    rl.drawTexture(self.background, 0, 0, rl.Color.white);
    self.drawBase(speed);
}

pub fn deinit(self: *Background) void {
    rl.unloadTexture(self.background_day);
    rl.unloadTexture(self.background_night);
    rl.unloadTexture(self.base);
}
