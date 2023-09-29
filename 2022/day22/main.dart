/*
 * https://adventofcode.com/2022/day/22
 */

import 'dart:io';
import '../../day.dart';

class Input {
  final List<String> map;
  final List<dynamic> instructions;

  Input(this.map, this.instructions);
}

Input parse(File file) {
  RegExp instructionsLine = RegExp(r'[\dRL]+');
  RegExp mapLine = RegExp(r'[\s\.#]+');

  List<String> map = [];
  List<dynamic> instructions = [];
  for (var line in file.readAsLinesSync()) {
    if (mapLine.hasMatch(line)) {
      map.add(line);
    } else if (instructionsLine.hasMatch(line)) {
      var numbersMatches = RegExp(r'\d+').allMatches(line);
      var lettersMatches = RegExp(r'[RL]').allMatches(line);
      List<RegExpMatch> sortedmatches = []
        ..addAll(numbersMatches)
        ..addAll(lettersMatches)
        ..sort((a, b) => a.start.compareTo(b.start));

      instructions = sortedmatches.map((e) {
        String matched = e.group(0)!;
        if (matched != "R" && matched != "L") {
          return int.parse(matched);
        } else {
          return matched;
        }
      }).toList();
    }
  }
  return Input(map, instructions);
}

enum Direction { right, down, left, up }

bool inBounds(List<String> map, Point2D point) {
  return point.v0 < map.length &&
      point.v0 >= 0 &&
      point.v1 < map[point.v0].length &&
      point.v1 >= 0;
}

class Turtle {
  Point2D position = Point2D();
  Direction facing = Direction.right;

  // true if moved
  // false if could not move (wall)
  bool moveByOne(List<String> map) {
    Point2D nextPosition = position +
        {
          Direction.up: Point2D(-1, 0),
          Direction.right: Point2D(0, 1),
          Direction.down: Point2D(1, 0),
          Direction.left: Point2D(0, -1),
        }[facing]!;

    //check if in bounds
    if (!inBounds(map, nextPosition)) {
      int row = nextPosition.v0 % map.length;
      int col = nextPosition.v1 % map[row].length;
      nextPosition = Point2D(row, col);
    }

    // check if empty
    if (map[nextPosition.v0][nextPosition.v1] == " ") {
      // wrap around
      switch (facing) {
        case Direction.right:
          int newCol = map[nextPosition.v0].indexOf(RegExp(r'[#\.]'));
          nextPosition = Point2D(nextPosition.v0, newCol);
          break;
        case Direction.left:
          int newCol = map[nextPosition.v0].lastIndexOf(RegExp(r'[#\.]'));
          nextPosition = Point2D(nextPosition.v0, newCol);
          break;
        case Direction.up:
          String tmp = map.lastWhere(
              (l) => l[nextPosition.v1] == "#" || l[nextPosition.v1] == ".");
          int newRow = map.indexOf(tmp);
          nextPosition = Point2D(newRow, nextPosition.v1);
          break;
        case Direction.down:
          String tmp = map.firstWhere(
              (l) => l[nextPosition.v1] == "#" || l[nextPosition.v1] == ".");
          int newRow = map.indexOf(tmp);
          nextPosition = Point2D(newRow, nextPosition.v1);
          break;
        default:
      }
    }

    // check if wall
    if (inBounds(map, nextPosition) &&
        map[nextPosition.v0][nextPosition.v1] == "#") {
      return false;
    }

    position = nextPosition;
    return true;
  }

  void rotate(String dir) {
    if (dir == "R") {
      facing = {
        Direction.up: Direction.right,
        Direction.right: Direction.down,
        Direction.down: Direction.left,
        Direction.left: Direction.up,
      }[facing]!;
    } else if (dir == "L") {
      facing = {
        Direction.up: Direction.left,
        Direction.left: Direction.down,
        Direction.down: Direction.right,
        Direction.right: Direction.up,
      }[facing]!;
    }
  }

  @override
  String toString() {
    return "$position | ${facing.name}";
  }
}

int part1(Input input) {
  Turtle turtle = Turtle()..position = Point2D(0, input.map.first.indexOf("."));

  for (var ins in input.instructions) {
    if (ins is int) {
      for (var i = 0; i < ins; i++) {
        if (!turtle.moveByOne(input.map)) {
          break;
        }
      }
    } else if (ins is String) {
      turtle.rotate(ins);
    }
  }
  int result = 1000 * (turtle.position.v0 + 1) +
      4 * (turtle.position.v1 + 1) +
      turtle.facing.index;
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
  Day day = Day(22, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 6032)]);
  day.runPart(2, part2, [Pair("example_input.txt", 5031)]);
}
