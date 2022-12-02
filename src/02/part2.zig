const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var file = try std.fs.cwd().openFile("src/02/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var score: usize = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var a = line[0];
        var b = line[2];

        if (a == 'A' and b == 'X') {
            score += 3;
        } else if (a == 'A' and b == 'Y') {
            score += 1;
        } else if (a == 'A' and b == 'Z') {
            score += 2;
        } else if (a == 'B' and b == 'X') {
            score += 1;
        } else if (a == 'B' and b == 'Y') {
            score += 2;
        } else if (a == 'B' and b == 'Z') {
            score += 3;
        } else if (a == 'C' and b == 'X') {
            score += 2;
        } else if (a == 'C' and b == 'Y') {
            score += 3;
        } else if (a == 'C' and b == 'Z') {
            score += 1;
        }

        if (b == 'X') {
            score += 0;
        } else if (b == 'Y') {
            score += 3;
        } else if (b == 'Z') {
            score += 6;
        }
    }

    try stdout.print("Answer is {d}\n", .{score});

    try bw.flush();
}
