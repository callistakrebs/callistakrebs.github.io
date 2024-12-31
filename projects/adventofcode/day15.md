# Advent of Code - Day 15
[< Prev Day](day14.html) [Next Day >](day16.html)

## Part 1
### My Code
```{.python .numberLines}
import time

DIRECTIONS = {
    '<': (0,-1),
    '^': (-1,0),
    '>': (0,1),
    'v': (1,0)
}

def is_in_bounds(grid, r,c):
    return 0 <= r < len(grid) and 0 <= c < len(grid[0])

def display_grid(grid):
    for row in grid:
        print("".join(row))
    time.sleep(0.1)

def move_rock(grid, r, c, move):
    dr, dc = DIRECTIONS[move]
    nr, nc =  r + dr, c + dc

    if not is_in_bounds(grid, nr, nc):
        return False
    
    if grid[nr][nc] == "#":
        return False

    if grid[nr][nc] == ".":
        grid[nr][nc] = grid[r][c] # move rock over
        return True
    
    return move_rock(grid, nr, nc, move)

if __name__ == "__main__":
    with open("day15.txt") as f:
        grid, moves = tuple(f.read().split("\n\n"))
        grid = [list(x) for x in grid.split("\n")]
        moves = list(''.join(moves.split()))

    nrows = len(grid)
    ncols = len(grid[0])
    for r in range(nrows):
        for c in range (ncols):
            if grid[r][c] == "@":
                curr_r, curr_c = r,c

    for move in moves:
        dr, dc = DIRECTIONS[move]
        nr, nc = curr_r + dr, curr_c + dc
        if is_in_bounds(grid, nr, nc):
            if grid[nr][nc] == "#":
                continue # can't move here

            if grid[nr][nc] == ".":
                grid[nr][nc] = grid[curr_r][curr_c]
                grid[curr_r][curr_c] = "."
                curr_r, curr_c = nr, nc
            
            if grid[nr][nc] == "O":
                if (move_rock(grid, nr, nc, move)):
                    # move robot only if the rock moved
                    grid[nr][nc] = grid[curr_r][curr_c]
                    grid[curr_r][curr_c] = "."
                    curr_r, curr_c = nr, nc

        display_grid(grid) 

    sum = 0
    for row in range (nrows):
        for col in range (ncols):
            if grid[row][col] == "O":
                sum += 100*row + col

    print(sum)
```

## Part 2
### My Code
TBD! I still have not quite solved Day 15 Part 2...
```{.python .numberLines}
```
### ChatGPT's Improved Code
TBD! Until I can solve Day 15 part 2...
```{.python .numberLines}

```

## What I Learned
### ChatGPT Can't Fix Everything
* After several iterations and back and forth with ChatGPT, its code for Part 1 gave the wrong answer. It insisted on using an iterative approach instead of recursive for moving the rocks and never moved all the rocks correctly.
* Once I asked it to write the recursive method instead, its code was roughly the same as mine, apart from a few formatting changes, such as combining the base cases into one `if` statement in `move_rock`, and renaming `sum` to `total`.
* For this reason, I didn't include an improved ChatGPT version of the code, because in my opinion there wasn't much improvment.

### Advent of Code gets pretty hard in the back half!
* After several days of attempting Day 15 Part 2, I still can't quite iron out all the edge cases, and it seems like ChatGPT starts to struggle with the logic as well.
* So far, Days 14 and 15 were the first problems where ChatGPT couldn't really improve my code in an effective way, which to me further indicates that the problems do get quite a bit harder.
