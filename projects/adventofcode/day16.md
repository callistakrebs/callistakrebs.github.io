# Advent of Code - Day 16
[< Prev Day](day15.html) [Next Day >](day17.html)

## Part 1
### My Code
```{.python .numberLines}
from collections import defaultdict, deque
import math
import heapq

DIRECTIONS = {
    'north': (-1,0),
    'south': (1,0),
    'west': (0,-1),
    'east': (0,1),
}

ALLOWED_MOVES = {
    'north': {'west':1001, 'north':1, 'east':1001},
    'east': {'north':1001, 'east':1, 'south':1001},
    'south': {'east':1001, 'south':1, 'west':1001},
    'west': {'north':1001, 'west':1, 'south':1001}
}

def is_in_bounds(grid, r,c):
    return 0 <= r < len(grid) and 0 <= c < len(grid[0])

def dijkstras(graph, start):
    dist = {}

    for node in graph:
        dist[node] = math.inf

    dist[start] = 0

    # Priority Queue
    pq = [(0,start)]
    heapq.heapify(pq)

    visited = set()
    while pq:
        weight, node = heapq.heappop(pq)
        if node in visited:
            continue
        visited.add(node)
        
        for neighbor, weight in graph[node]:
            if dist[neighbor] > dist[node] + weight:
                dist[neighbor] = dist[node] + weight
                heapq.heappush(pq, (dist[neighbor], neighbor))
    
    return dist


if __name__ == "__main__":
    with open("day16.txt") as f:
        maze = [list(x) for x in f.read().split("\n")]
    
    nrows = len(maze)
    ncols = len(maze[0])

    graph = defaultdict(list)
    for r in range(nrows):
        for c in range(ncols):
            if maze[r][c] == "S":
                start = ((r,c), 'east')
            if maze[r][c] =="E":
                end_idx = (r,c)

            for curr_direction in DIRECTIONS:
                graph[((r,c),curr_direction)] = []
                for next_direction in ALLOWED_MOVES[curr_direction]:
                    dr, dc = DIRECTIONS[next_direction]
                    weight = ALLOWED_MOVES[curr_direction][next_direction]
                    if is_in_bounds(maze, r + dr, c + dc):
                        if maze[r+dr][c+dc] == "." or maze[r+dr][c+dc]== "E":
                            graph[((r,c),curr_direction)].append((((r+dr,c+dc), next_direction), weight))

    distances = dijkstras(graph, start)
    min = math.inf
    for direction in DIRECTIONS:
        if distances[(end_idx, direction)] <= min:
            end_state = (end_idx, direction)
            min = distances[(end_idx, direction)]
    
    print(min)
```

## Part 2
### My Code
```{.python .numberLines}
from collections import defaultdict, deque
import math
import heapq

DIRECTIONS = {
    'north': (-1,0),
    'south': (1,0),
    'west': (0,-1),
    'east': (0,1),
}

ALLOWED_MOVES = {
    'north': {'west':1001, 'north':1, 'east':1001},
    'east': {'north':1001, 'east':1, 'south':1001},
    'south': {'east':1001, 'south':1, 'west':1001},
    'west': {'north':1001, 'west':1, 'south':1001}
}

def is_in_bounds(grid, r,c):
    return 0 <= r < len(grid) and 0 <= c < len(grid[0])

def dijkstras(graph, start):
    dist = {}
    prev = defaultdict(list)

    for node in graph:
        dist[node] = math.inf

    dist[start] = 0
    prev[start] = [None]

    # Priority Queue
    pq = [(0,start)]
    heapq.heapify(pq)

    visited = set()
    while pq:
        weight, node = heapq.heappop(pq)
        if node in visited:
            continue
        
        visited.add(node)
        
        for neighbor, weight in graph[node]:
            if dist[neighbor] >= dist[node] + weight:
                dist[neighbor] = dist[node] + weight
                heapq.heappush(pq, (dist[neighbor], neighbor))
                prev[neighbor].append(node)
    
    return dist, prev


if __name__ == "__main__":
    with open("day16.txt") as f:
        maze = [list(x) for x in f.read().split("\n")]
    
    nrows = len(maze)
    ncols = len(maze[0])

    graph = defaultdict(list)
    for r in range(nrows):
        for c in range(ncols):
            if maze[r][c] == "S":
                start = ((r,c), 'east')
            if maze[r][c] =="E":
                end_idx = (r,c)

            for curr_direction in DIRECTIONS:
                graph[((r,c),curr_direction)] = []
                for next_direction in ALLOWED_MOVES[curr_direction]:
                    dr, dc = DIRECTIONS[next_direction]
                    weight = ALLOWED_MOVES[curr_direction][next_direction]
                    if is_in_bounds(maze, r + dr, c + dc):
                        if maze[r+dr][c+dc] == "." or maze[r+dr][c+dc]== "E":
                            graph[((r,c),curr_direction)].append((((r+dr,c+dc), next_direction), weight))

    distances, prev = dijkstras(graph, start)
    min = math.inf
    for direction in DIRECTIONS:
        if distances[(end_idx, direction)] <= min:
            end_state = (end_idx, direction)
            min = distances[(end_idx, direction)]

    path_nodes = set()
    queue = [end_state]

    while queue:
        next = queue.pop()
        if next is not None:
            path_nodes.add(next[0])
            queue.extend(prev[next])
    
    print(len(path_nodes))
```

## What I Learned
### Python Priority Queue and Heaps
* `heapq` can be used to implement a priority queue in Python.
* By default, `heapq` is a minimum heap, where the value that is popped always the minimum value in the heap.
* A min heap is a data structure that is *almost* a complete binary tree, and the only missing nodes are on the bottom right of the graph, and every parent is <= its children.
* In a min heap, the root node is the minimum value in the heap.

### Dijkstra's Algorithm
* Dijkstra's Algorithm is a graph algorithm for finding the shortest path from a specified source to all other nodes in a graph.
* Dijkstra's can be used for weighted or unweighted graphs, but for weighted graphs the weights cannot be negative, or you can end up in a negative cycle (if the graph has a cycle).
* Dijkstra's utilizes a priority queue to find which of the nodes I have not yet visited are the closest, and then visits that node next.
* The priority queue helps improve the performance and efficiency of the algorithm, as it is easy to retrieve the current min distance for an unexplored node.
* When a node is visited, its neighbors are added to the priority queue, allowing these neighbors to be selected as the next possible visit.

### Don't use `min` as a variable name
* `min` is also a built-in Python function, so this could lead to confusion or misunderstanding in some contexts.

### When to not use `deque`
* I tried using `deque` at first so that I could get the paths as a true stack rather than a queue, but this does not work in this case because the tuples would be converted to a list inside the `deque`, which meant that the pair itself wouldn't be considered, just its individual values (the row and column in the maze).
* ChatGPT also tried to use `deque` before I corrected it, and as a result, its code looked about the same as mine in the end.

### ChatGPT's Mistakes are Still Helpful
* After some back and forth and trying to debug the "improved" code, there was no functioning code from ChatGPT that gave the correct answer, and I found myself mostly converting it back to my own code.
* Though the process did not produce an improved solution, iterating with ChatGPT still offered a few useful insights (such as not using `min` as a variable name, rediscovering why not to use `deque` in this context, etc).
