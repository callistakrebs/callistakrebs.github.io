# Advent of Code - Day 18
[< Prev Day](day16.html) [Next Day >](day19.html)

## Part 1
### My Code
```{.python .numberLines}
from collections import defaultdict
import math

DIRECTIONS = {
    'up': (-1,0),
    'down': (1,0),
    'left': (0,-1),
    'right': (0,1),
}

def is_in_bounds(position):
    return 0 <= position[0] < 71 and 0 <= position[1] < 71

def build_graph(lava):
    '''
    builds the graph
    lava: list of tuples of (x,y) positions where the bytes will fall, making them unusable
    '''

    graph = defaultdict(list)

    for i in range(71):
        for j in range(71):
            if (i,j) in lava[0:1024]:
                continue
            else:
                # left, right, up, down
                neighbors = [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]
                for neighbor in neighbors:
                    if is_in_bounds(neighbor) and neighbor not in lava[0:1024]:
                        graph[(i,j)].append(neighbor)

    return graph

def bfs(graph, start = (0,0)):
    queue = [start]
    visited = set([start])
    dist = {start: 0}

    while queue:
        current = queue.pop(0)
        for neighbor in graph[current]:
            if neighbor not in visited or dist[neighbor] > dist[current] + 1:
                dist[neighbor] = dist[current] + 1
                visited.add(neighbor)
                queue.append(neighbor)    
    
    return visited, dist


if __name__ == "__main__":
    with open("day18.txt") as f:
        lava = [tuple(int(y) for y in x.split(",")) for x in f.read().split("\n")]

    graph = build_graph(lava)

    _, dist = bfs(graph)

    print(dist[(70,70)])
```
### ChatGPT's Improved Code
```{.python .numberLines}
from collections import defaultdict, deque

DIRECTIONS = {
    'up': (-1, 0),
    'down': (1, 0),
    'left': (0, -1),
    'right': (0, 1),
}

GRID_SIZE = 71  # Avoid magic numbers

def is_in_bounds(x, y):
    return 0 <= x < GRID_SIZE and 0 <= y < GRID_SIZE

def build_graph(lava):
    """
    Builds the graph.
    lava: set of (x, y) positions where the bytes will fall, making them unusable.
    """
    graph = defaultdict(list)
    blocked = set(lava[:1024])  # Convert lava list slice to a set for O(1) lookups

    for i in range(GRID_SIZE):
        for j in range(GRID_SIZE):
            if (i, j) in blocked:
                continue
            for dx, dy in DIRECTIONS.values():
                ni, nj = i + dx, j + dy
                if is_in_bounds(ni, nj) and (ni, nj) not in blocked:
                    graph[(i, j)].append((ni, nj))

    return graph

def bfs(graph, start=(0, 0)):
    queue = deque([start])  # Use deque for O(1) pops
    visited = {start}
    dist = {start: 0}

    while queue:
        current = queue.popleft()
        for neighbor in graph[current]:
            if neighbor not in visited:
                dist[neighbor] = dist[current] + 1
                visited.add(neighbor)
                queue.append(neighbor)

    return visited, dist

if __name__ == "__main__":
    with open("day18.txt") as f:
        lava = [tuple(map(int, line.split(","))) for line in f.read().strip().split("\n")]

    graph = build_graph(lava)
    _, dist = bfs(graph)

    print(dist.get((70, 70), -1))  # Use .get() to avoid KeyError if unreachable

```

## Part 2
### My Code
```{.python .numberLines}
from collections import defaultdict
import math

DIRECTIONS = {
    'up': (-1,0),
    'down': (1,0),
    'left': (0,-1),
    'right': (0,1),
}

def is_in_bounds(position):
    return 0 <= position[0] < 71 and 0 <= position[1] < 71

def build_graph():
    '''
    builds the graph of the grid
    '''

    graph = defaultdict(list)

    for i in range(71):
        for j in range(71):
            # left, right, up, down
            neighbors = [(i-1, j), (i+1, j), (i, j-1), (i, j+1)]
            for neighbor in neighbors:
                if is_in_bounds(neighbor):
                    graph[(i,j)].append(neighbor)

    return graph

def delete_node(graph, node):
    graph.pop(node)

    for node in graph:
        for idx, neighbor in enumerate(graph[node]):
            if neighbor == node:
                graph[node].pop(idx)

    return graph

def bfs(graph, start = (0,0)):
    queue = [start]
    visited = set([start])
    dist = {start: 0}

    while queue:
        current = queue.pop(0)
        for neighbor in graph[current]:
            if neighbor not in visited or dist[neighbor] > dist[current] + 1:
                dist[neighbor] = dist[current] + 1
                visited.add(neighbor)
                queue.append(neighbor)    
    
    return visited, dist


if __name__ == "__main__":
    with open("day18.txt") as f:
        lava = [tuple(int(y) for y in x.split(",")) for x in f.read().split("\n")]

    # update graph building so that we build the whole grid, and then remove nodes that become lava
    graph = build_graph()

    # We can still use bfs, but need to run it each time we drop the bytes, and check if 70,70 is still in the distance dict after bfs
    for position in lava:
        graph = delete_node(graph, position)
        _, dist = bfs(graph)

        if (70,70) in dist:
            continue
        else:
            print(position)
            break
```

