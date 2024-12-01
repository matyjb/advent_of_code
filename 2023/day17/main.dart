/*
 * https://adventofcode.com/2023/day/17
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<List<int>>;

enum Direction { up, down, left, right }

typedef CrucibleState = ({(int, int, int) pos, Direction direction});

Input parse(File file) {
  return file
      .readAsLinesSync()
      .map((e) => e.split('').map(int.parse).toList())
      .toList();
}

Map<(int, int, int), int> heatLossTo((int, int) start, Input input) {
  // djikstra
  Map<(int, int, int), int> heatLoss = {
    (start.$1, start.$2 + 1, 2): input[start.$1][start.$2 + 1],
    (start.$1 + 1, start.$2, 2): input[start.$1 + 1][start.$2],
  };
  List<CrucibleState> queue = [
    (pos: (start.$1, start.$2 + 1, 2), direction: Direction.right),
    (pos: (start.$1 + 1, start.$2, 2), direction: Direction.down),
  ];

  while (queue.isNotEmpty) {
    CrucibleState current = queue.removeAt(0);

    List<CrucibleState> possibleStates = [
      if (current.direction != Direction.left)
        (
          pos: (
            current.pos.$1,
            current.pos.$2 + 1,
            current.direction == Direction.right ? current.pos.$3 - 1 : 2
          ),
          direction: Direction.right,
        ),
      if (current.direction != Direction.right)
        (
          pos: (
            current.pos.$1,
            current.pos.$2 - 1,
            current.direction == Direction.left ? current.pos.$3 - 1 : 2
          ),
          direction: Direction.left
        ),
      if (current.direction != Direction.up)
        (
          pos: (
            current.pos.$1 + 1,
            current.pos.$2,
            current.direction == Direction.down ? current.pos.$3 - 1 : 2
          ),
          direction: Direction.down
        ),
      if (current.direction != Direction.down)
        (
          pos: (
            current.pos.$1 - 1,
            current.pos.$2,
            current.direction == Direction.up ? current.pos.$3 - 1 : 2
          ),
          direction: Direction.up
        ),
    ]
        .where((element) =>
            element.pos.$3 > 0 &&
            element.pos.$1 >= 0 &&
            element.pos.$1 < input.length &&
            element.pos.$2 >= 0 &&
            element.pos.$2 < input.first.length)
        .toList();

    for (var ppath in possibleStates) {
      int newHeatLoss =
          heatLoss[current.pos]! + input[current.pos.$1][current.pos.$2];
      if (heatLoss[ppath.pos] == null || heatLoss[ppath.pos]! > newHeatLoss) {
        queue.add(ppath);
      }
      heatLoss.update(
        ppath.pos,
        (value) => min(value, newHeatLoss),
        ifAbsent: () => newHeatLoss,
      );
    }
  }
  return heatLoss;
}

int part1(Input input) {
  final dst = heatLossTo((0, 0), input);
  int result = [
    dst[(input.length - 1, input.first.length - 1, 0)],
    dst[(input.length - 1, input.first.length - 1, 1)],
    dst[(input.length - 1, input.first.length - 1, 2)],
  ].where((e) => e != null).fold(2000, (a, b) => min(a, b!));

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
  Day day = Day(17, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 102)]);
  // day.runPart(2, part2, [Pair("example_input.txt", 0)]);
}
