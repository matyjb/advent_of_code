/*
 * https://adventofcode.com/2023/day/10
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<String>;
typedef Coords = (int row, int col);

Input parse(File file) {
  return file.readAsLinesSync();
}

Coords findStartPosition(Input input) {
  for (var row = 0; row < input.length; row++) {
    final col = input[row].indexOf("S");
    if (col != -1) return (row, col);
  }
  throw "Starting position not found in the puzzle input";
}

Coords getAnyNextOkPipeToS(Input input, Coords start) {
// only two pipes are connected to the S, need to find one of them
  Map<Coords, List<String>> possibilities = {
    (start.$1 + 1, start.$2): ["|", "L", "J"],
    (start.$1 - 1, start.$2): ["|", "F", "7"],
    (start.$1, start.$2 + 1): ["-", "J", "7"],
    (start.$1, start.$2 - 1): ["-", "L", "F"],
  };
  // remove out of bounds
  possibilities.removeWhere(
    (pos, _) =>
        pos.$1 < 0 ||
        pos.$1 >= input.length ||
        pos.$2 < 0 ||
        pos.$2 >= input.first.length,
  );
  // get first ok pipe
  return possibilities.entries
      .firstWhere((e) => e.value.contains(input[e.key.$1][e.key.$2]))
      .key;
}

Coords getNextPos(Coords c, Coords prev, Input input) {
  return switch (input[c.$1][c.$2]) {
    "|" => [(c.$1 - 1, c.$2), (c.$1 + 1, c.$2)].firstWhere((e) => e != prev),
    "-" => [(c.$1, c.$2 - 1), (c.$1, c.$2 + 1)].firstWhere((e) => e != prev),
    "L" => [(c.$1 - 1, c.$2), (c.$1, c.$2 + 1)].firstWhere((e) => e != prev),
    "J" => [(c.$1, c.$2 - 1), (c.$1 - 1, c.$2)].firstWhere((e) => e != prev),
    "7" => [(c.$1, c.$2 - 1), (c.$1 + 1, c.$2)].firstWhere((e) => e != prev),
    "F" => [(c.$1, c.$2 + 1), (c.$1 + 1, c.$2)].firstWhere((e) => e != prev),
    "S" => throw "$c is starting pipe",
    _ => throw "$c is not a pipe",
  };
}

int part1(Input input) {
  final startPos = findStartPosition(input);
  final okPipe = getAnyNextOkPipeToS(input, startPos);

  List<Coords> slowP = [startPos, okPipe];
  List<Coords> fastP = [startPos, okPipe];
  int steps = 0;
  do {
    steps++;
    final nextSlow = getNextPos(slowP.last, slowP.first, input);
    slowP
      ..add(nextSlow)
      ..removeAt(0);
    final nextFast = getNextPos(fastP.last, fastP.first, input);
    fastP
      ..add(nextFast)
      ..removeAt(0);
    try {
      final nextFast2 = getNextPos(fastP.last, fastP.first, input);
      fastP
        ..add(nextFast2)
        ..removeAt(0);
    } catch (ex) {
      break;
    }
  } while (!fastP.any((e) => e == startPos));

  print("Steps to farthest point in the loop: ${answer(steps)}");
  return steps;
}

int part2(Input input) {
  final startPos = findStartPosition(input);
  final okPipe = getAnyNextOkPipeToS(input, startPos);

  List<Coords> slowP = [startPos, okPipe];
  Set<Coords> loopCoords = {startPos, okPipe};
  do {
    final nextSlow = getNextPos(slowP.last, slowP.first, input);
    loopCoords.add(nextSlow);
    slowP
      ..add(nextSlow)
      ..removeAt(0);
  } while (slowP.last != startPos);

  // scan lines and count inside
  int result = 0;
  for (int row = 0; row < input.length; row++) {
    bool inside = false;
    bool bottom = false;
    for (int col = 0; col < input[row].length; col++) {
      final isLoop = loopCoords.contains((row, col));

      if (isLoop) {
        final pipeType = input[row][col];
        switch((pipeType, bottom)) {
          case ("F", _):
            bottom = false;
            break;
          case ("L", _):
            bottom = true;
            break;
          case ("|", _):
          case ("7", true):
          case ("J", false):
            inside = !inside;
            break;
        }
      } else if (inside) {
        result++;
      }
    }
  }

  print("Space inside the loop: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(10, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 8)]);
  day.runPart(2, part2, [
    Pair("example_input.txt", 1),
    Pair("example_input_2.txt", 4),
  ]);
}
