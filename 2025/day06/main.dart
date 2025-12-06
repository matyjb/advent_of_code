/*
 * https://adventofcode.com/2025/day/6
 */

import 'dart:io';
import '../../day.dart';

typedef InputPart1 = (List<List<int>> number, List<String> commands);
typedef InputPart2 = List<dynamic>; // int or string

InputPart1 parsePart1(File file) {
  final rxNumbers = RegExp(r'\d+');
  final rxCommands = RegExp(r'[+*]');

  final numbers = <List<int>>[];
  final commands = <String>[];

  for (var line in file.readAsLinesSync()) {
    final numberMatches = rxNumbers.allMatches(line);
    final commandMatches = rxCommands.allMatches(line);

    if (numberMatches.isNotEmpty) {
      final numberList = numberMatches
          .map((m) => int.parse(m.group(0)!))
          .toList();
      numbers.add(numberList);
    }
    if (commandMatches.isNotEmpty) {
      final commandList = commandMatches.map((m) => m.group(0)!).toList();
      commands.addAll(commandList);
    }
  }

  return (numbers, commands);
}

InputPart2 parsePart2(File file) {
  final lines = file.readAsLinesSync();
  final columnsLength = lines.first.length;

  final numbers = <dynamic>[];

  for (var col = 0; col < columnsLength; col++) {
    if (lines.last[col] == '*' || lines.last[col] == '+') {
      numbers.add(lines.last[col]);
    }

    final numbersBuffer = StringBuffer();
    for (var row = 0; row < lines.length - 1; row++) {
      final char = lines[row][col];
      if (char != ' ') {
        numbersBuffer.write(char);
      }
    }
    if (numbersBuffer.isNotEmpty) {
      numbers.add(int.parse(numbersBuffer.toString()));
    }
  }

  return numbers;
}

int part1(InputPart1 input) {
  int result = 0;

  for (var eqIndex = 0; eqIndex < input.$2.length; eqIndex++) {
    final command = input.$2[eqIndex];

    int eqResult = input.$1.first[eqIndex];
    for (var i = 1; i < input.$1.length; i++) {
      if (command == '+') {
        eqResult += input.$1[i][eqIndex];
      } else if (command == '*') {
        eqResult *= input.$1[i][eqIndex];
      }
    }
    result += eqResult;
  }

  print("Calculation result: ${answer(result)}");
  return result;
}

int part2(InputPart2 input) {
  int result = 0;

  String machineState = input.first as String;
  int eqAcc = input[1] as int;
  for (var i = 2; i < input.length; i++) {
    final element = input[i];
    if (element is String) {
      machineState = element;
      result += eqAcc;
      eqAcc = input[++i] as int;
    } else if (element is int) {
      if (machineState == '+') {
        eqAcc += element;
      } else if (machineState == '*') {
        eqAcc *= element;
      }
    }
  }
  result += eqAcc;

  print("Calculation result: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day dayPart1 = Day(6, "input.txt", parsePart1);
  Day dayPart2 = Day(6, "input.txt", parsePart2);
  dayPart1.runPart(1, part1, [Pair("example_input.txt", 4277556)]);
  dayPart2.runPart(2, part2, [Pair("example_input.txt", 3263827)]);
}
