# Advent of Code - Day 9
[< Prev Day](day8.html) [Next Day >](day10.html)

## Part 1
### My Code
```{.python .numberLines}
import math

with open("day9.txt") as f:
    data = list(map(int, f.read()))

i = 0
j = len(data) - 1

i_file_id = 0
j_file_id = math.ceil(len(data) / 2) - 1

new_data = []
while i <= j:
    # Make a space for the data block for the file at i
    for k in range(data[i]):
        new_data.append(i_file_id)
        data[i] -= 1
    
    # Fill the neighboring empty space with the files at the end
    max_blocks_to_move = min(data[i+1], data[j]) # min of free space and size of current end file
    for k in range(data[i+1]):
        if data[j] > 0:
            new_data.append(j_file_id)
            data[j] -= 1
        
        if data[j] == 0:
            j -= 2
            j_file_id -= 1

    i += 2
    i_file_id += 1

checksum = sum(idx * value for idx, value in enumerate(new_data))
print(checksum)
```

### ChatGPT's Improved Code
> After 2 incorrect answers and subsequent prompting, ChatGPT gave a correct solution that looked pretty familiar...
```{.python .numberLines}
import math

with open("day9.txt") as f:
    data = list(map(int, f.read().split()))  # Assuming input is space-separated integers

i = 0
j = len(data) - 1

i_file_id = 0
j_file_id = math.ceil(len(data) / 2) - 1

new_data = []

while i < j:
    # Allocate blocks for the file at the start
    for _ in range(data[i]):
        new_data.append(i_file_id)

    # Use the free space immediately after the current file at i
    free_space = data[i + 1]

    # Move blocks from the file at the end into the free space
    blocks_to_move = min(free_space, data[j])
    for _ in range(blocks_to_move):
        new_data.append(j_file_id)

    # Update the data to reflect the moved blocks
    data[j] -= blocks_to_move
    data[i + 1] -= blocks_to_move

    # If the file at the end is fully moved, adjust the j pointers
    if data[j] == 0:
        j -= 2
        j_file_id -= 1

    # Move to the next file at the start
    i += 2
    i_file_id += 1

# Compute the checksum
checksum = sum(idx * value for idx, value in enumerate(new_data))
print(checksum)
```

## Part 2
### My Code
```{.python .numberLines}
with open("day9.txt") as f:
    data = list(map(int, f.read()))

file_id = 0
new_data = []
file_idxs = {}
free_space_idxs = {}
for i in range(0,len(data), 2):
    file_idxs[file_id] = len(new_data)
    free_space_idxs[i+1] = len(new_data) + data[i]
    for k in range(data[i]):
        new_data.append(file_id)
    if i+1 <= len(data) - 1:
        for k in range(data[i+1]):
            new_data.append(-1)
    file_id += 1

for j in range(len(data) - 1, 0, -2):
    moved = False
    file_id = int(j / 2)
    i = 0
    old_idx = file_idxs[file_id]
    while i <= j and not moved:
        if data[i] >= data[j] and i % 2 != 0:
            moved = True
            new_idx = free_space_idxs[i]

            # move file in the new data list
            new_data[new_idx : new_idx + data[j]] = [file_id] * data[j]
            new_data[old_idx : old_idx + data[j]] = [-1] * data[j]

            # Update data free space and file space values
            data[i] = data[i] - data[j]
            data[j-1] = data[j-1] + data[j]
            free_space_idxs[i] += data[j]

        i += 1

sum = 0
for idx, val in enumerate(new_data):
    if val >= 0:
        sum += idx * val
print(sum)
```
### ChatGPT's Improved Code
```{.python .numberLines}
with open("day9.txt") as f:
    data = list(map(int, f.read()))

# Initialize new_data with files and free spaces
file_id = 0
new_data = []
free_space = {}
for i in range(0, len(data), 2):
    # Add files
    for _ in range(data[i]):
        new_data.append(file_id)
    # Add free space
    if i + 1 < len(data):
        free_space[i + 1] = len(new_data)
        new_data.extend([-1] * data[i + 1])
    file_id += 1

# Process files from the end toward the start
for j in range(len(data) - 1, 0, -2):
    file_id = j // 2
    file_size = data[j]
    file_idx = new_data.index(file_id)  # Locate the file's current position

    for i in range(1, j, 2):  # Iterate over free space indices
        if data[i] >= file_size:
            # Move file to the new location
            new_start = free_space[i]
            new_data[new_start:new_start + file_size] = [file_id] * file_size
            new_data[file_idx:file_idx + file_size] = [-1] * file_size

            # Update free space and data values
            data[i] -= file_size
            data[j - 1] += file_size
            free_space[i] += file_size
            break

# Calculate the checksum
checksum = sum(idx * val for idx, val in enumerate(new_data) if val >= 0)
print(checksum)
```

## What I Learned
### My Python Skills Are Improving
* ... At least compared to what ChatGPT comes up with.
* Both of ChatGPT's solutions were structurally similar to mine, with minor improvements for variable names and readability.

### List.index()
* Can use index() function to get the index of the first occurrence of a value in a list
* As ChatGPT shows, I can use this instead of tracking the `file_idxs`

### Integer Math
* Instead of casting the result of division to an `int`, we can use `a // b` will return the same as `int(a / b)`

### Iterate only over values you need
* I am only really considering a move at available free space indices, so there is no need to check the file spaces as well
* We can speed up the solution by incrementing `i` by 2 each time instead, and only considering free space