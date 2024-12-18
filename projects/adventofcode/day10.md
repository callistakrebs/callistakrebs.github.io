# Advent of Code - Day 10
[< Prev Day](day9.html) [Next Day >](day11.html)

## Part 1
### My Code
```{.python .numberLines}
def hike(grid, starting_point, peaks = None):
    startr = starting_point[0]
    startc = starting_point[1]

    if peaks is None:
        peaks = set()
    for dr, dc in directions:
        newr, newc = startr + dr, startc + dc 
        if 0 <= newr <= len(grid) - 1 and 0 <= newc <= len(grid) - 1:
            if grid[newr][newc] == grid[startr][startc] + 1:
                if grid[newr][newc] == 9:
                    peaks.add((newr, newc))
                else:
                    hike(grid, (newr,newc), peaks)
    return peaks

directions = [
    (0, -1), # up
    (0, 1), # down
    (-1, 0), #left
    (1, 0) #right

]

if __name__ == "__main__":
    with open("day10.txt") as f:
        grid = f.read().split("\n")
        grid = [list(map(int,list(row))) for row in grid]
    
    nrows = len(grid)
    ncols = len(grid[0])

    scores = {}
    for r in range(nrows):
        for c in range(ncols):
            if grid[r][c] == 0:
                reachable_peaks = hike(grid, (r,c))
                scores[(r,c)] = len(reachable_peaks)

    print(sum(scores.values()))
```
### ChatGPT's Improved Code
```{.python .numberLines}
def hike(grid, starting_point, peaks=None, visited=None):
    if peaks is None:
        peaks = set()
    if visited is None:
        visited = set()
    
    startr, startc = starting_point
    visited.add((startr, startc))
    
    for dr, dc in DIRECTIONS:
        newr, newc = startr + dr, startc + dc
        if 0 <= newr < len(grid) and 0 <= newc < len(grid[0]):
            if (newr, newc) not in visited and grid[newr][newc] == grid[startr][startc] + 1:
                if grid[newr][newc] == 9:
                    peaks.add((newr, newc))
                else:
                    hike(grid, (newr, newc), peaks, visited)
    return peaks

DIRECTIONS = [
    (0, -1),  # up
    (0, 1),   # down
    (-1, 0),  # left
    (1, 0)    # right
]

if __name__ == "__main__":
    with open("day10.txt") as f:
        grid = [list(map(int, list(row))) for row in f.read().strip().split("\n")]
    
    nrows = len(grid)
    ncols = len(grid[0])
    scores = {}

    for r in range(nrows):
        for c in range(ncols):
            if grid[r][c] == 0:
                reachable_peaks = hike(grid, (r, c))
                scores[(r, c)] = len(reachable_peaks)

    print(f"Total reachable peaks: {sum(scores.values())}")
```
## Part 2
### My Code
```{.python .numberLines}
from collections import defaultdict

def hike(grid, starting_point, peaks = None, rating = None):
    startr = starting_point[0]
    startc = starting_point[1]

    if peaks is None:
        peaks = defaultdict(int)

    for dr, dc in directions:
        newr, newc = startr + dr, startc + dc 
        if 0 <= newr <= len(grid) - 1 and 0 <= newc <= len(grid) - 1:
            if grid[newr][newc] == grid[startr][startc] + 1:
                if grid[newr][newc] == 9:
                    peaks[(newr, newc)] += 1
                else:
                    hike(grid, (newr,newc), peaks)
    return peaks

directions = [
    (0, -1), # up
    (0, 1), # down
    (-1, 0), #left
    (1, 0) #right

]

if __name__ == "__main__":
    with open("day10.txt") as f:
        grid = f.read().split("\n")
        grid = [list(map(int,list(row))) for row in grid]
    
    nrows = len(grid)
    ncols = len(grid[0])

    rating = {}
    for r in range(nrows):
        for c in range(ncols):
            if grid[r][c] == 0:
                peaks_nroutes = hike(grid, (r,c))
                rating[(r,c)] = sum(peaks_nroutes.values())

    print(sum(rating.values()))
```
### ChatGPT's Improved Code
At first attempt, ChatGPT tried to use the `visited` set implementation in Part 2 as well, but I pointed out that this won't work for Part 2, because we care about the number of distinct paths to reach the peaks (grid values of 9), and so we can't disregard states just because they had already been visited.
```{.python .numberLines}
from collections import defaultdict

def hike(grid, starting_point, peaks=None):
    if peaks is None:
        peaks = defaultdict(int)

    startr, startc = starting_point

    for dr, dc in DIRECTIONS:
        newr, newc = startr + dr, startc + dc
        if 0 <= newr < len(grid) and 0 <= newc < len(grid[0]):
            if grid[newr][newc] == grid[startr][startc] + 1:
                if grid[newr][newc] == 9:
                    peaks[(newr, newc)] += 1
                else:
                    # Recursively explore all paths
                    sub_peaks = hike(grid, (newr, newc))
                    for peak, count in sub_peaks.items():
                        peaks[peak] += count
    return peaks

DIRECTIONS = [
    (0, -1),  # up
    (0, 1),   # down
    (-1, 0),  # left
    (1, 0)    # right
]

if __name__ == "__main__":
    with open("day10.txt") as f:
        grid = [list(map(int, list(row))) for row in f.read().strip().split("\n")]

    nrows, ncols = len(grid), len(grid[0])

    ratings = {}
    for r in range(nrows):
        for c in range(ncols):
            if grid[r][c] == 0:
                peaks_nroutes = hike(grid, (r, c))
                ratings[(r, c)] = sum(peaks_nroutes.values())

    print(f"Total distinct routes to peaks: {sum(ratings.values())}")

```

## What I Learned
### Recursion with Collections
* When building a collection (list, set, dict, etc.) in place through recursion, you have to pass the collection to each recursive call to avoid nested collections being created.
* To ensure the collection is only initialized once, you can use the simple `if collection is None:` logic.

### Memoization
* ChatGPT added the `visited` set to track states that had already been visited from the trailhead in question.
* This helps avoid repeated work in the recursion, reducing the number of recursive calls being made.

### Python Constant Naming Convention
* In Python, constants are typically named with all caps. In my case, `directions` is a constant so it should be named `DIRECTIONS`.

### Unpacking Tuples
* Tuples are unpacked in one line without having to select each individual value in the tuple. 
* I knew this but forgot because I had recently been thinking about math and comparisons with tuples, which do require referencing individual values.

### Isolation of Recursive Calls
* In my implementation for Part 2, I use a global dictionary `peaks` for tracking the routes to each peak and pass this to each recursive call.
* Alternatively, ChatGPT used `sub_peaks` and merged each `sub_peaks` into the main `peaks` dictionary after each recursion.
* This doesn't make a difference in terms of time and performance, but after some back and forth, ChatGPT pointed out that it may be better for debugging and clarity if the result of each recursive call is isolated because the isolation prevents results from different recursive branches from potentially interfering with one another.
* I don't think it mattered much for this problem, but it could still be good to keep in mind when using recursion.