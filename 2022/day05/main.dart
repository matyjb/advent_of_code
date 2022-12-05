/*
 * https://adventofcode.com/2022/day/5
 */

import 'dart:io';
import '../../day.dart';

final numberRe = RegExp(r'\d+');
final stacksLineRe = RegExp(r'(\[[A-Z]\])+');
final instructionLineRe = RegExp(r'move \d+ from \d+ to \d+');

class Stacks {
  final Map<int, List<String>> stacks = {};

  void addCrate(String crate, int stack) {
    stacks.update(
      stack,
      (value) => value..add(crate),
      ifAbsent: () => [crate],
    );
  }

  void applyInstruction(Instruction instruction, [bool reversed = true]) {
    List<String> crates =
        stacks[instruction.from]!.take(instruction.amount).toList();
    stacks[instruction.from]!.removeRange(0, instruction.amount);
    stacks[instruction.to]!.insertAll(0, reversed ? crates.reversed : crates);
  }
}

class Instruction {
  final int amount;
  final int from;
  final int to;
  Instruction(this.amount, this.from, this.to);
  factory Instruction.fromLine(String line) {
    List<int> numbers =
        numberRe.allMatches(line).map((e) => int.parse(e.group(0)!)).toList();
    return Instruction(numbers[0], numbers[1], numbers[2]);
  }
}

typedef Input = Pair<Stacks, List<Instruction>>;

Input parse(File file) {
  Stacks stacks = Stacks();
  List<Instruction> instructions = List.empty(growable: true);
  for (var line in file.readAsLinesSync()) {
    if (stacksLineRe.hasMatch(line)) {
      var allMatches = stacksLineRe.allMatches(line);
      for (var match in allMatches) {
        int stackId = ((match.start) ~/ 4) + 1;
        String crate = match.group(0)![1];
        stacks.addCrate(crate, stackId);
      }
    } else if (instructionLineRe.hasMatch(line)) {
      instructions.add(Instruction.fromLine(line));
    }
  }
  return Pair(stacks, instructions);
}

String getTopCrates(Input input, [bool reversed = true]) {
  for (var instruction in input.v1) {
    input.v0.applyInstruction(instruction, reversed);
  }
  StringBuffer topCrates = StringBuffer();
  for (int stackId in input.v0.stacks.keys.toList()..sort()) {
    topCrates.write(input.v0.stacks[stackId]![0]);
  }
  return topCrates.toString();
}

String part1(Input input) {
  String result = getTopCrates(input);
  print("Top crates: ${answer(result)}");
  return result;
}

String part2(Input input) {
  String result = getTopCrates(input, false);
  print("Top crates: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(5, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", "CMZ")]);
  day.runPart(2, part2, [Pair("example_input.txt", "MCD")]);
}
