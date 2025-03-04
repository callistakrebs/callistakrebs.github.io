# Advent of Code - Wrap Up
[< Prev Day](day16.html)

I know, I know... it's 25 days of Christmas not 16. But the holidays got busy and I wanted to move on to a new project, so I gave myself until December 31 to finish as many of the problems I could, and then I called it. So, we ended up with 16 days.

Overall, this was a really fun first just-for-me code adventure. The problems are interesting and challenging, the story line keeps it more engaging than generic LeetCode problems, and I enjoyed the Reddit community of people solving the same problems at the same time. So with that, here is a quick summary of some of the interesting stuff I learned along the way!

## Some useful things I learned
### Collections
* The Python Collections module has several useful items such as `counter` and `defaultdict`.
* The `counter` object can tally the number of occurences of items in a list. It returns a dictionary with the items as keys and the values as the number of times the item occured in the list.
* You can also use `counter` to generate a list with a specified number of each element.
* `defaultdict` is a dictionary object but lets you define a default value for items that are not yet defined. This makes it easier to avoid a `KeyError` when accessing items in the dictionary, because if a key does not exist, it is created with the default value.

### Efficiency
* String concatenations in Python are expensive. Instead, you can create a list of the strings you want to concatenate, and then use `join` to combine them into one string.
* Using break statements in code can improve performance if you are using loops to search for a solution to something. Despite my long held belief that breaks should be avoided, in these situations it can save time so that you don't do unnecessary iterations of the loop.

### Convenient Python Tricks
* You can use integer math to avoid having to cast the result of math to integers. For example `a // b` is the integer result of `a` divided by `b`.
* `List.index()` can be used to get the index of the first instance of an element in a list.
* `itertools.product()` returns the cartesian product of the input, which is the set of all pairs of items in the input.
* Use `enumerate` to avoid having to manually track an index when looping through a list.
* Regex groups (not just Python). When you include parentheses in the Regex, only the items in the parentheses will be returned, but the whole regex will still be matched.
* `functools.cache` is a built-in function cache that when used, creates a dictionary for the function arguments and stores the function output as their value.
* `zip()` takes any number of iterators as an argument, and returns the pairs (or groups) of each element at each position in the iterators.
* `heapq` is a built-in priority queue in Python, implemented as a minimum heap.

### Tricky Python Tricks
* Tuple comparisons are done elementwise, so comparing one tuple to another (in terms of >, <, ==), the first element of each tuple is compared, then the second, and so on.
* Copy behavior. A shallow copy of a list duplicates the outermost level of the list, but the items within the list reference the same object in memory. This means if you shallow copy a list of lists (an array), the rows will be duplicated, but the values in each row will still be a pointer to the original row. To avoid this issue, you have to use `deepcopy` instead.
* Overloading print. In Python, we overload `__str__` or `__repr__` and then when the object is passed to `print()`, whatever is returned by these is what is printed. `print()` will look for `__str__` first, and then use `__repr__` if it does not find it.