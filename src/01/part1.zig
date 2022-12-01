const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var file = try std.fs.cwd().openFile("src/01/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var max: usize = 0;
    var cur: usize = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            max = @max(max, cur);
            cur = 0;
        } else {
            cur += try std.fmt.parseInt(usize, line, 10);
        }
    }

    max = @max(max, cur);

    try stdout.print("Answer is {d}\n", .{max});

    try bw.flush();
}
