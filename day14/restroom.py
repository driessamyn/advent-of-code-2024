from pathlib import Path
import os

class Robot:
    def __init__(self, position, velocity, grid_size):
        self.initial_position = position
        self.position = position
        self.velocity = velocity
        self.grid_size = grid_size
        
    def reset(self):
        self.position = self.initial_position
        return self

    def move_for(self, seconds):
        distance = (
            self.position[0] + self.velocity[0] * seconds,
            self.position[1] + self.velocity[1] * seconds
        )
        # wrap around
        self.position = (
            distance[0] % self.grid_size[0], 
            distance[1] % self.grid_size[1]
            )

        return distance

    def __str__(self):
        return "Robot(position={}, velocity={})".format(self.position, self.velocity)   
        self.y = y

def calculate_safety_factor(grid_size, robots):
    quadrant_width = grid_size[0] // 2
    quadrant_height = grid_size[1] // 2

    quadrants = [0,0,0,0]

    for robot in robots:
        if robot.position[0] < quadrant_width and robot.position[1] < quadrant_height:
            quadrants[0] += 1
        elif robot.position[0] > quadrant_width and robot.position[1] < quadrant_height:
            quadrants[1] += 1
        elif robot.position[0] < quadrant_width and robot.position[1] > quadrant_height:
            quadrants[2] += 1
        elif robot.position[0] > quadrant_width and robot.position[1] > quadrant_height:
            quadrants[3] += 1
        print("Quadrants ({}): {}".format(robot.position, quadrants))

    print("Quadrants ({},{}): {}".format(quadrant_width, quadrant_height, quadrants))
    return quadrants[0] * quadrants[1] * quadrants[2] * quadrants[3]

def parse_input(input, grid_size):
    robots = []
    for line in input.splitlines():
        position, velocity = (
            tuple(int(x.strip()) for x in line.split("v=")[0].split("p=")[1].strip("<> ").split(",")),
            tuple(int(x.strip()) for x in line.split("v=")[1].strip("<> ").split(","))
        )
        robots.append(Robot(position, velocity, grid_size))
    return robots

def print_grid(grid_size, robots):        
    grd = [[0 for _ in range(grid_size[0])] for _ in range(grid_size[1])]
    for robot in robots:
        grd[robot.position[1]][robot.position[0]] += 1

    for row in grd:
        for c in row:
            if c == 0:
                print(".", end="")
            else:
                print(c, end="")
        print()

def move_robots(robots, seconds):
    for robot in robots:
        robot.move_for(seconds)

def are_robots_together(robots, cluster_size):
    positions = {(r.position[0], r.position[1]) for r in robots}
    
    # Get bounds to reduce search space
    min_x = min(p[0] for p in positions)
    max_x = max(p[0] for p in positions)
    min_y = min(p[1] for p in positions)
    max_y = max(p[1] for p in positions)
    
    # Only check areas where robots actually are
    for y in range(min_x, max_x - cluster_size + 2):
        for x in range(min_y, max_y - cluster_size + 2):
            if all((x+dx, y+dy) in positions 
                   for dx in range(cluster_size) 
                   for dy in range(cluster_size)):
                print(f"Cluster found at ({x}, {y})")
                return True
    return False # Use x,y order

      

# NOTE positions are Left/Top, not Row/Column on grid!
if __name__ == "__main__":
    input = Path('test-data.txt').read_text()
    test_grid_size = (11, 7)

    example_robot = Robot((2, 4), (2, -3), test_grid_size)
    print(example_robot.move_for(1))
    print(example_robot.move_for(2))
    print(example_robot.move_for(3))
    print(example_robot.move_for(4))
    print(example_robot.move_for(5))
    print("-------")
    robots = parse_input(input, test_grid_size)
    for robot in robots:
        print(robot)
        print("move from: {}".format(robot.position))
        print(robot.move_for(100))
        print ("moved to: {}".format(robot.position))
    print_grid(test_grid_size, robots)
    print("test data safety factor: {}".format(calculate_safety_factor(test_grid_size, robots)))

    robots.append(Robot((2, 1), (1, 1), test_grid_size))
    robots.append(Robot((3, 1), (1, 1), test_grid_size))
    robots.append(Robot((2, 2), (1, 1), test_grid_size))
    robots.append(Robot((3, 2), (1, 1), test_grid_size))
    print("-------")
    print_grid(test_grid_size, robots)
    are_robots_together(robots, 2)

    print("------- PART 1")
    input = Path('data.txt').read_text()
    grid_size = (101, 103)
    robots = parse_input(input, grid_size)
    for robot in robots:
        # print("move from: {}".format(robot.position))
        print(robot.move_for(100))
        print ("moved to: {}".format(robot.position))
    print_grid(grid_size, robots)
    print("test data safety factor: {}".format(calculate_safety_factor(grid_size, robots)))

    print("------- PART 2 WTF is a christmas tree ??")
    # trying approach of finding clusters of robot, then printing the grid
    seconds = 1
    while True:
        move_robots(robots, 1)
        if are_robots_together(robots, 3):
            print("------------------ Found tree after {} seconds --------------------".format(seconds))
            print_grid(grid_size, robots)
            break
            print("----------------------------------------------------------")
        if seconds % 1000 == 0:
            print("Checked {}".format(seconds))
        seconds += 1
    print("END")
