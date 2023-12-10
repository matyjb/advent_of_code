/*
 * https://adventofcode.com/2023/day/9
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<List<int>>;

Input parse(File file) {
  final numbersRe = RegExp(r'-?\d+');
  return file
      .readAsLinesSync()
      .map(
        (e) => numbersRe
            .allMatches(e)
            .map(
              (e) => int.parse(e.group(0)!),
            )
            .toList(),
      )
      .toList();
}

List<int> getEdgeNumbers(List<int> history, [bool getLeftEdge = false]) {
  List<int> next = List.from(history);
  List<int> edgeNumbers = [getLeftEdge ? history.first : history.last];
  while (next.any((element) => element != 0)) {
    for (var i = 0; i < next.length - 1; i++) {
      next[i] = next[i + 1] - next[i];
    }
    next.removeLast();
    if (next.isNotEmpty) {
      edgeNumbers.add(getLeftEdge ? next.first : next.last);
    }
  }
  return edgeNumbers;
}

int part1(Input input) {
  int result = 0;
  for (var history in input) {
    final edgeNumbers = getEdgeNumbers(history);
    result += edgeNumbers.sum() as int;
  }
  print("Sum of next values: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;
  for (var history in input) {
    final edgeNumbers = getEdgeNumbers(history, true);
    final r = edgeNumbers.reversed.reduce((value, element) => element - value);
    result += r;
  }
  print("Sum of previous values: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(9, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 114 + 8)]);
  day.runPart(2, part2, [Pair("example_input_2.txt", -8)]);
}
