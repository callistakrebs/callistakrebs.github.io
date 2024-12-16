# Advent of Code - Day 7
[< Prev Day](day6.html) [Next Day >](day8.html)

## Part 1
### My Code
```{.python .numberLines}
from itertools import product

def add(left, right):
    return int(left) + int(right)

def mul(left, right):
    return int(left) * int(right)

equations = []
with open("day7.txt") as f:
    lines = f.read().splitlines()
    for line in lines:
        soln, nums = line.split(":")
        nums = nums.strip().split(" ")
        equations.append((soln,nums))

trues = set() 
for equation in equations:
    soln, nums = equation
    n = len(nums)

    possible_operations = product([add,mul], repeat=n-1)

    for combos in possible_operations:
        curr_total = nums[0]
        i = 1
        for op in combos:
            curr_total = op(curr_total,nums[i])
            i += 1

        if curr_total == int(soln):
            trues.add(int(soln))

print(sum(trues))

```

### ChatGPT's Improved Code
```{.python .numberLines}
from itertools import product

# Define operations
def add(left, right):
    return left + right

def mul(left, right):
    return left * right

equations = []
with open("day7.txt") as f:
    lines = f.read().splitlines()
    for line in lines:
        soln, nums = line.split(":")
        nums = list(map(int, nums.strip().split(" ")))  # Convert to integers
        equations.append((int(soln), nums))  # Store solution as integer

# Set to store valid solutions
trues = set()

for soln, nums in equations:
    n = len(nums)

    # Generate all possible combinations of operations
    possible_operations = product([add, mul], repeat=n - 1)

    for combos in possible_operations:
        # Evaluate the expression
        curr_total = nums[0]
        for i, op in enumerate(combos):
            curr_total = op(curr_total, nums[i + 1])

        # If the result matches, add to trues and exit early
        if curr_total == soln:
            trues.add(soln)
            break  # No need to check further combinations for this equation

# Calculate and print the sum of valid solutions
print(sum(trues))
```

## Part 2
### My Code
```{.python .numberLines}
from itertools import product

def add(left, right):
    return int(left) + int(right)

def mul(left, right):
    return int(left) * int(right)

def concat(left, right):
    return int(str(left)+str(right))

equations = []
with open("day7.txt") as f:
    lines = f.read().splitlines()
    for line in lines:
        soln, nums = line.split(":")
        nums = nums.strip().split(" ")
        equations.append((soln,nums))

trues = set() 
for equation in equations:
    soln, nums = equation
    n = len(nums)

    possible_operations = product([add,mul, concat], repeat=n-1)

    for combos in possible_operations:
        curr_total = nums[0]
        i = 1
        for op in combos:
            curr_total = op(curr_total,nums[i])
            i += 1

        if curr_total == int(soln):
            trues.add(int(soln))

print(sum(trues))
```
### ChatGPT's Improved Code
```{.python .numberLines}
from itertools import product

# Define operations
def add(left, right):
    return left + right

def mul(left, right):
    return left * right

def concat(left, right):
    return int(str(left) + str(right))

# Read and process input
equations = []
with open("day7.txt") as f:
    lines = f.read().splitlines()
    for line in lines:
        soln, nums = line.split(":")
        nums = list(map(int, nums.strip().split(" ")))  # Convert nums to integers
        equations.append((int(soln), nums))  # Convert solution to integer

# Set to store valid solutions
trues = set()

for soln, nums in equations:
    n = len(nums)

    # Generate all possible combinations of operations
    possible_operations = product([add, mul, concat], repeat=n - 1)

    for combos in possible_operations:
        # Evaluate the expression
        curr_total = nums[0]
        for i, op in enumerate(combos):
            curr_total = op(curr_total, nums[i + 1])

        # If the result matches, add to trues and exit early
        if curr_total == soln:
            trues.add(soln)
            break  # No need to check further combinations for this equation

# Calculate and print the sum of valid solutions
print(sum(trues))
```
### ChatGPT's More Improved Version
I prompted ChatGPT for a better overall approach besides brute force, and it gave me a recursive soltion that, asymptotically, has the same run time, but in practice is faster because it will exit as soon as it finds a solution, avoiding unnecessary iterations.
```{.python .numberLines}
def add(left, right):
    return left + right

def mul(left, right):
    return left * right

def concat(left, right):
    return int(str(left) + str(right))

def can_solve(nums, target, index=1, current=None):
    # Initialize the `current` total with the first number
    if current is None:
        current = nums[0]

    # Base case: If we've processed all numbers, check the result
    if index == len(nums):
        return current == target

    # Try all operations with the current number and the next number
    for operation in (add, mul, concat):
        next_value = operation(current, nums[index])
        if can_solve(nums, target, index + 1, next_value):
            return True

    # If no operation leads to the target, return False
    return False

# Read and process input
equations = []
with open("day7.txt") as f:
    lines = f.read().splitlines()
    for line in lines:
        soln, nums = line.split(":")
        nums = list(map(int, nums.strip().split(" ")))
        equations.append((int(soln), nums))

# Find valid solutions
trues = set()
for soln, nums in equations:
    if can_solve(nums, soln):
        trues.add(soln)

# Print the sum of valid solutions
print(sum(trues))

```

## What I Learned
### Itertools.product()
* Generates the cartestion product the input
* Cartesian product is the set of all pairs of items in the input
* The first argument is the input, an iterable of the things you want to pair up
* The second argument `repeats` specifies the max number of times an element in the input can be repeated in the ouput pairs (or groups)
* I didn't learn this from ChatGPT, but I was pretty stumped on how to do Day 7 without a mess of loops like Days 4 and 6, so I picked up the hint to use `itertools.product()` from the Advent of Code Reddit page. A side lesson: use the resources available when you need to!

### Enumerate()
* Can use enumerate on the iteratable in a for loop instead of manually tracking the index as you go.

### break
* In this case, we can break early if we find a solution. I have an old habit of believing you shouldn't write code that requires a break statement, and that leads me to rarely ever think to use them (even if they aren't required). In this case, since we are brute forcing, it may save some time in the long wrong to cut out as many unnecessary iterations as possible.

### Mapping to int
* Originally I didn't map all values to int from the start because of the concatenation, but it makes more sense to map everything to int and only cast to string as needed for concatenation instead.