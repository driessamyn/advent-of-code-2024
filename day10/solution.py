from collections import defaultdict

import data

def parse(input):
    return [
        [-10 if c == "." else int(c) for c in l]
        for l in input.strip().split("\n")
    ]

def findtrails(grid, frm, to, unique = False):
    seen = {}
    trail_starts = defaultdict(list)
    width, depth = len(grid[0]), len(grid)

    print("{} x {} grid".format(width, depth))


    def travel(r, c, trail_start):
        if not (0 <= r < depth and 0 <= c < width):  # Check bounds
            return 0
        here = grid[r][c]
        if here == to:
            # wasted so much time on this. It's the count of ends that was asked in part 1, not the count of paths.
            # So a bit an odd solution maybe, but quickest "fix"
            if (r, c) not in trail_starts[trail_start]:
                trail_starts[trail_start].append((r, c))
            return 1
        if not unique or (r, c) not in seen:
            neighbours = [
                (r - 1, c) if r > 0 and grid[r - 1][c] == here + 1 else None,
                (r + 1, c) if r < depth - 1 and grid[r + 1][c] == here + 1 else None,
                (r, c - 1) if c > 0 and grid[r][c - 1] == here + 1 else None,
                (r, c + 1) if c < width - 1 and grid[r][c + 1] == here + 1 else None,
            ]
            seen[(r, c)] = sum(
                travel(nr, nc, trail_start)
                for neighbour in neighbours if neighbour
                for nr, nc in [neighbour]
            )
        return seen[(r, c)]

    count = 0
    for ri, row in enumerate(grid):
        for ci, val in enumerate(row):
            if val == frm:
                trail_starts[(ri, ci)] = []
                count += travel(ri, ci, (ri, ci))
    if unique:
        return count
    return sum(len(trails) for trails in trail_starts.values())

if __name__ == "__main__":
    # grd = parse(data.simple_test)
    # print(grd)
    # print(part1(grd,9,0))
    # print(part1(parse(data.simple_test2),0,9))
    # print(part1(parse(data.input),0,9))
    # part 1
    print(findtrails(parse(data.realInput),0,9))
    # part 2
    print(findtrails(parse(data.realInput),0,9, True))