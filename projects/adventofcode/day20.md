# Advent of Code - Day 20
[< Prev Day](day19.html) [Next Day >](day21.html)

## Part 1
### My Code
```{.python .numberLines}
from collections import defaultdict, deque
import math
import numpy as np

CHEATCODE_LIMIT = 100

def is_in_bounds(position, nrows, ncols):
    return 0 <= position[0] < nrows and 0 <= position[1] < ncols

def build_graph(grid):
    graph = defaultdict(list)
    
    nrows = len(grid)
    ncols = len(grid[0])
    start_coord = -1
    end_coord = -1

    for i in range(nrows):
        for j in range(ncols):
            if grid[i][j] == "#":
                continue
            else:
                if grid[i][j] == "S":
                    start_coord = (i,j)
                if grid[i][j] == "E":
                    end_coord = (i,j)
                # left, right, up, down
                neighbors = [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]
                for neighbor in neighbors:
                    if is_in_bounds(neighbor, nrows, ncols) and grid[neighbor[0]][neighbor[1]] != "#":
                        graph[(i,j)].append(neighbor)
    
    return graph, start_coord, end_coord

def bfs(graph, start = (0,0)):
    queue = [start]
    visited = set([start])
    dist = {start: 0}
    path = []

    while queue:
        current = queue.pop(0)
        path.append(current)
        for neighbor in graph[current]:
            if neighbor not in visited or dist[neighbor] > dist[current] + 1:
                dist[neighbor] = dist[current] + 1
                visited.add(neighbor)
                queue.append(neighbor)    
    
    return visited, dist,path


def get_path(prev, start_i, end_i):
    if prev[start_i][end_i] == None:
        return []

    path = []
    path.append(end_i)
    while start_i != end_i:
        end_i = int(prev[start_i][end_i])
        path.append(end_i)

    return path

if __name__ == "__main__":
    with open("day20.txt") as f:
        racetrack = [list(x) for x in f.read().split("\n")]

    # Build a graph of the input space, nodes are the positions in the racetrack, edges are between adjacent spaces that arent a wall
    # All edge weights are 1
    graph, start, end = build_graph(racetrack)

    # Get path with BFS
    _, dist, path = bfs(graph, start)

    # Get pairs that are 100 moves apart
    count = 0
    for i in range(len(path)):
        candidates = path[i + CHEATCODE_LIMIT + 2:]
        
        for candidate in candidates:
            if (path[i][0] == candidate[0]) and (abs(path[i][1] - candidate[1]) == 2):
                min_v = min(path[i][1], candidate[1])
                mid = min_v + 1

                if racetrack[path[i][0]][mid] == "#":
                    count += 1

            if (path[i][1] == candidate[1]) and (abs(path[i][0] - candidate[0]) == 2):
                min_v = min(path[i][0], candidate[0])
                mid = min_v + 1

                if racetrack[mid][path[i][1]] == "#":
                    count += 1

    print(count)
```

