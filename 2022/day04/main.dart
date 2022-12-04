/*
 * https://adventofcode.com/2022/day/4
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<Pair<Pair<int, int>, Pair<int, int>>>;

Input parse(File file) {
  return file.readAsLinesSync().map((e) {
    var r = RegExp(r'\d+');
    List<int> numbers =
        r.allMatches(e).map((e) => int.parse(e.group(0)!)).toList();
    return Pair(Pair(numbers[0], numbers[1]), Pair(numbers[2], numbers[3]));
  }).toList();
}

int part1(Input input) {
  int result = 0;
  for (var p in input) {
    if (p.v0.v0 >= p.v1.v0 && p.v0.v1 <= p.v1.v1 ||
        p.v1.v0 >= p.v0.v0 && p.v1.v1 <= p.v0.v1) {
      result++;
    }
  }
  print("Overlapping fully elves: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;

  for (var p in input) {
    // if first elf ends before the other or other way around.
    // this situation is ok - they dont overlap
    if (!(p.v0.v1 < p.v1.v0 || p.v1.v1 < p.v0.v0)) {
      result++;
    }
  }
  print("Overlapping elves: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(4, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 2)]);
  day.runPart(2, part2, [Pair("example_input.txt", 4)]);
}
