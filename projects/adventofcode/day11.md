# Advent of Code - Day 11
[< Prev Day](day10.html) [Next Day >](day12.html)

## Part 1
### My Code
```{.python .numberLines}
class Node:
    def __init__(self, value):
        self.value = value
        self.next = None
        self.prev = None

class LinkedList():
    def __init__(self):
        self.head = None

    def insert_at_end(self, new_node):
        if self.head is None:
            self.head = new_node
        else:
            current_node = self.head
            while current_node.next is not None:
                current_node = current_node.next
            new_node.prev = current_node
            current_node.next = new_node

    def blink(self):
        current_node = self.head
        while current_node is not None:
            if current_node.value == '0':
                current_node.value = '1'
            elif len(current_node.value) % 2 != 0: # odd number of digits
                current_node.value = str(int(current_node.value) * 2024)
            else:
                self.split_node(current_node)
    
            current_node = current_node.next

    def split_node(self, current_node):
        new_val = current_node.value[0:len(current_node.value)// 2]
        current_node.value = str(int(current_node.value[len(current_node.value) // 2:])) # Cast to int to remove leading 0's
        
        new_node = Node(new_val)
        new_node.next = current_node # insert new node on the left
        new_node.prev = current_node.prev
        
        if current_node.prev is not None:
            current_node.prev.next = new_node
        else:
            # Current_node is head, update head
            self.head = new_node

        current_node.prev = new_node
    
    def __str__(self):
        result = []
        current_node = self.head
        while current_node is not None:
            result.append(current_node.value)
            result.append(' ')
            current_node = current_node.next
        return ''.join(result)

    def print_reverse(self):
        current_node = self.head
        while current_node.next is not None:
            current_node = current_node.next
        
        while current_node is not None:
            print(current_node.value)
            current_node = current_node.prev

    def __len__(self):
        result = 0
        current_node = self.head
        while current_node is not None:
            result += 1
            current_node = current_node.next
        return result

if __name__ == "__main__":
    with open("day11.txt") as f:
        stones = f.read().split()
    
    stones_list = LinkedList()
    for stone in stones:
        stones_list.insert_at_end(Node(stone))

    for i in range(25):
        stones_list.blink()
    print(f"Total stones after 25 blinks: {len(stones_list)}")
```

### ChatGPT's Improved Code
```{.python .numberLines}
class Node:
    def __init__(self, value: str):
        self.value: str = value
        self.next: Node | None = None
        self.prev: Node | None = None

class LinkedList:
    def __init__(self):
        self.head: Node | None = None
        self.tail: Node | None = None

    def insert_at_end(self, new_node: Node) -> None:
        if self.head is None:
            self.head = new_node
            self.tail = new_node
        else:
            self.tail.next = new_node
            new_node.prev = self.tail
            self.tail = new_node

    def blink(self) -> None:
        current_node = self.head
        while current_node:
            if current_node.value == '0':
                current_node.value = '1'
            elif len(current_node.value) % 2 != 0:  # Odd number of digits
                current_node.value = str(int(current_node.value) * 2024)
            else:
                self.split_node(current_node)
            current_node = current_node.next

    def split_node(self, current_node: Node) -> None:
        mid = len(current_node.value) // 2
        left_part, right_part = current_node.value[:mid], current_node.value[mid:]
        current_node.value = str(int(right_part))  # Remove leading zeros
        new_node = Node(left_part)
        new_node.next = current_node
        new_node.prev = current_node.prev
        if current_node.prev:
            current_node.prev.next = new_node
        else:
            self.head = new_node
        current_node.prev = new_node

    def __str__(self) -> str:
        result = []
        current_node = self.head
        while current_node:
            result.append(current_node.value)
            current_node = current_node.next
        return ' '.join(result)

    def __len__(self) -> int:
        current_node = self.head
        return sum(1 for _ in iter(lambda: current_node, None))

def read_input(file_path: str) -> LinkedList:
    with open(file_path) as f:
        stones = f.read().split()
    stones_list = LinkedList()
    for stone in stones:
        stones_list.insert_at_end(Node(stone))
    return stones_list

if __name__ == "__main__":
    stones_list = read_input("day11.txt")
    for _ in range(25):
        stones_list.blink()
    print(f"Total stones after 25 blinks: {len(stones_list)}")
```

