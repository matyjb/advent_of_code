/*
 * https://adventofcode.com/2020/day/3
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<String>;
typedef Slope = ({int dx, int dy});

Input parse(File file) {
  return file.readAsLinesSync();
}

int countTrees(Input input, Slope slope) {
  int x = 0;
  int countTrees = 0;
  for (var y = 0; y < input.length; y += slope.dy) {
    if (input[y][x] == "#") {
      countTrees++;
    }
    x = (x + slope.dx) % input[y].length;
  }
  return countTrees;
}

int part1(Input input) {
  const Slope slope = (dx: 3, dy: 1);
  final result = countTrees(input, slope);
  print("Trees encountered: ${answer(result)}");
  return result;
}

int part2(Input input) {
  List<Slope> slopes = [
    (dx: 1, dy: 1),
    (dx: 3, dy: 1),
    (dx: 5, dy: 1),
    (dx: 7, dy: 1),
    (dx: 1, dy: 2),
  ];

  int result = slopes.fold(1, (mul, slope) => mul * countTrees(input, slope));
  print("Multiplied trees: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(3, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 7)]);
  day.runPart(2, part2, [Pair("example_input.txt", 336)]);
}
