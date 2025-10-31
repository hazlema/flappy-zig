// MainMenu.zig - The starting menu where players select difficulty
const std = @import("std");
const rl = @import("raylib");
const Background = @import("Background.zig");
const Difficulty = @import("Difficulty.zig");

const MainMenu = @This();

background: *Background,
selected_difficulty: Difficulty.Level,
screen_width: i32,
screen_height: i32,
keyboard_selection_index: usize, // Track which button is highlighted by keyboard
font: rl.Font,

pub fn init(background: *Background, screen_width: i32, screen_height: i32) !MainMenu {
    const font = try rl.loadFontEx("assets/fonts/Kenney-Future.ttf", 96, null);

    return MainMenu{
        .background = background,
        .selected_difficulty = .medium, // Default to medium
        .screen_width = screen_width,
        .screen_height = screen_height,
        .keyboard_selection_index = 0, // Start on medium (index: 0=easy, 1=medium, 2=hard)
        .font = font,
    };
}

pub fn deinit(self: *MainMenu) void {
    rl.unloadFont(self.font);
}

/// Draws a button and returns true if clicked
fn drawButton(self: *const MainMenu, x: i32, y: i32, width: i32, height: i32, text: [:0]const u8, is_selected: bool) bool {
    const mouse_pos = rl.getMousePosition();
    const mouse_over = rl.checkCollisionPointRec(
        mouse_pos,
        rl.Rectangle{ .x = @floatFromInt(x), .y = @floatFromInt(y), .width = @floatFromInt(width), .height = @floatFromInt(height) },
    );

    // Choose color based on hover/selection state
    const button_color = if (is_selected)
        rl.Color.green
    else if (mouse_over)
        rl.Color.light_gray
    else
        rl.Color.gray;

    // Draw button background
    rl.drawRectangle(x, y, width, height, button_color);
    rl.drawRectangleLines(x, y, width, height, rl.Color.black);

    // Draw text centered in button
    const font_size = 30;
    const text_size = rl.measureTextEx(self.font, text, font_size, 1);
    const text_x: f32 = @as(f32, @floatFromInt(x)) + @as(f32, @floatFromInt(width)) / 2.0 - text_size.x / 2.0;
    const text_y: f32 = @as(f32, @floatFromInt(y)) + @as(f32, @floatFromInt(height)) / 2.0 - text_size.y / 2.0;

    rl.drawTextEx(self.font, text, rl.Vector2.init(text_x, text_y), font_size, 1, rl.Color.black);

    // Return true if button was clicked
    return mouse_over and rl.isMouseButtonPressed(rl.MouseButton.left);
}

/// Runs the menu loop and returns the selected difficulty
/// Returns null if the player closed the window
pub fn run(self: *MainMenu) ?Difficulty.Level {
    while (!rl.windowShouldClose()) {
        // ========== KEYBOARD INPUT ==========
        // Handle up/down arrow keys to change selection
        if (rl.isKeyPressed(rl.KeyboardKey.down) or rl.isKeyPressed(rl.KeyboardKey.s)) {
            self.keyboard_selection_index = (self.keyboard_selection_index + 1) % 3; // Wrap around: 0,1,2,0,1,2...
        }
        if (rl.isKeyPressed(rl.KeyboardKey.up) or rl.isKeyPressed(rl.KeyboardKey.w)) {
            // Subtract 1, but handle wrapping (using modulo with addition to avoid negative)
            self.keyboard_selection_index = (self.keyboard_selection_index + 2) % 3; // +2 is same as -1 mod 3
        }

        // Handle Enter or Space to select
        if (rl.isKeyPressed(rl.KeyboardKey.enter) or rl.isKeyPressed(rl.KeyboardKey.space)) {
            const selected = switch (self.keyboard_selection_index) {
                0 => Difficulty.Level.easy,
                1 => Difficulty.Level.medium,
                2 => Difficulty.Level.hard,
                else => unreachable,
            };
            return selected;
        }

        rl.beginDrawing();
        rl.clearBackground(rl.Color.blue);

        // Draw animated background
        self.background.update(3.0);

        // Calculate positions for centered UI
        const button_width = 300;
        const button_height = 60;
        const button_x = @divTrunc(self.screen_width - button_width, 2);
        const spacing = 80;
        const start_y = 300;

        // Draw title
        const title: [:0]const u8 = "FLAPPY BIRD";
        const title_width = rl.measureText(title, 60);
        const title_x = @divTrunc(self.screen_width - title_width, 2);
        rl.drawText(title, title_x, 100, 60, rl.Color.white);

        // Draw subtitle
        const subtitle: [:0]const u8 = "Select Difficulty";
        const subtitle_width = rl.measureText(subtitle, 30);
        const subtitle_x = @divTrunc(self.screen_width - subtitle_width, 2);
        rl.drawText(subtitle, subtitle_x, 200, 30, rl.Color.light_gray);

        // Draw difficulty buttons (with keyboard selection highlighting)
        if (self.drawButton(button_x, start_y, button_width, button_height, "EASY", self.keyboard_selection_index == 0)) {
            return .easy;
        }

        if (self.drawButton(button_x, start_y + spacing, button_width, button_height, "MEDIUM", self.keyboard_selection_index == 1)) {
            return .medium;
        }

        if (self.drawButton(button_x, start_y + spacing * 2, button_width, button_height, "HARD", self.keyboard_selection_index == 2)) {
            return .hard;
        }

        // Draw instructions at bottom
        const instructions: [:0]const u8 = "Arrow Keys/WASD + Enter/Space or Click to start!";
        const inst_width = rl.measureText(instructions, 18);
        const inst_x = @divTrunc(self.screen_width - inst_width, 2);
        rl.drawText(instructions, inst_x, self.screen_height - 100, 18, rl.Color.white);

        rl.endDrawing();
    }

    // Window was closed
    return null;
}