### ChatGPT's Improved Code
```{.python .numberLines}
from collections import defaultdict, deque

DIRECTIONS = {
    'up': (-1, 0),
    'down': (1, 0),
    'left': (0, -1),
    'right': (0, 1),
}

GRID_SIZE = 71  # Avoid magic numbers

def is_in_bounds(x, y):
    return 0 <= x < GRID_SIZE and 0 <= y < GRID_SIZE

def build_graph():
    """
    Builds the initial graph of the entire grid.
    """
    graph = defaultdict(list)

    for i in range(GRID_SIZE):
        for j in range(GRID_SIZE):
            for dx, dy in DIRECTIONS.values():
                ni, nj = i + dx, j + dy
                if is_in_bounds(ni, nj):
                    graph[(i, j)].append((ni, nj))

    return graph

def delete_node(graph, node):
    """
    Removes a node from the graph and cleans up references in neighbors.
    """
    if node in graph:
        for neighbor in graph[node]:  # Remove the node reference from neighbors
            graph[neighbor].remove(node)
        del graph[node]  # Delete the node itself

def bfs(graph, start=(0, 0)):
    """
    Standard BFS to find shortest paths from `start`.
    """
    if start not in graph:  # If starting point is already lava, return empty
        return set(), {}

    queue = deque([start])
    visited = {start}
    dist = {start: 0}

    while queue:
        current = queue.popleft()
        for neighbor in graph[current]:
            if neighbor not in visited:
                dist[neighbor] = dist[current] + 1
                visited.add(neighbor)
                queue.append(neighbor)

    return visited, dist

if __name__ == "__main__":
    with open("day18.txt") as f:
        lava = [tuple(map(int, line.split(","))) for line in f.read().strip().split("\n")]

    graph = build_graph()
    _, dist = bfs(graph)

    if (70, 70) not in dist:
        print("Already unreachable before any lava!")
    else:
        for position in lava:
            delete_node(graph, position)

            # Skip BFS if the deleted node was already unreachable
            if position not in dist:
                continue

            _, dist = bfs(graph)

            if (70, 70) not in dist:
                print(position)
                break
```

## What I Learned
### Slicing Is Still Expensive
* Avoid slicing more than needed by storing the value after slicing. For example, in my code for Part 1, I sliced the first 1024 byte positions (the input list) twice, but ChatGPT improved this by storing it after the first slice.
* ChatGPT also stored the sliced version as a set, which has a faster lookup time.

### Use `deque()` for BFS
* The `deque` collection or double-ended queue allows you to pop from the front of the list in O(1) time, whereas using a normal queue like I did (a list in Python) takes O(n) complexity per pop because the list has to shift every time you remove from it.

### BFS distance always increases by 1 edge at a time
* Since BFS covers all neighbors before going further in the graph, there is actually no need to compare the distances stored for a specific node.
* ChatGPT made the point that if you check `dist[neighbor] > dist[current] + 1` then the neighbor has to already be visited, and the first condition of my BFS search (line 43) is already satisfied.
* In BFS, a node having been visited is enough to know that it is already the minimum path from the starting point, because the search stays shallow as you check each neighbor.

### Deleting Nodes in an Undirected Graph
* In an undirected graph, when you delete the node from the adjacency list, you can just delete the node from each of its neighbor's adjacency list, since we know that any node connected to the node being deleted will be its neighbor.
* To avoid having to iterate through the whole graph, we can instead delete the node from each of its neighbor's adjacency lists, and then delete the node itself from the graph's adjacency list.

### Skip BFS if the blocked position was already unreachable
* This is not a very generalizable detail, but I do think this was a clever suggestion from ChatGPT!
* Rather than running BFS every single time a new position is blocked, we can skip some iterations if the blocked position was already unreachable (and therefore not in `dist`).


