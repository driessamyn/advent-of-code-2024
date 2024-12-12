import data

def to_grid(str):
    return [ [a for a in line]  for line in str.split()]

def get_map(grid):
    return {(r, c): grid[r][c] for r, row in enumerate(grid) for c in range(len(row))}

def dfs(plot_map, pos, seen):
    name = plot_map[pos]
    region = []  # positions in this region
    fence = []   # fence positions and their directions
    to_visit = [pos]  # stack for DFS
    visited = set([pos]) 
    seen.add(pos)

    while to_visit:
        current = to_visit.pop()
        region.append(current)
        r, c = current

        for n in neighbours:
            new_pos = (r + n[0], c + n[1])
            if new_pos in visited:
                continue

            if new_pos in plot_map and plot_map[new_pos] == name:
                # Same region - add to DFS stack
                visited.add(new_pos)
                seen.add(new_pos)
                to_visit.append(new_pos)
            else:
                # Boundary position - add to fence
                fence.append((new_pos, n))

    return region, fence

def calculate_sides(fences):
    visited = set()
    count = 0
    for fence in fences:
        if fence in visited:
            continue # exit early

        # add one side
        count += 1

        # make sure we don't count more fences to the same side
        pos = fence[0]
        dir = fence[1]
        queue = [pos]
        visited.add(fence)
        for r,c in queue:
            for n in neighbours:
                new_pos = (r + n[0], c + n[1])
                # this is the neighbouring fence in the same area and not seen before in the same direction
                if (new_pos, dir) in fences and (new_pos, dir) not in visited:
                    queue.append(new_pos)
                    visited.add((new_pos, dir))
    return count

neighbours = ((1,0),(-1,0),(0,-1),(0,1))
def calculateFencePrice(grid):
    plot_map = get_map(grid)
    seen = set()
    price = 0
    for pos in plot_map:
        if pos in seen:
            continue
        regions, fences = dfs(plot_map, pos, seen)
        # print("Position of {}: {}, regions: {}, fences: {}".format(plot_map[pos], pos, regions, fences))
        price += len(regions) * len(fences)

    return price

def calculateFenceBulkPrice(grid):
    plot_map = get_map(grid)
    seen = set()
    price = 0
    for pos in plot_map:
        if pos in seen:
            continue
        regions, fences = dfs(plot_map, pos, seen)
        sides = calculate_sides(fences)
        # print("[{}] {}*{}={}".format(plot_map[pos], len(regions), sides, len(regions) * sides))
        price += len(regions) * sides

    return price


if __name__ == "__main__":
    grid = to_grid(data.larger_example)
    print("Part 1: {}".format(calculateFencePrice(grid)))

    grid = to_grid(data.real)
    print("Part 1: {}".format(calculateFencePrice(grid)))

    grid = to_grid(data.real)
    print("Part 2: {}".format(calculateFenceBulkPrice(grid)))