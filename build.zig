const std = @import("std");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const uSockets = b.dependency("uSockets", .{
        .target = target,
        .optimize = optimize,
    });

    const zlib = b.dependency("zlib", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addStaticLibrary(.{
        .name = "uWebSockets",
        .target = target,
        .optimize = optimize,
        .root_source_file = .{ .path = "capi/libuwebsockets.cpp" },
    });

    lib.addIncludePath(.{ .path = "capi" });
    lib.addIncludePath(.{ .path = "src" });

    lib.linkLibrary(zlib.artifact("z"));
    lib.linkLibrary(uSockets.artifact("uSockets"));
    lib.installLibraryHeaders(uSockets.artifact("uSockets"));

    lib.installHeader("capi/libuwebsockets.h", "libuwebsockets.h");

    b.installArtifact(lib);
}
