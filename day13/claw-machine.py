from pathlib import Path
import os
import re

COST_A = 3
COST_B = 1

class Machine:
    def __init__(self, a, b, prize):
        self.a = a
        self.b = b
        self.prize = prize
        self.slopeA = self.a[1]/ self.a[0]
        self.slopeB = self.b[1] / self.b[0]
        self.count = 0
    
    def calculate_cost(self):
        # for part 2, I had to brunch up maths
        # I worked this out on paper like this:
        # with A and B number of button pushes for A and B respectively:
        # Ax * A + Bx * B = Px
        # Ay * A + By * B = Py
        #
        # Using algebra, we can solve for A and B:
        # B = (Py - Ay * A) / By
        # Substitute B into the first equation:
        # Ax * A + Bx * ((Py - Ay * A) / By) = Px
        # Simplified:
        # A = (Px * By - Bx * Py) / (Ax * By - Bx * Ay)
        # So ...
        a = (self.prize[0] * self.b[1] - self.b[0] * self.prize[1]) / (self.a[0] * self.b[1] - self.b[0] * self.a[1])
        b = (self.prize[1] - self.a[1] * a) / self.b[1]
        print("a: {}, b: {}".format(a, b))
        if(a.is_integer() and b.is_integer()):
            return int(a * COST_A + b * COST_B)
        return -1
       
    def __str__(self):
        return "A: {}, B: {}, Prize: {} - slopes: {}, {}".format(self.a, self.b, self.prize, self.slopeA, self.slopeB)

def parse_input(input: str):
    machines = []
    for machine in input.split(2*os.linesep):
        a = tuple(map(int, re.findall(r"A: X\+(\d+), Y\+(\d+)", machine)[0]))
        b = tuple(map(int, re.findall(r"B: X\+(\d+), Y\+(\d+)", machine)[0]))
        prize = tuple(map(int, re.findall(r"Prize: X\=(\d+), Y\=(\d+)", machine)[0]))
        machines.append(Machine(a, b, prize))
    return machines

def total_cost(machines):
    total_cost = 0
    for machine in machines:
        cost = machine.calculate_cost()
        if(cost != -1):
            total_cost += cost
            print("machine: {} - cost: {}, total: {}".format(machine, cost, total_cost))
    return total_cost

def adjust_machines(machines):
    for machine in machines:
        machine.prize = (machine.prize[0] + 10000000000000, machine.prize[1] + 10000000000000)

if __name__ == "__main__":
    print("--- test ---")
    input = Path('test-data.txt').read_text()
    machines = parse_input(input)
    print(total_cost(machines))
    print("--- part 1 ---")
    input = Path('data.txt').read_text()
    machines = parse_input(input)
    print(total_cost(machines))
    print("--- part 2 ---")
    adjust_machines(machines)
    print(total_cost(machines))
