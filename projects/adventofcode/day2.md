# Advent of Code - Day 2
[< Prev Day](day1.html) [Next Day >](day3.html)

## My Code
```{.python .numberLines}
def check_safe(levels):
    safe = False
    levels_copy = levels.copy()
    levels_copy.sort() # sort forwards and see if its the same
    if levels == levels_copy:
        safe = True
    
    levels_copy.sort(reverse=True) # sort backwards and see if its the same
    if levels == levels_copy:
        safe = True

    last = int(levels[0])
    i = 1
    while safe and i < len(levels):
        if abs(int(levels[i]) - last) >= 1 and abs(int(levels[i]) - last) <= 3:
            safe = True
        else:
            safe = False
        
        last = int(levels[i])
        i += 1

    return safe

with open("day2.txt") as f:
    count = 0
    for line in f.readlines():
        safe = False
        levels = [int(x) for x in line.strip().split(" ")]
        safe = check_safe(levels)
        
        if not safe:
            i = 0
            while not safe and i < len(levels):
                safe = check_safe(levels[0:i] + levels[i+1:])
                i += 1

        if safe:
            count +=1

print(count)
```

## ChatGPT's Improved Code
```{.python .numberLines}
def is_sorted_or_reverse(levels):
    """Check if the list is sorted in ascending or descending order."""
    return levels == sorted(levels) or levels == sorted(levels, reverse=True)

def is_within_bounds(levels):
    """Check if the differences between consecutive levels are within bounds."""
    return all(1 <= abs(levels[i] - levels[i - 1]) <= 3 for i in range(1, len(levels)))

def check_safe(levels):
    """Determine if the sequence is safe."""
    return is_sorted_or_reverse(levels) and is_within_bounds(levels)

def process_file(filename):
    """Process the file and count safe sequences."""
    count = 0
    with open(filename) as f:
        for line in f:
            levels = [int(x) for x in line.strip().split()]
            # Check the sequence directly
            if check_safe(levels):
                count += 1
            else:
                # Check by removing one element at a time
                for i in range(len(levels)):
                    if check_safe(levels[:i] + levels[i + 1:]):
                        count += 1
                        break
    return count

# Main execution
if __name__ == "__main__":
    print(process_file("day2.txt"))

```

# What I Learned
### Modularization
* Generally, ChatGPT's suggested improvements were related to modularizing code to fit it into methods rather than just one script. This was not new information, but always a good reminder and still good practice when doing little scripts like this.

### Using `sorted()` method instead of `list.sort()`
* An issue I ran into in my code is that `list.sort()` sorts a list in place, so I had to store a copy of each level in order to keep the original level in tact.
* Using `sorted()` has the same functionality, but not in place, avoiding the need to store a copy of the original level

### `copy()`
* When you want to maintain two separate instances of a list in Python, you have to use the `list.copy()`
* Setting a list to the value of another list actually just points to the original list in Python. For example:

    ```{.python}
    a = [1,2,3]
    b = a
    a[1] = 5
    print(a)
    print(b)
    # Outputs: 
    # [1,5,3]
    # [1,5,3]
    ```

### `all()`
* We can use `all()` with an iterator to check for conditions on every element in a list.
* The iterator in all can also use bidirectional conditions (i.e. 1 <= x <= 3)
* Syntax is similar to `sum()`, but instead of the action we want to sum, we include the condition we want to check:

    ```{.python}
    all(
        [condition to check for each element] 
        for i in range([number of elements])
    )
    ```