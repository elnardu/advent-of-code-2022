const std = @import("std");

fn ch2i(ch: u8) !u6 {
    if ('a' <= ch and ch <= 'z') {
        return @truncate(u6, ch - 'a' + 1);
    } else if ('A' <= ch and ch <= 'Z') {
        return @truncate(u6, ch - 'A' + 27);
    } else {
        return error.InvalidInput;
    }
}

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    // var file = try std.fs.cwd().openFile("src/03/example", .{});
    var file = try std.fs.cwd().openFile("src/03/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var score: usize = 0;

    var common_mask: u64 = 0;
    var j: usize = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var mask: u64 = 0;
        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            var prio = try ch2i(line[i]);
            mask |= @as(u64, 1) << prio;
        }
        common_mask &= mask;
        if (j % 3 == 2) {
            score += @ctz(common_mask);
            common_mask = 0;
        } else if (j % 3 == 0) {
            common_mask = mask;
        }
        j += 1;
    }

    try stdout.print("Answer is {d}\n", .{score});

    try bw.flush();
}
