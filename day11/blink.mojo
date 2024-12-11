from collections import Dict

from data import get_part1_input

fn blink(stone: Int) -> List[Int]:
    var result = List[Int]()
    if stone == 0:
        result.append(1)
    else:
        var stone_str = str(stone)
        var sl = len(stone_str)
        if sl % 2 == 0:
            var half_digits = sl // 2
            var divisor = 10 ** half_digits
            result.append(stone // divisor)
            result.append(stone % divisor)
        else:
            result.append(2024 * stone)
    return result

struct Cache:
    var _data: Dict[Int, Dict[Int, Int]]

    fn __init__(inout self):
        self._data = Dict[Int, Dict[Int, Int]]()

fn keep_blinking(stone: Int, times: Int, inout cache: Cache) raises -> Int:
    if times == 0:
        return stone

    if stone not in cache._data:
        cache._data[stone] = Dict[Int, Int]()

    if cache._data[stone].get(times, -1) != -1:
        return cache._data[stone][times]

    var count = 0
    if times == 1:
        count = len(blink(stone))
    else:
        var blink_results = blink(stone)
        for i in range(len(blink_results)):
            var st = blink_results[i]
            count += keep_blinking(st, times - 1, cache)

    cache._data[stone][times] = count
    return count

fn count_them(stones: List[Int], blinks: Int) raises -> Int:
    var total = 0
    var cache = Cache()
    for i in range(len(stones)):
        total += keep_blinking(stones[i], blinks, cache)
    return total

fn parse_string_to_int_list(input: String) raises -> List[Int]:
    var result = List[Int]()
    var parts = input.split()
    for i in range(len(parts)):
        result.append(int(parts[i]))
    return result

fn main() raises:
    var small_list = List[Int](2)
    small_list.append(125)
    small_list.append(17)

    print("Small list")
    for i in range(len(small_list)):
        print(small_list[i])

    var test_stones = count_them(small_list, 6)
    print("Test stones (6 blinks):")
    print(test_stones)
    print("---------------------")

    test_stones = count_them(small_list, 25)
    print("Test stones (25 blinks):")
    print(test_stones)
    print("---------------------")

    var part1_data = parse_string_to_int_list(get_part1_input())
    var part1 = count_them(part1_data, 25)
    print("Part 1 (25 blinks):")
    print(part1)
    print("---------------------")

    var part2 = count_them(part1_data, 75)
    print("Part 2 (75 blinks):")
    print(part2)
    print("---------------------")