const std = @import("std");
const rl = @import("raylib");

pub const Obstacle = struct {
    x: f32,
    y: f32,
    gap: f32,
    width: f32,
    passed: bool,
};

const Obstacles = @This();

allocator: std.mem.Allocator,
obstacles: std.ArrayList(Obstacle),
gap: f32,
start: f32,
pipe_width: f32,
texture: rl.Texture2D,

pub fn init(allocator: std.mem.Allocator) !Obstacles {
    const texture = try rl.loadTexture("assets/sprites/pipe.png");

    return Obstacles{
        .allocator = allocator,
        .obstacles = std.ArrayList(Obstacle){},
        .gap = 140,
        .start = 600,
        .pipe_width = 90,
        .texture = texture,
    };
}

pub fn createObstacle(self: *Obstacles) !void {
    const pos_y: f32 = @floatFromInt(rl.getRandomValue(100, 500));
    const pos_x: f32 = self.start + (@as(f32, @floatFromInt(self.texture.width)) * @as(f32, @floatFromInt(self.obstacles.items.len)) * 4);

    try self.obstacles.append(self.allocator, Obstacle{
        .x = pos_x,
        .y = pos_y,
        .gap = self.gap,
        .width = @floatFromInt(self.texture.width),
        .passed = false,
    });
}

pub fn draw(self: *Obstacles) void {
    for (self.obstacles.items) |o| {
        // put one pipe on each direction
        rl.drawTextureEx(self.texture, rl.Vector2.init(o.x, o.y), 180, 1, rl.Color.white);
        rl.drawTexture(self.texture, @intFromFloat(o.x - @as(f32, @floatFromInt(self.texture.width)) - 2), @intFromFloat(o.y + o.gap), rl.Color.white);
    }
}

pub fn destroyObstacles(self: *Obstacles) void {
    var i: usize = 0;
    while (i < self.obstacles.items.len) {
        if (self.obstacles.items[i].x > -50) {
            i += 1;
        } else {
            _ = self.obstacles.orderedRemove(i);
        }
    }
}

pub fn update(self: *Obstacles, speed: f32) !void {
    self.draw();
    for (self.obstacles.items) |*obstacle| {
        obstacle.x -= speed;
    }
    if (self.obstacles.items.len < 3) {
        try self.createObstacle();
    }
    self.destroyObstacles();
}

pub fn clear(self: *Obstacles) void {
    self.obstacles.clearRetainingCapacity();
}

pub fn deinit(self: *Obstacles) void {
    self.obstacles.deinit(self.allocator);
    rl.unloadTexture(self.texture);
}
