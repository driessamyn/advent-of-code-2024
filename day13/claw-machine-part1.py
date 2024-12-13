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

    def get_to_prize_in(self, x, y):
        # calculate slope of x,y to price
        slope = (self.prize[1] - y) / (self.prize[0] - x)
        # if it's the same, we have a match
        if(slope == self.slopeB):
            return (self.prize[0] - x) // self.b[0]
        return -1
    
    def try_to_reach_prize(self):
        # spend as few of A as possible
        # try one by one and see if we can reach price using B
        a = 0;
        # TODO: we can optimise the max further by see how far the max X/Y is
        while(0 < 100 and a * self.a[0] < self.prize[0] and a * self.a[1] < self.prize[1]):
            aX = a * self.a[0]
            aY = a * self.a[1]

            b = self.get_to_prize_in(aX, aY)
            # print("a: {} - b: {}".format(a, b))
            if b != -1:
                return a * COST_A + b * COST_B
            a += 1
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
        cost = machine.try_to_reach_prize()
        if(cost != -1):
            total_cost += cost
            print("machine: {} - cost: {}, total: {}".format(machine, cost, total_cost))
    return total_cost

if __name__ == "__main__":
    input = Path('test-data.txt').read_text()
    machines = parse_input(input)
    print(total_cost(machines))
    print("---")
    input = Path('data.txt').read_text()
    machines = parse_input(input)
    print(total_cost(machines))

    