## Part 2
### My Code
```{.python .numberLines}
from functools import cache
from collections import defaultdict

@cache
def blink(stone, blinks_remaining = 75):
    nstones = 1
    if blinks_remaining <= 0:
        return nstones

    if stone == '0':
        return blink('1', blinks_remaining-1)

    elif len(stone) % 2 != 0:
        return blink(str(int(stone) * 2024), blinks_remaining-1)

    else:
        return blink(str(int(stone[len(stone) // 2:])), blinks_remaining-1) + blink(stone[0:len(stone)// 2], blinks_remaining-1)


if __name__ == "__main__":
    with open("day11.txt") as f:
        stones = f.read().split()
    
    counts = defaultdict(int)
    for stone in stones:
        counts[stone] += blink(stone)

    print(f"Total stones after 75 blinks: {sum(counts.values())}")
```
### ChatGPT's Improved Code
```{.python .numberLines}
@cache
def blink(stone: str, blinks_remaining: int = MAX_BLINKS) -> int:
    """
    Recursive function to calculate the number of stones after a given number of blinks.

    Args:
        stone (str): The current stone value.
        blinks_remaining (int): The number of blinks left to process.

    Returns:
        int: The total number of stones resulting from this stone.
    """
    if blinks_remaining <= 0:
        return 1  # Base case: a single stone remains

    if stone == '0':
        return blink('1', blinks_remaining - 1)

    if len(stone) % 2 != 0:  # Odd length
        return blink(str(int(stone) * MULTIPLIER), blinks_remaining - 1)

    # Even length: split into two stones
    mid = len(stone) // 2
    left, right = stone[:mid], stone[mid:]
    return blink(right, blinks_remaining - 1) + blink(left, blinks_remaining - 1)
```

## What I Learned
### Overloading `print()` in Python
* You can't directly overload the `print` function, but instead can overload the `__str__` or `__repr__`.
* To overload `__str__`, we define the `__str__` function inside of the object, and the function should return the string you want to represent the object.
* Now, if the object is passed to `print()`, it will print the string defined inside of `__str__`.
* We can do the same thing by overloading `__repr__`, and when `__repr__` is defined without `__str__` then `__str__ = __repr__`.
* From [this Stack Overflow post](https://stackoverflow.com/questions/1436703/what-is-the-difference-between-str-and-repr), the goal of `__repr__` is to be unambigous while the goal of `__str__` is to be readable. 
* In other words, 2 different objects of the same type should produce *different* `__repr__` strings but might have the same `__str__` representation.

### `functools.cache()`
* A built-in Python function cache I didn't know existed until now!
* Creates a dictionary for function arguments, and stores their values as the result the function returns.
* This is super convenient when implementing memoization with recursion or dynamic programming.

### Linked List Review
* I decided to implement a linked list for part 1, partially because the insertions would be constant time, and partially because I hadn't implemented a linked list in a long time.
* In Python, we can implement a linked list by creating a Node class for each node and LinkedList class to track the whole list.
* In the LinkedLink class, we can implement any functions we will need to interact with and keep track of the list, such as adding to the end, adding to the front, adding at an index, etc.
* In a singly linked list, each node only knows what node is after it.
* In a doubly linked list, each node knows what node is before and after it.
* It is good practice to track the head and tail of the list, which makes it easier (and faster) to add to both ends of the list.

### Type Annotations in Python
* Though they aren't enforced types, you can declare the type of each function input which can help with code readibility and debugging
* Type annotations are defined after the variable is declared, with a colon (i.e. `self.value: str = value`, where in this case `self.value` should be type `str`).
* For return type annotations, we can use `->` after the function defintion (i.e. `def blink(self) -> None:`, where the function `blink` has return type `None`).

### Function docstrings
* Python docstrings are really helpful for code readibility, I haven't been using them in this project since the scripts are all pretty short, but ChatGPT's docstring for the recursive function is a good reminder of how useful they can be.

### Recursion Readibility
* There is no need to use an `if-else` block inside a recursive function if each if statement is returning.
* Without the `if-else` I think ChatGPT's recursion is a little cleaner and easier to understand at first glance.

