/*
 * https://adventofcode.com/2020/day/1
 */

import 'dart:collection';
import 'dart:io';
import '../../day.dart';

typedef Input = Iterable<int>;

Input parse(File file) {
  return file.readAsLinesSync().map(int.parse);
}

(int, int)? findTwoNumsTargetSum(Input input, int target) {
  HashSet desiredNumbers = HashSet();
  for (var n in input) {
    int other = target - n;
    if (desiredNumbers.contains(other)) {
      // found
      return (n, other);
    }
    desiredNumbers.add(n);
  }
  return null;
}

int part1(Input input) {
  final x = findTwoNumsTargetSum(input, 2020);
  if (x != null) {
    final (a, b) = x;
    int result = a * b;
    print("$a * $b = ${answer(result)}");
    return result;
  }
  return 0;
}

int part2(Input input) {
  const target = 2020;
  int i = 0;
  for (var e in input) {
    final r = target - e;
    final x = findTwoNumsTargetSum(input.skip(i), r);
    if (x != null) {
      final (a, b) = x;
      int result = a * b * e;
      print("$a * $b * $e = ${answer(result)}");
      return result;
    }
    i++;
  }
  return 0;
}

void main(List<String> args) {
  Day day = Day(1, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 514579)]);
  day.runPart(2, part2, [Pair("example_input.txt", 241861950)]);
}
