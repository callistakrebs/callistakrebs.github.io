# Advent of Code - Day 8
[< Prev Day](day7.html) [Next Day >](day9.html)

## Part 1
### My Code
```{.python .numberLines}
from collections import defaultdict
from itertools import combinations

def subtract_tuples(a:tuple, b:tuple):
    return (a[0]-b[0], a[1]-b[1])

def add_tuples(a:tuple, b:tuple):
    return (a[0]+b[0], a[1]+b[1])

with open("day8.txt") as f:
    grid = f.read().split("\n")

nrows = len(grid)
ncols = len(grid[0])

antennaes = defaultdict(list)
for i in range(nrows):
    for j in range(ncols):
        if grid[i][j] != ".":
            antennaes[grid[i][j]].append((i,j))

antinodes = set()
for antennae in antennaes:
    pairs = combinations(antennaes[antennae], r=2)
    for pair in pairs:
        distance = subtract_tuples(pair[0],pair[1])
        candidates = (add_tuples(pair[0],distance), subtract_tuples(pair[1], distance))

        if 0 <= candidates[0][0] <= nrows - 1 and 0 <= candidates[0][1] <= ncols - 1:
            antinodes.add(candidates[0])

        if 0 <= candidates[1][0] <= nrows - 1 and 0 <= candidates[1][1] <= ncols - 1:
            antinodes.add(candidates[1])

print(len(antinodes))
```
### ChatGPT's Improved Code
```{.python .numberLines}
from collections import defaultdict
from itertools import combinations

def subtract_tuples(a: tuple, b: tuple):
    """Subtract tuple b from tuple a."""
    return (a[0] - b[0], a[1] - b[1])

def add_tuples(a: tuple, b: tuple):
    """Add tuples a and b."""
    return (a[0] + b[0], a[1] + b[1])

def is_within_bounds(point: tuple, nrows: int, ncols: int):
    """Check if a point is within the grid bounds."""
    return 0 <= point[0] < nrows and 0 <= point[1] < ncols

def find_antinodes(grid):
    """Find the number of unique antinodes in the grid."""
    nrows = len(grid)
    ncols = len(grid[0])

    # Group antennae positions by type
    antennaes = defaultdict(list)
    for i in range(nrows):
        for j in range(ncols):
            if grid[i][j] != ".":
                antennaes[grid[i][j]].append((i, j))

    antinodes = set()

    # Process each antenna type
    for positions in antennaes.values():
        if len(positions) < 2:
            continue  # No pairs possible

        # Generate all pairs of positions
        for p1, p2 in combinations(positions, 2):
            distance = subtract_tuples(p2, p1)

            # Extrapolate in both directions
            candidates = [
                add_tuples(p1, distance),  # Extend from p1
                subtract_tuples(p2, distance)  # Extend from p2
            ]

            # Add valid candidates to the set
            for candidate in candidates:
                if is_within_bounds(candidate, nrows, ncols):
                    antinodes.add(candidate)

    return len(antinodes)

# Read input grid
with open("day8.txt") as f:
    grid = [list(line.strip()) for line in f.readlines()]

# Calculate and print result
result = find_antinodes(grid)
print(result)
```
## Part 2
### My Code
```{.python .numberLines}
from collections import defaultdict
from itertools import combinations

def subtract_tuples(a:tuple, b:tuple):
    return (a[0]-b[0], a[1]-b[1])

def add_tuples(a:tuple, b:tuple):
    return (a[0]+b[0], a[1]+b[1])

with open("day8.txt") as f:
    grid = f.read().split("\n")

nrows = len(grid)
ncols = len(grid[0])

antennaes = defaultdict(list)
for i in range(nrows):
    for j in range(ncols):
        if grid[i][j] != ".":
            antennaes[grid[i][j]].append((i,j))

antinodes = set()
for antennae in antennaes:
    pairs = combinations(antennaes[antennae], r=2)
    for pair in pairs:
        distance = subtract_tuples(pair[0],pair[1])

        curr_row, curr_col = (pair[0])
        while 0 <= curr_row <= nrows - 1 and 0 <= curr_col <= ncols -1:
            antinodes.add((curr_row,curr_col))
            curr_row, curr_col = add_tuples((curr_row,curr_col),distance)

        curr_row, curr_col = (pair[1])
        while 0 <= curr_row <= nrows - 1 and 0 <= curr_col <= ncols -1:
            antinodes.add((curr_row,curr_col))
            curr_row, curr_col = subtract_tuples((curr_row,curr_col),distance)

print(len(antinodes))
```
### ChatGPT's Improved Code
```{.python .numberLines}
from collections import defaultdict
from itertools import combinations

def subtract_tuples(a: tuple, b: tuple):
    """Subtract tuple b from tuple a."""
    return (a[0] - b[0], a[1] - b[1])

def add_tuples(a: tuple, b: tuple):
    """Add tuples a and b."""
    return (a[0] + b[0], a[1] + b[1])

def is_within_bounds(point: tuple, nrows: int, ncols: int):
    """Check if a point is within the grid bounds."""
    return 0 <= point[0] < nrows and 0 <= point[1] < ncols

def find_antinodes_with_traversal(grid):
    """Find the number of unique antinodes with traversal along antenna paths."""
    nrows = len(grid)
    ncols = len(grid[0])

    # Group antennae positions by type
    antennaes = defaultdict(list)
    for i in range(nrows):
        for j in range(ncols):
            if grid[i][j] != ".":
                antennaes[grid[i][j]].append((i, j))

    antinodes = set()

    # Process each antenna type
    for positions in antennaes.values():
        if len(positions) < 2:
            continue  # No pairs possible

        # Generate all pairs of positions
        for p1, p2 in combinations(positions, 2):
            distance = subtract_tuples(p2, p1)

            # Traverse in both directions
            for start_point, step in [(p1, distance), (p2, subtract_tuples((0, 0), distance))]:
                current = start_point
                while is_within_bounds(current, nrows, ncols):
                    antinodes.add(current)
                    current = add_tuples(current, step)

    return len(antinodes)

# Read input grid
with open("day8.txt") as f:
    grid = [list(line.strip()) for line in f.readlines()]

# Calculate and print result
result = find_antinodes_with_traversal(grid)
print(result)
```

## What I Learned
### Tuple Comparisons
* Trying to be more "Pythonic" I thought I could be clever and compare each point to (0,0) and (nrows, ncols) directly like `(0,0) <= point <= (nrows, ncols)` to check if a point is in bounds of the grid. 
* Tuple comparisons are elementwise, so when comparing if 2 tuples are < or > the first elements of each tuple are compared. If the < or > condition is satisfied by the first element comparison, then the comparison is done. For example (5,12) < (10,10) returns True, because 5 < 10. 
* This can be interpreted as if the tuples are points on a grid, then < means the first point shows up "before" the second point, if we were traversing the grid by rows then columns.

### Breaking Early
* Similar to Day 7, we can skip antennae that don't have more than one instance, since there are no pairs.

### Small Improvements
* ChatGPT's version for Part 1 has a few more function definitions than mine, and a loop definition using `for p1, p2 in combinations(positions)`.
* Also a cleaner loop definition using `anntenaes.values()`, since we don't ever actually need the key of each antennae
* Using the for loop for Part 2's code improves the readability and avoids using redundant code (`for start_point, step in [(p1, distance), (p2, subtract_tuples((0, 0), distance))]:`)