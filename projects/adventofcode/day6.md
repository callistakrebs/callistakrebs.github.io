# Advent of Code - Day 6
[< Prev Day](day5.html) [Next Day >](day7.html)

## Part 1
### My Code
```{.python .numberLines}
import copy

with open("day6.txt") as f:
    map = f.read().split("\n")
    map = [list(row) for row in map]

    route = copy.deepcopy(map)
    
    for i in range(len(map)):
        for j in range(len(map[i])):
            if map[i][j] == "^":
                start = (i,j)
                route[i][j] = "X"
 
    i, j = start
    curr_direction = "up"
    count = 0
    while i < len(map) and j < len(map[i]) and i >= 0 and j >= 0:
        if map[i][j] == "#":
            if curr_direction == "up":
                i += 1
                curr_direction = "right"
            elif curr_direction == "right":
                j -= 1
                curr_direction = "down"
            elif curr_direction == "down":
                i -= 1
                curr_direction = "left"
            elif curr_direction == "left":
                j += 1
                curr_direction = "up"
        else:
            route[i][j] = "X"
        
        if curr_direction == "up":
            i -= 1
        if curr_direction == "down":
            i += 1
        if curr_direction == "left":
            j -= 1
        if curr_direction == "right":
            j += 1

count = 0 
for line in route:
    for j in range(len(route)):
        if line[j] == "X":
            count+=1

print(count)
```
### ChatGPT's Not So Improved Version...
At first attempt, ChatGPT output the code below, however, I noticed that this code made the same mistake I had during my developing... once the guard comes across an "X", its next move continues from the index of the X and not the guard's previous position. 
```{.python .numberLines}
with open("day6.txt") as f:
    grid = [list(row) for row in f.read().splitlines()]

# Locate the starting point
for i, row in enumerate(grid):
    for j, cell in enumerate(row):
        if cell == "^":
            start = (i, j)
            break

# Direction mappings: (row_delta, col_delta) for each direction
directions = {
    "up": (-1, 0),
    "right": (0, 1),
    "down": (1, 0),
    "left": (0, -1),
}
order = ["up", "right", "down", "left"]  # Order of direction rotation

# Traverse the grid
i, j = start
curr_direction = "up"

while 0 <= i < len(grid) and 0 <= j < len(grid[0]):
    # Mark the route
    if grid[i][j] != "#":
        grid[i][j] = "X"
    else:
        # Rotate direction clockwise if hitting a wall
        curr_idx = order.index(curr_direction)
        curr_direction = order[(curr_idx + 1) % 4]

    # Move in the current direction
    di, dj = directions[curr_direction]
    i += di
    j += dj

# Count all the "X" marks
count = sum(row.count("X") for row in grid)
print(count)
```
### ChatGPT's Improved Code
After pointing this out to ChatGPT, he output the following, actually improved code:
```{.python .numberLines}
with open("day6.txt") as f:
    grid = [list(row) for row in f.read().splitlines()]

# Locate the starting point
for i, row in enumerate(grid):
    for j, cell in enumerate(row):
        if cell == "^":
            start = (i, j)
            break

# Direction mappings: (row_delta, col_delta) for each direction
directions = {
    "up": (-1, 0),
    "right": (0, 1),
    "down": (1, 0),
    "left": (0, -1),
}
order = ["up", "right", "down", "left"]  # Order of direction rotation

# Traverse the grid
i, j = start
curr_direction = "up"

while 0 <= i < len(grid) and 0 <= j < len(grid[0]):
    # Check if current cell is a wall
    if grid[i][j] == "#":
        # Rotate direction clockwise
        curr_idx = order.index(curr_direction)
        curr_direction = order[(curr_idx + 1) % 4]

        # Undo the previous movement
        di, dj = directions[curr_direction]
        i -= di
        j -= dj
        continue

    # Mark the route
    grid[i][j] = "X"

    # Move in the current direction
    di, dj = directions[curr_direction]
    i += di
    j += dj

# Count all the "X" marks
count = sum(row.count("X") for row in grid)
print(count)
```

