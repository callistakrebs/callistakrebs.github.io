# Advent of Code - Day 14
[< Prev Day](day13.html) [Next Day >](day15.html)

## Part 1
### My Code
```{.python .numberLines}
import re

def getPositionAndVelocity(line):
    pattern = r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)"
    return tuple(map(int,re.findall(pattern, line)[0]))

if __name__ == "__main__":
    with open("day14.txt") as f:
        robots = f.read().split("\n")
    
    pos_and_vel = []
    for robot in robots:
        pos_and_vel.append(getPositionAndVelocity(robot))
    
    grid = [[0 for i in range(101)] for i in range(103)] # 11 by 7 for debug

    for startx,starty, vx, vy in pos_and_vel:
        endx = (startx + 100*vx)%101
        endy = (starty + 100*vy)%103
        grid[endy][endx] += 1
    
    midv = len(grid) // 2
    midh = len(grid[0]) // 2

    q1 = sum(sum(row[0:midh]) for row in grid[0:midv])
    q2 = sum(sum(row[midh+1:]) for row in grid[0:midv])
    q3 = sum(sum(row[0:midh]) for row in grid[midv+1:])
    q4 = sum(sum(row[midh+1:]) for row in grid[midv+1:])

    print(q1*q2*q3*q4)
```

### ChatGPT's Improved Code
```{.python .numberLines}
import re

def parse_position_and_velocity(line):
    """
    Parse a line to extract position and velocity.
    Input format: "p=x,y v=dx,dy"
    Returns: (x, y, dx, dy) as integers
    """
    pattern = r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)"
    match = re.match(pattern, line)
    if not match:
        raise ValueError(f"Invalid input line: {line}")
    return tuple(map(int, match.groups()))

def initialize_grid(width, height):
    """Initialize a grid of given dimensions with all values set to 0."""
    return [[0] * width for _ in range(height)]

def calculate_quadrant_products(grid):
    """
    Calculate the product of sums of quadrants in the grid.
    Assumes the grid is divided into four quadrants based on midpoints.
    """
    mid_row = len(grid) // 2
    mid_col = len(grid[0]) // 2

    # Quadrants: Q1 (top-left), Q2 (top-right), Q3 (bottom-left), Q4 (bottom-right)
    q1 = sum(sum(row[:mid_col]) for row in grid[:mid_row])
    q2 = sum(sum(row[mid_col:]) for row in grid[:mid_row])
    q3 = sum(sum(row[:mid_col]) for row in grid[mid_row:])
    q4 = sum(sum(row[mid_col:]) for row in grid[mid_row:])

    return q1 * q2 * q3 * q4

if __name__ == "__main__":
    # Load robot data
    with open("day14.txt") as f:
        robots = f.read().strip().split("\n")
    
    # Parse positions and velocities
    positions_and_velocities = [parse_position_and_velocity(robot) for robot in robots]

    # Grid dimensions
    GRID_WIDTH = 101
    GRID_HEIGHT = 103

    # Initialize grid
    grid = initialize_grid(GRID_WIDTH, GRID_HEIGHT)

    # Update grid with final robot positions after 100 steps
    for start_x, start_y, velocity_x, velocity_y in positions_and_velocities:
        end_x = (start_x + 100 * velocity_x) % GRID_WIDTH
        end_y = (start_y + 100 * velocity_y) % GRID_HEIGHT
        grid[end_y][end_x] += 1

    # Calculate product of quadrant sums
    result = calculate_quadrant_products(grid)
    print(f"Result: {result}")

```

## Part 2
### My Code
```{.python .numberLines}
import re

def getPositionAndVelocity(line):
    pattern = r"p=(\d+),(\d+) v=(-?\d+),(-?\d+)"
    return tuple(map(int,re.findall(pattern, line)[0]))

if __name__ == "__main__":
    with open("day14.txt") as f:
        robots = f.read().split("\n")
    
    pos_and_vel = []
    for robot in robots:
        pos_and_vel.append(getPositionAndVelocity(robot))

    states = set()
    with open("output.txt", "w") as f:
        for i in range(7500,10404):
            grid = [["." for i in range(101)] for i in range(103)] # 11 by 7 for debug
            for startx,starty, vx, vy in pos_and_vel:
                endx = (startx + i*vx)%101
                endy = (starty + i*vy)%103
                grid[endy][endx] = "O"

            print(i, file=f)
            for row in grid:
                print(''.join(row), file=f)
```

## What I Learned
### Using Constants
* Again, the readability is improved with ChatGPT's code. ChatGPT also moved the grid dimensions to their own constants, which is helpful since these values changed when I was using my puzzle input versus the debug input (the example given in the problem).

### ChatGPT Can't Solve Everything
* Since I brute-forced Part 2 by binary searching the solution space, I tried to prompt ChatGPT to give a better solution.
* Though it had some clever suggestions about simulating the robots and analyzing the velocities and potential states, none of the code it output actually worked to solve the problem.
* Since I'm pretty late on AoC as it is, determining a more clever solution and trying to implement ChatGPT's suggestions on my own will have to wait for now.
