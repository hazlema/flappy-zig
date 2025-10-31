// Difficulty.zig - Manages game difficulty settings
const std = @import("std");

/// The three difficulty levels available in the game
pub const Level = enum {
    easy,
    medium,
    hard,

    /// Returns a human-readable name for the difficulty
    pub fn getName(self: Level) []const u8 {
        return switch (self) {
            .easy => "Easy",
            .medium => "Medium",
            .hard => "Hard",
        };
    }

    /// Returns the jump amount for this difficulty
    /// Lower = weaker jumps = harder game
    pub fn getJumpAmount(self: Level) f32 {
        return switch (self) {
            .easy => 22.0, // Strongest jump - easiest to control
            .medium => 20.0, // Your current setting
            .hard => 18.0, // Weakest jump - hardest difficulty
        };
    }

    /// Returns the gap size between pipes for this difficulty
    /// You can expand this later for more difficulty variations
    pub fn getObstacleGap(self: Level) f32 {
        return switch (self) {
            .easy => 200.0, // Larger gap
            .medium => 180.0, // Medium gap
            .hard => 160.0, // Smaller gap
        };
    }
};