## Part 2
### My Code
```{.python .numberLines}
import copy

with open("day6.txt") as f:
    map = f.read().split("\n")
    map = [list(row) for row in map]

    route = copy.deepcopy(map)
    
    for i in range(len(map)):
        for j in range(len(map[i])):
            if map[i][j] == "^":
                start = (i,j)
                # route[i][j] = "X"

    i, j = start
    curr_direction = "up"

    count = 0
    for k in range(len(map)):
        for m in range(len(map[k])):
            route = copy.deepcopy(map)
            i, j = start
            curr_direction = "up"
            loop = False
            barriers_found = {}
            while i < len(map) and j < len(map[i]) and i >= 0 and j >= 0 and not loop:
                if (i,j) in barriers_found and barriers_found[(i,j)] == curr_direction:
                    # we are at a barrier we have hit before
                    loop = True
                    count += 1
                
                else:
                    if map[i][j] == "#" or (i,j) == (k,m):
                        barriers_found[(i,j)] = curr_direction
                        if curr_direction == "up":
                            i += 1
                            curr_direction = "right"
                        elif curr_direction == "right":
                            j -= 1
                            curr_direction = "down"
                        elif curr_direction == "down":
                            i -= 1
                            curr_direction = "left"
                        elif curr_direction == "left":
                            j += 1
                            curr_direction = "up"
                    else:
                        if curr_direction == "left" or curr_direction == "right":
                            if route[i][j] == ".":
                                route[i][j] = "-"
                                
                            if route[i][j] == "|":
                                route[i][j] = "+"

                        if curr_direction == "up" or curr_direction == "down":
                            if route[i][j] == ".":
                                route[i][j] = "|"

                            if route[i][j] == "-":
                                route[i][j] = "+"


                    if curr_direction == "up":
                        i -= 1
                    if curr_direction == "down":
                        i += 1
                    if curr_direction == "left":
                        j -= 1
                    if curr_direction == "right":
                        j += 1

print(count)
```
### ChatGPT's Improved Code
```{.python .numberLines}
with open("day6.txt") as f:
    grid = [list(row) for row in f.read().splitlines()]

# Locate the starting point
for i, row in enumerate(grid):
    for j, cell in enumerate(row):
        if cell == "^":
            start = (i, j)
            break

directions = {
    "up": (-1, 0),
    "right": (0, 1),
    "down": (1, 0),
    "left": (0, -1),
}
direction_order = ["up", "right", "down", "left"]

count = 0

# Iterate over each possible barrier position
for k in range(len(grid)):
    for m in range(len(grid[0])):
        visited_states = set()
        i, j = start
        curr_direction = "up"
        loop_detected = False

        while 0 <= i < len(grid) and 0 <= j < len(grid[0]) and not loop_detected:
            # State includes position and direction
            state = (i, j, curr_direction)

            # Detect loop
            if state in visited_states:
                loop_detected = True
                count += 1
                break
            visited_states.add(state)

            # Handle barriers (including potential temporary barrier at (k, m))
            if grid[i][j] == "#" or (i, j) == (k, m):
                # Rotate direction clockwise
                curr_idx = direction_order.index(curr_direction)
                curr_direction = direction_order[(curr_idx + 1) % 4]
            else:
                # Move in the current direction
                di, dj = directions[curr_direction]
                i += di
                j += dj

print(count)
```

## What I learned
### Definition of a Shallow Copy
* Shallow copy of a list duplicates the outer list, but the elements inside the list are still referenced to the same items in the original list
* So if you have a list of lists (to be an array) and you copy it, only the rows are duplicated, but each item in each row has a shared reference
* So if you update an item in one array, they both update
* Instead we can use `copy.deepcopy()`
* While this was great to learn, it was actually unnecessary for this problem because there is no reason to preserve the original map

### Clever Use of % To Rotate 90 degrees
* By using the `order` list, we can avoid the use of redundant `if` statements using the clever `%` indexing.
* Basically if you are going any direction besides left, you are just going to move to the next index in `order`
* Using `%` lets you wrap back around to the front of the list when you are at the end.

### Use Direction Vectors
* Same as Day 4, but I was catching up on the challenges and took a few days off from asking for ChatGPT's improvements between solving these.

### Don't _____ when you don't need to 
* Don't copy when you don't need to: I originally copied the map into route in case it was needed separately but it never was. Nice to understand the difference between deep and shallow copy, but in practice better to save the space and time spent copying when its not needed.
* Don't draw the route when you don't need to: once I figured out part 2, the key point in the solution was tracking the visited states. In my case, I had to track the barriers I've hit and there was no need for the previous route information anyway. But ChatGPT's method was much smarter and simpler; by tracking the state as direction + position, we don't need to know anything about the route, and can simply use the visited states to know if we created a loop.
* Don't blindly trust ChatGPT's code when you don't need to (and you never need to)(and really shouldn't ever): using ChatGPT is a great learning experience for something like Advent of Code and trying to improve your skills, but it makes mistakes too! Never trust a solution (from ChatGPT or anywhere) without understanding the code.