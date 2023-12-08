/*
 * https://adventofcode.com/2023/day/8
 */

import 'dart:io';
import '../../day.dart';

typedef NodesMap = Map<String, ({String left, String right})>;
typedef Input = ({String instructions, NodesMap nodes});

Input parse(File file) {
  final nodeRe =
      RegExp(r"(?<name>[A-Z\d]+) = \((?<left>[A-Z\d]+), (?<right>[A-Z\d]+)\)");
  final instructionsRe = RegExp(r"[RL]+");

  final lines = file.readAsStringSync();
  String instructions = instructionsRe.firstMatch(lines)!.group(0)!;
  NodesMap nodes = Map.fromEntries(
      nodeRe.allMatches(lines).map((e) => MapEntry(e.namedGroup("name")!, (
            left: e.namedGroup("left")!,
            right: e.namedGroup("right")!,
          ))));

  return (instructions: instructions, nodes: nodes);
}

int getStepsUntil(
  String start,
  bool Function(String currentNode) until,
  Input input,
) {
  int steps = 0;

  while (!until(start)) {
    final currentInstruction =
        input.instructions[steps % input.instructions.length];

    start = switch (currentInstruction) {
      "R" => input.nodes[start]!.right,
      "L" => input.nodes[start]!.left,
      _ => throw "panic!",
    };
    steps++;
  }
  return steps;
}

int part1(Input input) {
  int steps = getStepsUntil(
    "AAA",
    (currentNode) => currentNode == "ZZZ",
    input,
  );

  print("Steps to reach ZZZ: ${answer(steps)}");
  return steps;
}

int part2(Input input) {
  List<String> nodes =
      input.nodes.keys.where((e) => e[e.length - 1] == "A").toList();

  // apparently every loop starts at the starting node, so its just part 1 with lcm
  final List<int> allSteps = nodes
      .map((node) => getStepsUntil(
            node,
            (currentNode) => currentNode.endsWith("Z"),
            input,
          ))
      .toList();

  int steps = allSteps.reduce(lcm);

  print("Steps to meet at **Z: ${answer(steps)}");
  return steps;
}

void main(List<String> args) {
  Day day = Day(8, "input.txt", parse);
  day.runPart(1, part1, [
    Pair("example_input.txt", 2),
    Pair("example_input_2.txt", 6),
  ]);
  day.runPart(2, part2, [
    Pair("example_input_3.txt", 6),
  ]);
}