### ChatGPT's Improved Code
```{.python .numberLines}
from collections import defaultdict, deque

MOVE_LIMIT = 100  # Steps apart to look for valid positions

def is_in_bounds(position, nrows, ncols):
    return 0 <= position[0] < nrows and 0 <= position[1] < ncols

def build_graph(grid):
    """Build graph from the racetrack grid."""
    graph = defaultdict(list)
    nrows, ncols = len(grid), len(grid[0])
    start_coord = end_coord = None

    for i in range(nrows):
        for j in range(ncols):
            if grid[i][j] == "#":
                continue
            if grid[i][j] == "S":
                start_coord = (i, j)
            if grid[i][j] == "E":
                end_coord = (i, j)
            for ni, nj in [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]:
                if is_in_bounds((ni, nj), nrows, ncols) and grid[ni][nj] != "#":
                    graph[(i, j)].append((ni, nj))

    return graph, start_coord, end_coord

def bfs(graph, start):
    """Run BFS to get distances from the start node."""
    queue = deque([start])
    visited = set([start])
    dist = {start: 0}

    while queue:
        current = queue.popleft()
        for neighbor in graph[current]:
            if neighbor not in visited:
                visited.add(neighbor)
                dist[neighbor] = dist[current] + 1
                queue.append(neighbor)

    return dist

def count_valid_pairs(dist, grid):
    """Count valid pairs of positions that are MOVE_LIMIT steps apart and blocked by a wall."""
    positions_by_dist = defaultdict(list)
    for pos, d in dist.items():
        positions_by_dist[d].append(pos)

    max_dist = max(dist.values())
    count = 0

    for d in range(max_dist - MOVE_LIMIT + 1):
        for a in positions_by_dist[d]:
            for b in positions_by_dist[d + MOVE_LIMIT]:
                if a[0] == b[0] and abs(a[1] - b[1]) == 2:
                    mid_col = (a[1] + b[1]) // 2
                    if grid[a[0]][mid_col] == "#":
                        count += 1
                elif a[1] == b[1] and abs(a[0] - b[0]) == 2:
                    mid_row = (a[0] + b[0]) // 2
                    if grid[mid_row][a[1]] == "#":
                        count += 1

    return count

if __name__ == "__main__":
    with open("day20.txt") as f:
        racetrack = [list(line) for line in f.read().strip().splitlines()]

    graph, start, end = build_graph(racetrack)
    dist = bfs(graph, start)
    result = count_valid_pairs(dist, racetrack)
    print(result)
```
## Part 2
### My Code
```{.python .numberlines}
from collections import defaultdict, deque
import math
import numpy as np

TIME_SAVED_MIN = 100

def is_in_bounds(position, nrows, ncols):
    return 0 <= position[0] < nrows and 0 <= position[1] < ncols

def build_graph(grid, walls=True):
    graph = defaultdict(list)
    
    nrows = len(grid)
    ncols = len(grid[0])
    start_coord = -1
    end_coord = -1

    for i in range(nrows):
        for j in range(ncols):
            if grid[i][j] == "#" and walls:
                continue
            else:
                if grid[i][j] == "S":
                    start_coord = (i,j)
                if grid[i][j] == "E":
                    end_coord = (i,j)
                # left, right, up, down
                neighbors = [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]
                for neighbor in neighbors:
                    if walls:
                        if is_in_bounds(neighbor, nrows, ncols) and grid[neighbor[0]][neighbor[1]] != "#":
                            graph[(i,j)].append(neighbor)
                    else:
                        if is_in_bounds(neighbor, nrows, ncols):
                            graph[(i,j)].append(neighbor)
    
    return graph, start_coord, end_coord

def bfs(graph, start = (0,0)):
    queue = [start]
    visited = set([start])
    dist = {start: 0}
    path = []

    while queue:
        current = queue.pop(0)
        path.append(current)
        for neighbor in graph[current]:
            if neighbor not in visited or dist[neighbor] > dist[current] + 1:
                dist[neighbor] = dist[current] + 1
                visited.add(neighbor)
                queue.append(neighbor)    
    
    return visited, dist,path


def get_path(prev, start_i, end_i):
    if prev[start_i][end_i] == None:
        return []

    path = []
    path.append(end_i)
    while start_i != end_i:
        end_i = int(prev[start_i][end_i])
        path.append(end_i)

    return path

if __name__ == "__main__":
    with open("day20.txt") as f:
        racetrack = [list(x) for x in f.read().split("\n")]

    # Build a graph of the input space, nodes are the positions in the racetrack, edges are between adjacent spaces that arent a wall
    # All edge weights are 1
    walled_graph, start, end = build_graph(racetrack)

    unwalled_graph, start, end = build_graph(racetrack, walls=False)


    # Get path with BFS
    _, dist, path = bfs(walled_graph, start)

    # Get pairs that are 100 moves apart
    count = 0
    bfs_cache = {}
    for i in range(len(path)):
        print(f"{i} / {len(path)} iteration")
        candidates = path[i + TIME_SAVED_MIN:]
        
        for candidate in candidates:
            curr_distance = path.index(candidate) - i # how far apart these nodes are in the path
            cheat_distance = abs(path[i][0]-candidate[0]) + abs(path[i][1]-candidate[1])

            if cheat_distance <= 20 and (curr_distance - cheat_distance >= TIME_SAVED_MIN):
                count += 1

    print(count)
```

