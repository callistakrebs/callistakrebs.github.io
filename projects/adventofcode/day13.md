# Advent of Code - Day 13
[< Prev Day](day12.html) [Next Day >](day14.html)

## Part 1
### My Code
```{.python .numberLines}
import re
from scipy.optimize import linprog

def findXandY(line):
    pattern = r"Button .: X\+(\d+), Y\+(\d+)"
    return list(map(int,re.findall(pattern, line)[0]))

def findPrize(line):
    pattern = r"Prize: X=(\d+), Y=(\d+)"
    return list(map(int,re.findall(pattern, line)[0]))

if __name__ == "__main__":
    with open("day13.txt") as f:
        machines = [machine.split("\n") for machine in f.read().split("\n\n")]
    
    machine_rules = []
    for machine in machines:
        machine_rules.append({"A": findXandY(machine[0]), "B": findXandY(machine[1]), "Prize": findPrize(machine[2])})

    tokens_min = 0
    c = [3, 1] # A B
    for rule in machine_rules:
        A_eq = [[rule["A"][0], rule["B"][0]], # Ax + Bx + X
                [rule["A"][1], rule["B"][1]],  # Ay + By + Y
                ]
        b_eq = [rule["Prize"][0], rule["Prize"][1]]
        bounds = [(0,100), (0,100)]
        result = linprog(c=c, A_eq=A_eq, b_eq=b_eq, bounds=bounds, integrality=[1,1])
        if result["success"]:
            tokens_min += int(result["fun"]) # This machine is winable, add its tokens to total
    
    print(tokens_min)
```

### ChatGPT's Improved Code
```{.python .numberLines}
import re
from scipy.optimize import linprog

# Constants
COST_COEFFICIENTS = [3, 1]  # Weights for A and B tokens
BOUNDS = [(0, 100), (0, 100)]  # Bounds for A and B tokens

def parse_button_coordinates(line):
    """
    Parse the coordinates of the buttons A and B.
    Example input: "Button A: X+12, Y+34"
    """
    pattern = r"Button .: X\+(\d+), Y\+(\d+)"
    return list(map(int, re.findall(pattern, line)[0]))

def parse_prize_coordinates(line):
    """
    Parse the prize coordinates.
    Example input: "Prize: X=56, Y=78"
    """
    pattern = r"Prize: X=(\d+), Y=(\d+)"
    return list(map(int, re.findall(pattern, line)[0]))

def load_machine_data(file_path):
    """
    Load machine data from the input file and parse rules.
    Returns a list of dictionaries containing machine constraints.
    """
    with open(file_path) as f:
        machines = [machine.split("\n") for machine in f.read().strip().split("\n\n")]

    machine_constraints = []
    for machine in machines:
        machine_constraints.append({
            "A": parse_button_coordinates(machine[0]),
            "B": parse_button_coordinates(machine[1]),
            "Prize": parse_prize_coordinates(machine[2]),
        })
    return machine_constraints

def calculate_minimum_tokens(machine_constraints):
    """
    Calculate the minimum tokens required to win all machines.
    """
    tokens_min = 0
    for rule in machine_constraints:
        # Define linear programming constraints
        A_eq = [
            [rule["A"][0], rule["B"][0]],  # Ax + Bx = PrizeX
            [rule["A"][1], rule["B"][1]],  # Ay + By = PrizeY
        ]
        b_eq = rule["Prize"]
        
        # Solve linear program
        result = linprog(
            c=COST_COEFFICIENTS, 
            A_eq=A_eq, 
            b_eq=b_eq, 
            bounds=BOUNDS, 
            integrality=[1, 1]
        )
        
        if result.success:
            tokens_min += int(result.fun)  # Add minimum tokens for this machine
    return tokens_min

if __name__ == "__main__":
    machine_constraints = load_machine_data("day13.txt")
    tokens_min = calculate_minimum_tokens(machine_constraints)
    print(f"Minimum tokens required: {tokens_min}")
```

