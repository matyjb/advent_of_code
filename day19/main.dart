/*
 * https://adventofcode.com/2021/day/19
 */

import 'dart:io';
import '../day.dart';
import 'package:vector_math/vector_math.dart';

typedef Input = List<List<Vector3>>;


Input parse(File file) {
  Input scanners = [];
  int currentScanner = 0;
  for (var line in file.readAsLinesSync()) {
    if (RegExp(r"--- scanner \d ---").hasMatch(line)) {
      currentScanner =
          int.parse(line.replaceAll("--- scanner ", "").replaceAll(" ---", ""));
      scanners.add([]);
    } else if (RegExp(r"-?\d+,-?\d+,-?\d+").hasMatch(line)) {
      List<double> values = line.split(",").map((e) => double.parse(e)).toList();
      Vector3 v = Vector3(values[0],values[1],values[2]);
      scanners[currentScanner].add(v);
    }
  }
  return scanners;
}

void part1(Input numbers) {

  printTodo();
}

void part2(Input numbers) {
  printTodo();
}

void main(List<String> args) {
  Day day = Day<Input>(19, "input.txt", parse);
  day.runPart<Input>(1, part1);
  day.runPart<Input>(2, part2);
}
