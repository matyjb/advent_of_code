/*
 * https://adventofcode.com/2020/day/7
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<int>;

Input parse(File file) {
  return file.readAsLinesSync().map((e) => int.parse(e)).toList();
}

int part1(Input input) {
  int result = 0;

  printTodo();
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;

  printTodo();
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(7, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 0)]);
  day.runPart(2, part2, [Pair("example_input.txt", 0)]);
}