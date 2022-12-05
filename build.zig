const std = @import("std");

const Target = struct {
    exeName: []const u8,
    exeMain: []const u8,

    fn new(exeName: []const u8, exeMain: []const u8) Target {
        return Target{
            .exeName = exeName,
            .exeMain = exeMain,
        };
    }
};

pub fn build(b: *std.build.Builder) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const mode = b.standardReleaseOptions();

    const targets = [_]Target{
        Target.new("01-part1", "src/01/part1.zig"),
        Target.new("01-part2", "src/01/part2.zig"),
        Target.new("02-part1", "src/02/part1.zig"),
        Target.new("02-part2", "src/02/part2.zig"),
        Target.new("03-part1", "src/03/part1.zig"),
        Target.new("03-part2", "src/03/part2.zig"),
        Target.new("04-part1", "src/04/part1.zig"),
        Target.new("04-part2", "src/04/part2.zig"),
        Target.new("05-part1", "src/05/part1.zig"),
        Target.new("05-part2", "src/05/part2.zig"),
    };

    for (targets) |t| {
        const exe = b.addExecutable(t.exeName, t.exeMain);
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.install();
    }
}
