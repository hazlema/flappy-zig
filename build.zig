const std = @import("std");
const raylib_zig = @import("raylib_zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Add raylib-zig dependency
    const raylib_dep = b.dependency("raylib_zig", .{
        .target = target,
        .optimize = optimize,
    });

    const raylib = raylib_dep.module("raylib");
    const raylib_artifact = raylib_dep.artifact("raylib");

    // Handle WASM builds differently
    if (target.result.os.tag == .emscripten) {
        const emsdk = raylib_zig.emsdk;

        const wasm_lib = b.addLibrary(.{
            .name = "flappy",
            .root_module = b.createModule(.{
                .root_source_file = b.path("src/main.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "raylib", .module = raylib },
                },
            }),
        });

        const install_dir: std.Build.InstallDir = .{ .custom = "web" };
        const emcc_flags = emsdk.emccDefaultFlags(b.allocator, .{
            .optimize = optimize,
        });
        const emcc_settings = emsdk.emccDefaultSettings(b.allocator, .{
            .optimize = optimize,
        });

        // Get shell.html from raylib dependency
        const shell_file_path = b.dependency("raylib", .{}).path("src/shell.html");

        const emcc_step = emsdk.emccStep(b, raylib_artifact, wasm_lib, .{
            .optimize = optimize,
            .flags = emcc_flags,
            .settings = emcc_settings,
            .shell_file_path = shell_file_path,
            .install_dir = install_dir,
            .embed_paths = &.{.{ .src_path = "assets/" }},
        });

        b.getInstallStep().dependOn(emcc_step);

        const html_filename = try std.fmt.allocPrint(b.allocator, "{s}.html", .{wasm_lib.name});
        const emrun_step = emsdk.emrunStep(
            b,
            b.getInstallPath(install_dir, html_filename),
            &.{},
        );

        emrun_step.dependOn(emcc_step);

        const run_step = b.step("run", "Run the app in browser");
        run_step.dependOn(emrun_step);
    } else {
        // Native build
        const exe = b.addExecutable(.{
            .name = "flappy",
            .root_module = b.createModule(.{
                .root_source_file = b.path("src/main.zig"),
                .target = target,
                .optimize = optimize,
                .imports = &.{
                    .{ .name = "raylib", .module = raylib },
                },
            }),
        });

        exe.linkLibrary(raylib_artifact);

        b.installArtifact(exe);

        const run_cmd = b.addRunArtifact(exe);
        run_cmd.step.dependOn(b.getInstallStep());

        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_step = b.step("run", "Run the app");
        run_step.dependOn(&run_cmd.step);
    }
}
