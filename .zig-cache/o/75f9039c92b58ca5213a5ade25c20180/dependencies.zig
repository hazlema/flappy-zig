pub const packages = struct {
    pub const @"N-V-__8AABHMqAWYuRdIlflwi8gksPnlUMQBiSxAqQAAZFms" = struct {
        pub const available = false;
    };
    pub const @"N-V-__8AAJl1DwBezhYo_VE6f53mPVm00R-Fk28NPW7P14EQ" = struct {
        pub const build_root = "/home/frosty/.cache/zig/p/N-V-__8AAJl1DwBezhYo_VE6f53mPVm00R-Fk28NPW7P14EQ";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"N-V-__8AALUbbwDKkSH4nbf3Ml_dTWo9qbELvle5i9eQZMuo" = struct {
        pub const build_root = "/home/frosty/.cache/zig/p/N-V-__8AALUbbwDKkSH4nbf3Ml_dTWo9qbELvle5i9eQZMuo";
        pub const deps: []const struct { []const u8, []const u8 } = &.{};
    };
    pub const @"libs/raylib-zig" = struct {
        pub const build_root = "/home/frosty/zig/flappy/Zig/libs/raylib-zig";
        pub const build_zig = @import("libs/raylib-zig");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "raylib", "raylib-5.6.0-dev-whq8uCg2ywTzCiX3VEP9RuCMXR6_VnDBmkj8GjL_p5QN" },
            .{ "raygui", "N-V-__8AALUbbwDKkSH4nbf3Ml_dTWo9qbELvle5i9eQZMuo" },
            .{ "emsdk", "N-V-__8AAJl1DwBezhYo_VE6f53mPVm00R-Fk28NPW7P14EQ" },
            .{ "zemscripten", "zemscripten-0.2.0-dev-sRlDqFJSAAB8hgnRt5DDMKP3zLlDtMnUDwYRJVCa5lGY" },
        };
    };
    pub const @"raylib-5.6.0-dev-whq8uCg2ywTzCiX3VEP9RuCMXR6_VnDBmkj8GjL_p5QN" = struct {
        pub const build_root = "/home/frosty/.cache/zig/p/raylib-5.6.0-dev-whq8uCg2ywTzCiX3VEP9RuCMXR6_VnDBmkj8GjL_p5QN";
        pub const build_zig = @import("raylib-5.6.0-dev-whq8uCg2ywTzCiX3VEP9RuCMXR6_VnDBmkj8GjL_p5QN");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
            .{ "xcode_frameworks", "N-V-__8AABHMqAWYuRdIlflwi8gksPnlUMQBiSxAqQAAZFms" },
            .{ "emsdk", "N-V-__8AAJl1DwBezhYo_VE6f53mPVm00R-Fk28NPW7P14EQ" },
            .{ "zemscripten", "zemscripten-0.2.0-dev-sRlDqApRAACspTbAZnuNKWIzfWzSYgYkb2nWAXZ-tqqt" },
        };
    };
    pub const @"zemscripten-0.2.0-dev-sRlDqApRAACspTbAZnuNKWIzfWzSYgYkb2nWAXZ-tqqt" = struct {
        pub const build_root = "/home/frosty/.cache/zig/p/zemscripten-0.2.0-dev-sRlDqApRAACspTbAZnuNKWIzfWzSYgYkb2nWAXZ-tqqt";
        pub const build_zig = @import("zemscripten-0.2.0-dev-sRlDqApRAACspTbAZnuNKWIzfWzSYgYkb2nWAXZ-tqqt");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
    pub const @"zemscripten-0.2.0-dev-sRlDqFJSAAB8hgnRt5DDMKP3zLlDtMnUDwYRJVCa5lGY" = struct {
        pub const build_root = "/home/frosty/.cache/zig/p/zemscripten-0.2.0-dev-sRlDqFJSAAB8hgnRt5DDMKP3zLlDtMnUDwYRJVCa5lGY";
        pub const build_zig = @import("zemscripten-0.2.0-dev-sRlDqFJSAAB8hgnRt5DDMKP3zLlDtMnUDwYRJVCa5lGY");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "raylib_zig", "libs/raylib-zig" },
};