### ChatGPT's Improved Code
```{.python .numberlines}
from collections import defaultdict, deque

TIME_SAVED_MIN = 100

def is_in_bounds(position, nrows, ncols):
    return 0 <= position[0] < nrows and 0 <= position[1] < ncols

def build_graph(grid, walls=True):
    graph = defaultdict(list)
    nrows, ncols = len(grid), len(grid[0])
    start_coord = end_coord = None

    for i in range(nrows):
        for j in range(ncols):
            if grid[i][j] == "#" and walls:
                continue
            if grid[i][j] == "S":
                start_coord = (i, j)
            if grid[i][j] == "E":
                end_coord = (i, j)

            for ni, nj in [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]:
                if is_in_bounds((ni, nj), nrows, ncols) and (not walls or grid[ni][nj] != "#"):
                    graph[(i, j)].append((ni, nj))

    return graph, start_coord, end_coord

def bfs(graph, start):
    """Standard BFS, returns a distance dict."""
    queue = deque([start])
    dist = {start: 0}
    visited = {start}

    while queue:
        current = queue.popleft()
        for neighbor in graph[current]:
            if neighbor not in visited:
                visited.add(neighbor)
                dist[neighbor] = dist[current] + 1
                queue.append(neighbor)

    return dist

if __name__ == "__main__":
    with open("day20.txt") as f:
        racetrack = [list(line) for line in f.read().strip().splitlines()]

    walled_graph, start, _ = build_graph(racetrack, walls=True)
    unwalled_graph, _, _ = build_graph(racetrack, walls=False)

    # Get main path
    dist_from_start = bfs(walled_graph, start)

    # Order nodes by their distance from start
    max_dist = max(dist_from_start.values())
    ordered_path = [None] * (max_dist + 1)
    for pos, d in dist_from_start.items():
        ordered_path[d] = pos

    count = 0

    for i in range(len(ordered_path) - TIME_SAVED_MIN):
        a = ordered_path[i]
        for j in range(i + TIME_SAVED_MIN, len(ordered_path)):
            b = ordered_path[j]

            manhattan = abs(a[0] - b[0]) + abs(a[1] - b[1])
            actual_steps = j - i

            if manhattan <= 20 and (actual_steps - manhattan >= TIME_SAVED_MIN):
                count += 1

    print(count)
```


## What I Learned
### Using a dictionary to keep track of what positions are what distance apart
* ChatGPT's cleverly used a dictionary (aka a hash table) to make it easy to look up what other positions are at least 100 steps away from the current position.
* This wasn't entirely necessary in Part 1 of this problem since there is only 1 path to get from start to end in the graph, but is good to keep in mind for other graph problems where this wouldn't be the case.
* It did help a lot to improve performance in Part 2, since the `path.index(candidate)` step is O(n).

### Using `deque.popleft()` instead of `list.pop()` in BFS
* `list.pop()` is O(n) while `deque.popleft()` is O(1)

### ChatGPT has gotten a lot smarter
* I have been mozying through the last couple of AoC problems for fun the last few months, and turns out ChatGPT's programming skills have greatly improved since December 2024.
* In my opinion it seems like it now explains a lot more without being asked. For example it included major and minor cleanups and a TLDR at the end to summarize its changes.
* It offered to help with Part 2 after I asked for improvements for my Part 1 code.
* It uses Emojis a lot now, which is fun!
* It seems like it has a better intuition about code in general; for example, giving reasonable variable name suggestions and removing code that is unused.