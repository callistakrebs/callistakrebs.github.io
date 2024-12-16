# Advent of Code - Day 4
[< Prev Day](day3.html) [Next Day >](day5.html)

## Part 1
### My Code
```{.python .numberLines}
with open("day4.txt") as f:
    wordsearch = f.read().split("\n")
    
    count = 0
    for i in range(len(wordsearch)):
        for j in range (len(wordsearch[i])):
            if wordsearch[i][j] == "X":
                left_up = wordsearch[i][j]
                left_down = wordsearch[i][j]
                right_up = wordsearch[i][j]
                right_down = wordsearch[i][j]
                up = wordsearch[i][j]
                down = wordsearch[i][j]
                left = wordsearch[i][j]
                right = wordsearch[i][j]

                for k in range(1,4):
                    if (i - k) >= 0 and (j - k) >= 0:
                        left_up += wordsearch[i - k][j - k] # build string back diagnol
                    
                    if (j - k) >= 0 and (i + k) <= len(wordsearch) - 1:
                        left_down += wordsearch[i + k][j - k]
                    
                    if (i - k) >= 0 and (j + k) <= len(wordsearch[i]) - 1:
                        right_up += wordsearch[i - k][j + k]
                    
                    if (i + k) <= len(wordsearch) - 1 and (j + k) <= len(wordsearch[i]) - 1:
                        right_down += wordsearch[i + k][j + k]
                    
                    if (i - k) >= 0:
                        up += wordsearch[i - k][j]
                    
                    if (i + k) <= len(wordsearch) - 1:
                        down += wordsearch[i + k][j]
                    
                    if (j - k) >= 0:
                        left += wordsearch[i][j - k]
                    
                    if (j + k) <= len(wordsearch[i]) - 1:
                        right += wordsearch[i][j + k]
            
                candidates = [up, down, left, right, left_down, left_up, right_down, right_up]
                count += sum(x == "XMAS" for x in candidates)

print(count)
```
### Chat GPT's Improved Version
```{.python .numberLines}
with open("day4.txt") as f:
    wordsearch = f.read().split("\n")
    
rows = len(wordsearch)
cols = len(wordsearch[0]) if rows > 0 else 0

# Define direction vectors: (row_offset, col_offset)
directions = [
    (-1, 0), (1, 0),  # Up, Down
    (0, -1), (0, 1),  # Left, Right
    (-1, -1), (1, 1), # Left-Up, Right-Down
    (-1, 1), (1, -1)  # Right-Up, Left-Down
]

target = "XMAS"
target_length = len(target)
count = 0

for i in range(rows):
    for j in range(cols):
        if wordsearch[i][j] == target[0]:  # Start checking only if the first character matches
            for dr, dc in directions:
                candidate = []
                for k in range(target_length):
                    ni, nj = i + k * dr, j + k * dc
                    if 0 <= ni < rows and 0 <= nj < cols:
                        candidate.append(wordsearch[ni][nj])
                    else:
                        break
                if ''.join(candidate) == target:
                    count += 1

print(count)
```
## Part 2
### My Code
```{.python .numberLines}
with open("day4.txt") as f:
    wordsearch = f.read().split("\n")
    
    count = 0
    for i in range(len(wordsearch)):
        for j in range (len(wordsearch[i])):
            if wordsearch[i][j] == "A":
                if (i - 1) >= 0 and (j - 1) >= 0 and (i + 1) <= len(wordsearch) - 1 and (j + 1) <= len(wordsearch[i]) - 1:
                    left_diag = wordsearch[i - 1][j - 1] + wordsearch[i][j] + wordsearch[i + 1][j + 1]
                    right_diag = wordsearch[i - 1][j + 1] + wordsearch[i][j] + wordsearch[i + 1][j - 1]
                
                    if (left_diag == "SAM" or left_diag == "MAS") and (right_diag == "SAM" or right_diag == "MAS"):
                        count+=1

print(count)
```
### Chat GPT's Improved Version
```{.python .numberLines}
with open("day4.txt") as f:
    wordsearch = f.read().split("\n")

rows = len(wordsearch)
cols = len(wordsearch[0]) if rows > 0 else 0

# Define valid patterns for diagonals
valid_patterns = {"SAM", "MAS"}

# Initialize count
count = 0

# Iterate through the grid
for i in range(1, rows - 1):  # Start at 1 and end at rows-2 to avoid out-of-bounds checks
    for j in range(1, cols - 1):  # Similarly, stay within bounds for columns
        if wordsearch[i][j] == "A":  # Only process cells with 'A'
            # Build diagonal strings
            left_diag = wordsearch[i - 1][j - 1] + wordsearch[i][j] + wordsearch[i + 1][j + 1]
            right_diag = wordsearch[i - 1][j + 1] + wordsearch[i][j] + wordsearch[i + 1][j - 1]

            # Check if both diagonals match valid patterns
            if left_diag in valid_patterns and right_diag in valid_patterns:
                count += 1

print(count)
```

## What I Learned
### Direction Vectors for Searching a Grid
* The code can be way compacted if you define the direction vectors as a list of `(row_offset, column_offset)` tuples.
* We can then search by multiplying the current index of the target (`k`) by the row and column direction, which gives the total offset, add this to current index, and repeat this for each direction

### String Concatenations are Expensive
* String concatenations in Python are more expensive than appending to a list, because strings are immutable.
* When you concatenate $n$ strings, new memory must be allocated for each concatenation, and each individual character in both strings must be copied to the new memory. This means for each $n$ string of length $m$, the concatenation now takes $O(mn)$ time, making this overall $O(mn^2)$
* Rather than repeatedly concatenating string when building the candidates, we can append to a list, and use `''.join(candidate)` after all strings have been appended.
* Join can allocate the memory based on the size of the `candidate` list in advance, and copy everything over in 1 loop, making this operation $O(n)$ instead.

### Better variables naming and simplifications
* Defining `rows` and `cols` up front makes the loop cleaner and easier to read.
* Defining `target` also improves readability
* Can also right the conditions for the indices in 1 line in Python (`0 <= ni < rows`)

### Better Loop Bounds
* Define the bounds of the loops so that you don't have to worry about the content in your loop going out of bounds. For example in Part 2 here, it is better to range from 1 to the number of rows minus 1, rather than worry about remaining in bounds inside the loop.