## Part 2
### My Code
```{.python .numberLines}
import re
from scipy.optimize import linprog
import numpy as np

def findXandY(line):
    pattern = r"Button .: X\+(\d+), Y\+(\d+)"
    return list(map(int,re.findall(pattern, line)[0]))

def findPrize(line):
    pattern = r"Prize: X=(\d+), Y=(\d+)"
    return list(map(int,re.findall(pattern, line)[0]))

if __name__ == "__main__":
    with open("day13.txt") as f:
        machines = [machine.split("\n") for machine in f.read().split("\n\n")]
    
    machine_rules = []
    for machine in machines:
        machine_rules.append({"A": findXandY(machine[0]), "B": findXandY(machine[1]), "Prize": findPrize(machine[2])})

    tokens_min = 0
    c = [3, 1] # A B
    for rule in machine_rules:
        A_eq = np.array([[rule["A"][0], rule["B"][0]], # Ax + Bx + X
                [rule["A"][1], rule["B"][1]],  # Ay + By + Y
                ], dtype=np.uint64)
        b_eq = np.array([rule["Prize"][0]+10000000000000, rule["Prize"][1]+10000000000000], dtype=np.uint64)
        bounds = [(0,None), (0,None)]
        result = linprog(c=c, A_eq=A_eq, b_eq=b_eq, bounds=bounds, integrality=[1,1],method="highs", options={"autoscale":True, "presolve":False})

        if result["success"]:
            tokens_min += int(result["fun"]) # This machine is winable, add its tokens to total
    
    print(tokens_min)
```
### ChatGPT's Improved Code
```{.python .numberLines}
import re
from scipy.optimize import linprog
import numpy as np

def parse_button_coordinates(line):
    """Parse the coordinates of the buttons A and B."""
    pattern = r"Button .: X\+(\d+), Y\+(\d+)"
    return list(map(int, re.findall(pattern, line)[0]))

def parse_prize_coordinates(line):
    """Parse the prize coordinates."""
    pattern = r"Prize: X=(\d+), Y=(\d+)"
    return list(map(int, re.findall(pattern, line)[0]))

def load_machine_data(file_path):
    """Load and parse machine data from the input file."""
    with open(file_path) as f:
        machines = [machine.split("\n") for machine in f.read().strip().split("\n\n")]
    return [
        {
            "A": parse_button_coordinates(machine[0]),
            "B": parse_button_coordinates(machine[1]),
            "Prize": parse_prize_coordinates(machine[2]),
        }
        for machine in machines
    ]

def solve_machine(rule, cost_coefficients, large_constant):
    """
    Solve the optimization problem for a single machine.
    Returns the minimum tokens if successful, otherwise None.
    """
    # Define constraints
    A_eq = np.array(
        [
            [rule["A"][0], rule["B"][0]],  # Ax + Bx = PrizeX
            [rule["A"][1], rule["B"][1]],  # Ay + By = PrizeY
        ], 
        dtype=np.uint64
    )
    b_eq = np.array(
        [
            rule["Prize"][0] + large_constant,
            rule["Prize"][1] + large_constant,
        ],
        dtype=np.uint64
    )
    bounds = [(0, None), (0, None)]  # Non-negative bounds for A and B

    # Solve linear program
    # Note: Presolve is disabled due to incorrect solutions in some cases with Scipy's linprog
    result = linprog(
        c=cost_coefficients, 
        A_eq=A_eq, 
        b_eq=b_eq, 
        bounds=bounds, 
        integrality=[1, 1], 
        method="highs", 
        options={"autoscale": True, "presolve": False}
    )
    return int(result.fun) if result.success else None

if __name__ == "__main__":
    # Constants
    COST_COEFFICIENTS = [3, 1]  # Weights for A and B tokens
    LARGE_CONSTANT = 10**13  # Adjustment for large prize values

    # Load and process machine data
    machine_rules = load_machine_data("day13.txt")

    # Calculate minimum tokens required
    tokens_min = 0
    for rule in machine_rules:
        result = solve_machine(rule, COST_COEFFICIENTS, LARGE_CONSTANT)
        if result is not None:
            tokens_min += result
        else:
            print(f"Warning: Optimization failed for machine {rule}")

    print(f"Minimum tokens required: {tokens_min}")
```

## What I Learned
### Improved Function Names and Readability
* ChatGPT emphasized using better and more clear function names to make the code more readable, as well as moving some hard coded values to constants rather than dispersed in the code.
* ChatGPT also mentioned the need for comments to explain the less obvious changes between Part 1 and Part 2 (like the reason for the large constant and why I set `presolve` to `false`).

### Solving Linear System without Linear Programming
* I wanted to use linear programming because it was fresh in my mind after taking my graduate algorithms course, but the system can be solved with basic linear algebra and matrix operations instead.
* Since this is a system of 2 equations with 2 unknowns, we can solve this using matrix operations by solving the equation $Ax = b$ where $A$ is the coefficient matrix for our 2 equations, $x$ is the variable matrix, and $b$ is the constant matrix (what each equation is equal to).
* To solve the system, we can take the inverse of $A$, and $x = bA^{-1}$. Note this is only solvable if the determinant of $A$ is not 0.

### Setting `presolve` to False in `scipy.linprog()`
* For part 2, when the numbers were really big, `linprog` kept giving a suboptimal answer. After snooping around the AoC Reddit page, I found a few others who used `linprog` for this problem, and found that `presolve` was the issue.
* The `presolve` parameters tries to rule out trivially infeasible or unbounded possible solutions to simplify the problem. With large numbers like this, it was unfortunately ruling out the solution. [This page](https://docs.scipy.org/doc//scipy-1.4.0/reference/generated/scipy.optimize.linprog.html) is very helpful in explaining the specifics of the `presolve` parameter.
