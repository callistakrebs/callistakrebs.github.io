# Advent of Code - Day 12
[< Prev Day](day11.html) [Next Day >](day13.html)

## Part 1
### My Code
```{.python .numberLines}
DIRECTIONS = [
    (-1,0), # up
    (0,-1), # left
    (1,0),  # down
    (0,1),  # right
]

def get_cost(plots):
    costs = []
    for plot in plots:
        area = len(plot[1])
        perimeter = plot[2]
        costs.append(area * perimeter)
    
    total_cost = sum(costs)

    return total_cost

def get_neighbors(garden, point, visited = None, current_plot = None, perimeter=0):
    if visited is None:
        visited = set()

    if current_plot is None:
        current_plot = set()

    if point in visited:
        return current_plot, perimeter

    visited.add(point)
    current_plot.add(point)

    for dr,dc in DIRECTIONS:
        nr, nc = point[0] + dr, point[1] + dc
        if 0 <= nr < len(garden) and 0 <= nc < len(garden[0]):
            if garden[point[0]][point[1]] == garden[nr][nc]:
                _, perimeter = get_neighbors(garden, (nr,nc), visited, current_plot, perimeter=perimeter)
            # If they dont match, this position is a boundary
            else:
                perimeter += 1
        else:
            perimeter +=1
    
    return current_plot, perimeter

if __name__ == "__main__":
    with open("day12.txt") as f:
        garden = f.read().split("\n")
    
    nrows = len(garden)
    ncols = len(garden[0])

    plots = [] # values are (letter, points included in the plot), area is the length of the set
    visited = set()
    for row in range(nrows):
        for col in range(ncols):
            if (row,col) not in visited:
                curr_letter = garden[row][col]
                places, p = get_neighbors(garden, (row,col), visited=visited)
                plots.append((curr_letter, places, p))

    print(get_cost(plots))
```

### ChatGPT's Improved Code
```{.python .numberLines}
from collections import deque

DIRECTIONS = [
    (-1, 0),  # up
    (0, -1),  # left
    (1, 0),   # down
    (0, 1),   # right
]

def get_cost(plots):
    return sum(len(points) * perimeter for _, points, perimeter in plots)

def get_neighbors(garden, start, visited):
    queue = deque([start])
    current_plot = set()
    perimeter = 0
    letter = garden[start[0]][start[1]]

    while queue:
        r, c = queue.popleft()
        if (r, c) in visited:
            continue

        visited.add((r, c))
        current_plot.add((r, c))

        for dr, dc in DIRECTIONS:
            nr, nc = r + dr, c + dc
            if 0 <= nr < len(garden) and 0 <= nc < len(garden[0]):
                if garden[nr][nc] == letter:
                    if (nr, nc) not in visited:
                        queue.append((nr, nc))
                else:
                    perimeter += 1
            else:
                perimeter += 1

    return current_plot, perimeter

if __name__ == "__main__":
    try:
        with open("day12.txt") as f:
            garden = f.read().strip().split("\n")
    except FileNotFoundError:
        print("Input file 'day12.txt' not found.")
        exit(1)

    nrows, ncols = len(garden), len(garden[0])
    visited = set()
    plots = []

    for row in range(nrows):
        for col in range(ncols):
            if (row, col) not in visited:
                plot, perimeter = get_neighbors(garden, (row, col), visited)
                plots.append((garden[row][col], plot, perimeter))

    print(get_cost(plots))
```

