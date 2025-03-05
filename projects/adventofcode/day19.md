# Advent of Code - Day 19
[< Prev Day](day18.html) [Next Day >](day20.html)

## Part 1
### My Code
```{.python .numberLines}
import numpy as np

if __name__ == "__main__":
    with open("day19.txt") as f:
        towels, designs = f.read().split("\n\n")
        designs = designs.split("\n")
        towels = set(x.strip() for x in towels.split(","))
    
    count = 0
    for design in designs:
        dp_array = [0] * (len(design)) # dp_array stores the number of "remaining stripes" that are unmatched at this point in the design
        
        if design[0] in towels:
            dp_array[0] = 0 # first stripe is fulfilled by an independent towel
        else:
            dp_array[0] = 1 # the first stripe must be accounted for

        for i in range(1,len(design)):
            dp_array[i] = dp_array[i-1] + 1
            for j in range(0,i+1):
                if (design[j:i + 1] in towels and dp_array[j-1] == 0):
                    dp_array[i] = 0
                    break
        
        if dp_array[-1] == 0:
            count+=1

    print(count)
```

## Part 2
### My Code
```{.python .numberLines}
import numpy as np

if __name__ == "__main__":
    with open("day19.txt") as f:
        towels, designs = f.read().split("\n\n")
        designs = designs.split("\n")
        towels = set(x.strip() for x in towels.split(","))
    
    count = 0
    for design in designs:
        dp_array = [0] * (len(design) + 1) # now instead this stores the number of ways to have 0 letters leftover?
        dp_counts = [0] * (len(design) + 1)
        design = "x" + design

        dp_counts[0] = 1
        if design[1] in towels:
            dp_array[1] = 0 # first stripe is fulfilled by an independent towel
            dp_counts[1] = 1
        else:
            dp_array[1] = 1 # the first stripe must be accounted for
            dp_counts[1] = 0

        for i in range(2,len(design)):
            dp_array[i] = dp_array[i-1] + 1
            for j in range(1,i+1):
                if (design[j:i + 1] in towels and dp_array[j-1] == 0):
                    dp_array[i] = 0 # it is possible to break down at this point
                    dp_counts[i] += dp_counts[j-1]
        
        if dp_array[-1] == 0:
            count+= dp_counts[-1]

    print(count)
```

##  What I Learned
### ChatGPT is not very good at dynamic programming
* After several iterations and some back and forth with ChatGPT, each solution it gave me for both Part 1 and Part 2 would not produce the answer.

### ChatGPT's insight can still be useful even when its code is not
* ChatGPT did offer a few insights on optimization, such as avoiding unnecessary loop iterations.
* One clever way of doing this was to set the range of `j` such that you only consider groups of max length in the towels set. For example, `j` can start as far back as the max of 0 and i minus the longest length in towels.
