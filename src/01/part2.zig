const std = @import("std");
const Order = std.math.Order;

fn greaterThan(context: void, a: usize, b: usize) Order {
    _ = context;
    return std.math.order(a, b).invert();
}

pub fn main() !void {
    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(!general_purpose_allocator.deinit());

    const gpa = general_purpose_allocator.allocator();

    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var file = try std.fs.cwd().openFile("src/01/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var pq = std.PriorityQueue(usize, void, greaterThan).init(gpa, {});
    var cur: usize = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (line.len == 0) {
            try pq.add(cur);
            cur = 0;
        } else {
            cur += try std.fmt.parseInt(usize, line, 10);
        }
    }
    try pq.add(cur);

    var ans: usize = 0;
    ans += pq.remove();
    ans += pq.remove();
    ans += pq.remove();

    pq.deinit();

    try stdout.print("Answer is {d}\n", .{ans});

    try bw.flush();
}