## Part 2
### My Code
```{.python .numberLines}
DIRECTIONS = [
    (-1,0), # up
    (0,-1), # left
    (1,0),  # down
    (0,1),  # right
]

DIAGONALS = {
    (-1,-1): "up-left", # up left
    (-1, 1): "up-right", # up right
    (1, -1): "down-left", # down left
    (1, 1):  "down-right"# down right
}


def is_in_bounds(garden, r,c):
    return 0 <= r < len(garden) and 0 <= c < len(garden[0])


def get_corners(plots):
    new_plots = []
    for idx,plot in enumerate(plots):
        corners = 0
        for r,c in plot["locations"]:
            fence_needed = [False, False, False, False] # up, left, down, right
            for idx,(dr, dc) in enumerate(DIRECTIONS):
                nr, nc = r + dr, c + dc
                if (nr,nc) not in plot["locations"]:
                    fence_needed[idx] = True
            
            corners += count_corners(fence_needed)

            for idx,(dr,dc) in enumerate(DIAGONALS):
                nr, nc = r + dr, c + dc
                if (nr,nc) not in plot["locations"]:
                    if DIAGONALS[(dr,dc)] == "up-left" and not fence_needed[0] and not fence_needed[1]:
                        corners += 1
                    if DIAGONALS[(dr,dc)] == "up-right" and not fence_needed[0] and not fence_needed[3]:
                        corners += 1
                    if DIAGONALS[(dr,dc)] == "down-left" and not fence_needed[1] and not fence_needed[2]:
                        corners += 1
                    if DIAGONALS[(dr,dc)] == "down-right" and not fence_needed[3] and not fence_needed[2]:
                        corners += 1

        plot["corners"] = corners
        new_plots.append(plot)
    return new_plots

def count_corners(fence_needed):
    count = 0
    if fence_needed[0] and fence_needed[1]:
        count += 1
    if fence_needed[1] and fence_needed[2]:
        count += 1
    if fence_needed[2] and fence_needed[3]:
        count += 1
    if fence_needed[3] and fence_needed[0]:
        count += 1
    
    return count

def get_cost(plots):
    costs = []
    for plot in plots:
        area = len(plot["locations"])
        sides = plot["corners"]
        costs.append(area * sides)
    
    total_cost = sum(costs)

    return total_cost

def get_neighbors(garden, point, visited = None, current_plot = None, perimeter=0):
    if visited is None:
        visited = set()

    if current_plot is None:
        current_plot = set()

    if point in visited:
        return current_plot, perimeter

    visited.add(point)
    current_plot.add(point)

    for dr,dc in DIRECTIONS:
        nr, nc = point[0] + dr, point[1] + dc
        if 0 <= nr < len(garden) and 0 <= nc < len(garden[0]):
            if garden[point[0]][point[1]] == garden[nr][nc]:
                _, perimeter = get_neighbors(garden, (nr,nc), visited, current_plot, perimeter=perimeter)
            # If they dont match, this position is a boundary
            else:
                perimeter += 1
        else:
            perimeter +=1
    
    return current_plot, perimeter

if __name__ == "__main__":
    with open("day12.txt") as f:
        garden = f.read().split("\n")
    
    nrows = len(garden)
    ncols = len(garden[0])

    plots = [] # values are (letter, points included in the plot), area is the length of the set
    visited = set()
    for row in range(nrows):
        for col in range(ncols):
            if (row,col) not in visited:
                curr_letter = garden[row][col]
                places, perimeter = get_neighbors(garden, (row,col), visited=visited)
                plots.append({"letter":curr_letter,"locations":places, "perimeter":perimeter})

    plots_with_corners = get_corners(plots)
    print(get_cost(plots_with_corners))
```
### ChatGPT's Improved Code
```{.python .numberLines}
from collections import deque

DIRECTIONS = [
    (-1, 0),  # up
    (0, -1),  # left
    (1, 0),   # down
    (0, 1),   # right
]

DIAGONALS = [
    (-1, -1),  # up-left
    (-1, 1),   # up-right
    (1, -1),   # down-left
    (1, 1),    # down-right
]


def is_in_bounds(garden, r, c):
    return 0 <= r < len(garden) and 0 <= c < len(garden[0])


def get_cost(plots):
    return sum(len(plot["locations"]) * plot["corners"] for plot in plots)


def get_neighbors(garden, start, visited):
    queue = deque([start])
    current_plot = set()
    visited.add(start)
    letter = garden[start[0]][start[1]]

    while queue:
        r, c = queue.popleft()
        current_plot.add((r, c))

        for dr, dc in DIRECTIONS:
            nr, nc = r + dr, c + dc
            if is_in_bounds(garden, nr, nc) and garden[nr][nc] == letter and (nr, nc) not in visited:
                queue.append((nr, nc))
                visited.add((nr, nc))

    return current_plot


def count_corners(locations):
    corners = 0
    location_set = set(locations)

    for r, c in locations:
        fence_needed = [
            (r + dr, c + dc) not in location_set
            for dr, dc in DIRECTIONS
        ]

        # Count corners formed by two fences meeting
        for (idx1, idx2) in [(0, 1), (1, 2), (2, 3), (3, 0)]:
            if fence_needed[idx1] and fence_needed[idx2]:
                corners += 1

        # Check diagonal fences
        for (dr, dc), (idx1, idx2) in zip(DIAGONALS, [(0, 1), (0, 3), (2, 1), (2, 3)]):
            if (r + dr, c + dc) not in location_set and not (fence_needed[idx1] or fence_needed[idx2]):
                corners += 1

    return corners


def get_corners(plots):
    for plot in plots:
        plot["corners"] = count_corners(plot["locations"])
    return plots


if __name__ == "__main__":
    try:
        with open("day12.txt") as f:
            garden = f.read().strip().split("\n")
    except FileNotFoundError:
        print("Input file 'day12.txt' not found.")
        exit(1)

    nrows, ncols = len(garden), len(garden[0])
    visited = set()
    plots = []

    for row in range(nrows):
        for col in range(ncols):
            if (row, col) not in visited:
                locations = get_neighbors(garden, (row, col), visited)
                plots.append({
                    "letter": garden[row][col],
                    "locations": locations
                })

    plots_with_corners = get_corners(plots)
    print(get_cost(plots_with_corners))
```


## What I Learned
### Using BFS Instead of Recursion
* For part 1, Chat GPT used a BFS approach rather than the recursive function, which can save time and memory usage.
* The BFS can be implemented with a simple queue, and processes the letters for each plot iteratively.

### `while queue`
* In Python, this statement is enough to continue the `while` loop (no need for `while len(queue) > 0`)

### `zip()`
* My code for Part 2 is admittedly a mess, but I was a few days behind in Advent of Code and just wanted to get through it.
* ChatGPT's use of `zip()` is what I wanted but couldn't think of when I was writing the logic for the diagonal corners... it felt like there should be an easier way but I couldn't think of it, and just wanted to see if this logic would work.
* `zip()` takes any number of iterators as an argument and then returns the pairs of each iterator at each position. In this example, the first list was `DIAGONALS` and the second was the tuple of indices of `fence_needed` to consider for that diagonal.
* A similar concept is used in the `for` loop to count the corners, rather than an individual `if` statement for every pair.