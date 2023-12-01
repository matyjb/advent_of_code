/*
 * https://adventofcode.com/2023/day/1
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<String>;

Input parse(File file) {
  return file.readAsLinesSync();
}

int part1(Input input) {
  final digitRe = RegExp(r'\d');
  int result = input.fold(0, (sum, value) {
    final matches = digitRe.allMatches(value);
    return sum +
        int.parse(matches.first.group(0)!) * 10 +
        int.parse(matches.last.group(0)!);
  });

  print("Sum of all values: ${answer(result)}");
  return result;
}

int part2(Input input) {
  Map<String, int> digitNames = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
  };
  _reversed(String value) => value.split('').reversed.join();
  _mapToValue(String value) => switch (value.length) {
        1 => int.parse(value),
        _ => digitNames[value]!,
      };

  final names = digitNames.keys.join('|');
  final namesReversed = digitNames.keys.map(_reversed).join('|');
  final digitRe = RegExp('\\d|$names');
  final digitReReversed = RegExp('\\d|$namesReversed');

  int result = input.fold(0, (sum, value) {
    final match = digitRe.firstMatch(value)!.group(0)!;
    final matchReversed =
        digitReReversed.firstMatch(_reversed(value))!.group(0)!;
    final digFirst = _mapToValue(match);
    final digLast = _mapToValue(_reversed(matchReversed));

    return sum + digFirst * 10 + digLast;
  });

  print("Sum of all values: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(1, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input_part1.txt", 142)]);
  day.runPart(2, part2, [Pair("example_input_part2.txt", 281 + 83)]);
}
