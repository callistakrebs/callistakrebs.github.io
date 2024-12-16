# Advent of Code - Day 5
[< Prev Day](day4.html) [Next Day >](day6.html)

## Part 1
### My Code
```{.python .numberLines}
from operator import itemgetter

def convert_pages(page_sets):
    return map(int, page_sets.split(","))

with open("day5.txt") as f:
    [rules, pages_to_copy] = f.read().split("\n\n")
    rules = rules.split('\n')
    pages_to_copy = pages_to_copy.split('\n')
    
    pages_to_copy_int = []
    for group in pages_to_copy:
        pages_to_copy_int.append(list(map(int,group.split(","))))

    graph = {}
    # add nodes:
    for group in pages_to_copy_int:
        for page in group:
            if graph.get(page,-1) == -1: # u is in graph
                graph[page] = []

    # add edges
    for rule in rules:
        [u,v] = list(map(int, rule.split("|")))

        if graph.get(u,-1) != -1: # u is in graph
            graph[u].append(v)
        else:
            graph[u] = [v]
        
    valid_sum = 0
    for group in pages_to_copy_int:
        valid = True
        # Create subgraph for group of pages
        subgraph = {}
        for page in group:
            subgraph[page] = []
            for node in graph[page]:
                if node in group:
                    subgraph[page].append(node)

        # Check that each outgoing edge points to a later page in the list (verify topological sort)
        for i in range (len(group)):
            for page in subgraph[group[i]]:
                if page not in group[i+1:]:
                    valid = False
        
        if valid:
            valid_sum += group[int(len(group)/2)]
            
print(valid_sum)
```
### ChatGPT's Improved Code
```{.python .numberLines}
from collections import defaultdict

def parse_pages(page_sets):
    return list(map(int, page_sets.split(",")))

with open("day5.txt") as f:
    rules, pages_to_copy = f.read().strip().split("\n\n")
    rules = rules.split("\n")
    pages_to_copy = [parse_pages(group) for group in pages_to_copy.split("\n")]

# Create the graph
graph = defaultdict(list)

# Add edges from rules
for rule in rules:
    u, v = map(int, rule.split("|"))
    graph[u].append(v)

# Process groups and calculate the valid sum
valid_sum = 0

for group in pages_to_copy:
    valid = True
    page_indices = {page: idx for idx, page in enumerate(group)}  # Map pages to their indices for quick lookup

    # Validate edges: ensure all edges point to later pages in the group
    for page in group:
        for neighbor in graph[page]:
            if neighbor in page_indices and page_indices[neighbor] <= page_indices[page]:
                valid = False
                break
        if not valid:
            break

    # Add the middle page if the group is valid
    if valid:
        valid_sum += group[len(group) // 2]

print(valid_sum)

```
## Part 2
### My Code
```{.python .numberLines}
from operator import itemgetter

def convert_pages(page_sets):
    return map(int, page_sets.split(","))

def dfs(subgraph):
    stack = []
    visited = {x:False for x in subgraph.keys()}

    for node in subgraph.keys():
        if not visited[node]:
            explore(node, subgraph, visited, stack)

    return stack

def explore(u, subgraph, visited, stack):
    visited[u] = True
    for v in subgraph[u]:
        if not visited[v]:
            explore(v, subgraph,visited,stack)
    stack.append(u)

with open("day5.txt") as f:
    [rules, pages_to_copy] = f.read().split("\n\n")
    rules = rules.split('\n')
    pages_to_copy = pages_to_copy.split('\n')
    
    pages_to_copy_int = []
    for group in pages_to_copy:
        pages_to_copy_int.append(list(map(int,group.split(","))))

    graph = {}
    # add nodes:
    for group in pages_to_copy_int:
        for page in group:
            if graph.get(page,-1) == -1: # u is in graph
                graph[page] = []

    # add edges
    for rule in rules:
        [u,v] = list(map(int, rule.split("|")))

        if graph.get(u,-1) != -1: # u is in graph
            graph[u].append(v)
        else:
            graph[u] = [v]
        
    valid_sum = 0
    invalid_sum = 0
    for group in pages_to_copy_int:
        valid = True
        # Create subgraph for group of pages
        subgraph = {}
        for page in group:
            subgraph[page] = []
            for node in graph[page]:
                if node in group:
                    subgraph[page].append(node)

        # Get topo sort, and compare to current sort
        topo = dfs(subgraph)
        topo.reverse()
        
        if topo == group:
            valid_sum += group[int(len(group)/2)]
        else:
            invalid_sum += topo[int(len(topo)/2)]

print(f"Valid: {valid_sum}")
print(f"Invalid: {invalid_sum}")
```
### ChatGPT's Improved Code
```{.python .numberLines}
from collections import defaultdict, deque

def topological_sort(subgraph):
    visited = set()
    stack = deque()

    def dfs(node):
        if node not in visited:
            visited.add(node)
            for neighbor in subgraph[node]:
                dfs(neighbor)
            stack.appendleft(node)  # Append to the front for topological order

    for node in subgraph:
        dfs(node)

    return list(stack)

with open("day5.txt") as f:
    rules, pages_to_copy = f.read().strip().split("\n\n")
    rules = rules.split('\n')
    pages_to_copy = [list(map(int, group.split(","))) for group in pages_to_copy.split("\n")]

# Create the main graph
graph = defaultdict(list)

# Add edges
for rule in rules:
    u, v = map(int, rule.split("|"))
    graph[u].append(v)

# Process groups and calculate sums
valid_sum = 0
invalid_sum = 0

for group in pages_to_copy:
    # Create subgraph for the current group
    subgraph = defaultdict(list)
    group_set = set(group)

    for page in group:
        for neighbor in graph[page]:
            if neighbor in group_set:
                subgraph[page].append(neighbor)

    # Get topological sort and compare to the group order
    topo = topological_sort(subgraph)

    if topo == group:
        valid_sum += group[len(group) // 2]
    else:
        invalid_sum += topo[len(topo) // 2]

print(f"Valid: {valid_sum}")
print(f"Invalid: {invalid_sum}")
```

## What I Learned
### Default Dict
* Avoids the need for checking if a key exists before you access it.
* The value passed to `defaultdict()` when initialized is the default value to set the key to if the key does not exist
* Should not be used if you need to handle default initialization differently for different keys

### Mapping the Page Indices for Quick Lookup
* We can create a dictionary of `page : index` pairs, which gives you the index of the page in the list of pages to be verified for copying.
* This avoids the need to create the subgraph and verify the neighbors of each node in the subgraph are downstream in the list.

### Readability Improvements
* Using a separate function for parsing the pages, lets you do an in-line declaration for the `pages_to_copy` list with integer values
* No reason to track `invalid_sum` and `valid_sum` separately, since we can just do the total number of groups minus `valid_sum` to get `invalid_sum` and vice versa.
* I really need to stop leaving the file open for the whole script.

### Deque
* Using `deque()` (pronounced "deck", stands for double-ended queue) to implement the stack in DFS lets you control where the node is appended (`appendleft`) and later avoids the need to reverse the stack later.
* Not relevant to this problem, but when using `deque` you can use the `extend(iterable)` and `extendleft(iterable)` methods to add elements from an iterable to the front or back of the queue.

