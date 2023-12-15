/*
 * https://adventofcode.com/2023/day/15
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<String>;

Input parse(File file) {
  return file.readAsStringSync().trim().split(",");
}

int hash(String str) {
  return str.codeUnits.fold(
    0,
    (hash, codeUnit) => ((hash + codeUnit) * 17) % 256,
  );
}

int part1(Input input) {
  int result = input.fold(0, (hashSum, str) => hashSum + hash(str));

  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

int part2(Input input) {
  // stores where the lens with gives label is stored
  Map<String, int> lensBoxLocation = {};
  // stores current lens focal wherever it is
  Map<String, int> lensFocals = {};
  // stores lenses order by label
  List<List<String>> boxes = List.generate(256, (_) => []);

  for (var operation in input) {
    if (operation.endsWith("-")) {
      final label = operation.substring(0, operation.length - 1);
      final boxIdx = lensBoxLocation[label];
      if (boxIdx != null) {
        boxes[boxIdx].removeWhere((element) => element == label);
        lensBoxLocation.remove(label);
      }
    } else {
      final t = operation.split("=");
      final label = t.first;
      final focal = int.parse(t.last);
      if (!lensBoxLocation.containsKey(label)) {
        final boxIdx = hash(label);
        boxes[boxIdx].add(label);
        lensBoxLocation[label] = boxIdx;
      }
      lensFocals[label] = focal;
    }
  }

  int result = 0;
  for (var i = 0; i < boxes.length; i++) {
    final boxMul = i + 1;
    for (var j = 0; j < boxes[i].length; j++) {
      final slotMul = j + 1;
      result += lensFocals[boxes[i][j]]! * boxMul * slotMul;
    }
  }
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(15, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 1320)]);
  day.runPart(2, part2, [Pair("example_input.txt", 145)]);
}
