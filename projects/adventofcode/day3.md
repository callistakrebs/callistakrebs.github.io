# Advent of Code - Day 3
[< Prev Day](day2.html) [Next Day >](day4.html)

## My Code
```{.python .numberLines}
import re

with open("day3.txt") as f:
    instructions = f.read()
    multipliers = re.findall("mul\\(\\d\\d?\\d?,\\d\\d?\\d?\\)", instructions)
    
    sum = 0
    for item in multipliers:
        nums = list(map(int,item.strip("mul()").split(",")))
        sum += nums[0] * nums[1]

print(sum)
```

## ChatGPT's Improved Code
```{.python .numberLines}
import re

# Open the file using a context manager and read its content
with open("day3.txt", "r") as file:
    instructions = file.read()

# Use a more descriptive variable name for the matches
pattern = r"mul\((\d{1,3}),(\d{1,3})\)"
matches = re.findall(pattern, instructions)

# Calculate the sum in a more Pythonic way using a generator expression
total_sum = sum(int(a) * int(b) for a, b in matches)

# Print the result
print(total_sum)

```

## What I Learned
### Regex review
* `*` means the character before can be matched 0 or >=1 number of times, not necessarily just once
* Can group characters together with []. `[abx]*` means match 0 or more characters in the group a,b,x
* `+` matches the character before it 1 or more times (NOT 0)
* `?` matches the character before it 1 or 0 times (NOT multiple)
* `{m,n}` matches the character before it at least `m` times and at most `n` times
* `{m}` with no comma matches the character before it exactly `m` times

### Capturing Groups in regex
* We can avoid the need to "strip" the 'mul' portion of the matched strings using a capturing group ("()") in the regex.
* Wrapping a portion of the regex in parantheses means that the whole regex will be matched, but only the items inside the group will be returned
* Doing this makes the sum code much simpler, because we can use a generator expression inside of sum() instead of having to write out the full loop

### Better Syntax
* It is cleaner to distinctly label the `pattern` for the regex, and pass this to findall.
* It is also easier to read when we store the `matches` variable.
