/*
 * https://adventofcode.com/2025/day/1
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<Movement>;
enum Direction { l, r }

class Movement {
  final Direction direction;
  final int distance;

  Movement(this.direction, this.distance);

  (int newPosition, int fullTurns) applyTo(
    int position, [
    int maxPosition = 99,
  ]) {
    switch (direction) {
      case Direction.l:
        return (
          (position - distance) % (maxPosition + 1),
          distance ~/ (maxPosition + 1),
        );
      case Direction.r:
        return (
          (position + distance) % (maxPosition + 1),
          distance ~/ (maxPosition + 1),
        );
    }
  }

  @override
  String toString() {
    return "Movement $direction $distance";
  }
}

Input parse(File file) {
  RegExp rx = RegExp(r'([LR])(\d+)');

  List<String> lines = file.readAsLinesSync();

  Input movements = [];
  for (var line in lines) {
    final match = rx.firstMatch(line);
    if (match != null) {
      final dir = match.group(1)!;
      final dist = match.group(2)!;
      movements.add(
        Movement(switch (dir) {
          "L" => Direction.l,
          "R" => Direction.r,
          String() => throw UnimplementedError(),
        }, int.parse(dist)),
      );
    }
  }

  return movements;
}

int part1(Input movements) {
  int pointingAtZero = 0;
  int position = 50;

  for (var movement in movements) {
    final (newPosition, _) = movement.applyTo(position);
    position = newPosition;
    if (position == 0) pointingAtZero++;
  }

  print("Pointing at zero ${answer(pointingAtZero)} times");
  return pointingAtZero;
}

int part2(Input movements) {
  int pointingAtZero = 0;
  int position = 50;

  for (var movement in movements) {
    final (nextPosition, fullTurns) = movement.applyTo(position);
    if (nextPosition == 0)
      pointingAtZero++;
    else if (position != 0) {
      if (movement.direction == Direction.l && position < nextPosition) {
        pointingAtZero++;
      }
      if (movement.direction == Direction.r && position > nextPosition) {
        pointingAtZero++;
      }
    }

    position = nextPosition;
    pointingAtZero += fullTurns;
  }

  print("Pointing at zero ${answer(pointingAtZero)} times");
  return pointingAtZero;
}

void main(List<String> args) {
  Day day = Day<Input>(1, "input.txt", parse);
  day.runPart<Input>(1, part1, [Pair("smallExample.txt", 3)]);
  day.runPart<Input>(2, part2, [Pair("smallExample.txt", 6)]);
}
