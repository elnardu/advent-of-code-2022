const std = @import("std");

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var general_purpose_allocator = std.heap.GeneralPurposeAllocator(.{}){};
    const gpa = general_purpose_allocator.allocator();

    var file = try std.fs.cwd().openFile("src/05/input", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    const Stack = std.ArrayList(u8);
    const nStacks = 9;
    var stacks: [nStacks]Stack = undefined;
    {
        var i: usize = 0;
        while (i < nStacks) : (i += 1) {
            stacks[i] = try Stack.initCapacity(gpa, 64);
        }
    }

    outer: while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var i: usize = 0;
        while (i < line.len) : (i += 1) {
            var ch = line[i];
            if (ch >= 'A' and ch <= 'Z') {
                var stackIdx = (i - 1) / 4;
                try stacks[stackIdx].append(ch);
            } else if (ch >= '1' and ch <= '9') {
                break :outer;
            }
        }
    }
    _ = try in_stream.readUntilDelimiterOrEof(&buf, '\n');

    for (stacks) |stack| {
        var i: usize = 0;
        while (i < stack.items.len / 2) : (i += 1) {
            var tmp = stack.items[i];
            stack.items[i] = stack.items[stack.items.len - 1 - i];
            stack.items[stack.items.len - 1 - i] = tmp;
        }
    }

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.split(u8, line, " ");
        _ = it.next();
        var count = try std.fmt.parseInt(usize, it.next().?, 10);
        _ = it.next();
        var from = try std.fmt.parseInt(usize, it.next().?, 10) - 1;
        _ = it.next();
        var to = try std.fmt.parseInt(usize, it.next().?, 10) - 1;

        while (count > 0) : (count -= 1) {
            try stacks[to].append(stacks[from].pop());
        }
    }

    try stdout.print("Answer is ", .{});
    for (stacks) |stack| {
        try stdout.print("{c}", .{stack.items[stack.items.len - 1]});
    }
    try stdout.print("\n", .{});

    try bw.flush();
}
