/*
 * https://adventofcode.com/2022/day/9
 */

import 'dart:io';
import '../../day.dart';

enum Direction { up, down, left, right }

const Map<String, Direction> directionMap = {
  "U": Direction.up,
  "D": Direction.down,
  "L": Direction.left,
  "R": Direction.right,
};

class Movement {
  final Direction direction;
  final int steps;

  Movement(this.direction, this.steps);
  factory Movement.fromLine(String line) {
    List<String> values = line.split(" ");
    return Movement(directionMap[values[0]]!, int.parse(values[1]));
  }
}

typedef Input = List<Movement>;

Input parse(File file) {
  return file.readAsLinesSync().map(Movement.fromLine).toList();
}

// ordered list of possible moves by rope segment
// horizontal and vertical moves must be first
final List<Point2D> segmentPossibleMoves = [
  Point2D(0, 1),
  Point2D(0, -1),
  Point2D(1, 0),
  Point2D(-1, 0),
  Point2D(1, 1),
  Point2D(-1, -1),
  Point2D(1, -1),
  Point2D(-1, 1),
];

void applyMovementBy1(List<Point2D> rope, Direction direction) {
  // move head according to direction
  switch (direction) {
    case Direction.up:
      rope[0] += Point2D(1, 0);
      break;
    case Direction.down:
      rope[0] += Point2D(-1, 0);
      break;
    case Direction.right:
      rope[0] += Point2D(0, 1);
      break;
    case Direction.left:
      rope[0] += Point2D(0, -1);
      break;
    default:
  }

  // move all the other segments to the new position
  // if Planck length is bigger than 1
  for (var i = 1; i < rope.length; i++) {
    Point2D segmentBefore = rope[i - 1];
    if (segmentBefore.planckLength(rope[i]) > 1) {
      Point2D nextPosition = segmentBefore +
          segmentPossibleMoves.firstWhere(
              (pos) => rope[i].planckLength(segmentBefore + pos) < 2);

      rope[i] = nextPosition;
    }
  }
}

int getSolutionForRopeOfLen(int ropeLen, Input input) {
  Set<Point2D> visitedLocByTail = Set();
  // head, segments and tail on the starting position 0,0
  List<Point2D> rope = List.generate(ropeLen, (i) => Point2D());
  for (var movement in input) {
    for (var i = 0; i < movement.steps; i++) {
      applyMovementBy1(rope, movement.direction);
      visitedLocByTail.add(rope.last.copy());
    }
  }

  return visitedLocByTail.length;
}

int part1(Input input) {
  int result = getSolutionForRopeOfLen(2, input);
  print("Tail visited ${answer(result)} points");
  return result;
}

int part2(Input input) {
  int result = getSolutionForRopeOfLen(10, input);
  print("Tail visited ${answer(result)} points");
  return result;
}

void main(List<String> args) {
  Day day = Day(9, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 13)]);
  day.runPart(2, part2, [
    Pair("example_input.txt", 1),
    Pair("example_input2.txt", 36),
  ]);
}
