const std = @import("std");


fn ch2i(ch: u8) !u5 {
    if ('a' <= ch and ch <= 'z') {
        return @truncate(u5, ch - 'a' + 1);
    } else {
        return error.InvalidInput;
    }
}

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var file = try std.fs.cwd().openFile("src/06/input", .{});
    // var file = try std.fs.cwd().openFile("src/06/example", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var ans: usize = 0;

    var ring = @Vector(14, u32){0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    var ringI: usize = 0;

    var i: usize = 0;
    while (in_stream.readByte()) |ch| {
        ring[ringI] = @as(u32, 1) << try ch2i(ch);
        ringI = (ringI + 1) % 14;
        i += 1;
        if (@popCount(@reduce(.Or, ring)) == 14) {
            ans = i;
            break;
        }
    } else |err| {
        if (err != error.EndOfStream) {
            return err;
        }
    }

    try stdout.print("Answer is {d}\n", .{ans});

    try bw.flush();
}
