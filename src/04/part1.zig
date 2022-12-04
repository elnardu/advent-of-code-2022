const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var file = try std.fs.cwd().openFile("src/04/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var ans: usize = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.tokenize(u8, line, ",-");
        var n1l = try std.fmt.parseInt(usize, it.next().?, 10);
        var n1h = try std.fmt.parseInt(usize, it.next().?, 10);
        var n2l = try std.fmt.parseInt(usize, it.next().?, 10);
        var n2h = try std.fmt.parseInt(usize, it.next().?, 10);
        if ((n1l <= n2l and n1h >= n2h) or (n1l >= n2l and n1h <= n2h)) {
            ans += 1;
        }
    }

    try stdout.print("Answer is {d}\n", .{ans});

    try bw.flush();
}
