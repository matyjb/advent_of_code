/*
 * https://adventofcode.com/2021/day/25
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

enum Cucumber { right, down, none }
const Map<String, Cucumber> charToCucumber = {
  ".": Cucumber.none,
  "v": Cucumber.down,
  ">": Cucumber.right,
};

typedef World = List<List<Cucumber>>;

void printWorld(World world) {
  for (var y = 0; y < world.length; y++) {
    for (var x = 0; x < world.first.length; x++) {
      switch (world[y][x]) {
        case Cucumber.right:
          stdout.write("\x1B[32m>");
          break;
        case Cucumber.down:
          stdout.write("\x1B[35mv");
          break;
        case Cucumber.none:
          stdout.write("\x1B[34m.");
          break;
        default:
      }
    }
    stdout.write("\n\x1B[0m");
  }
}

World parse(File file) {
  return file
      .readAsLinesSync()
      .map((e) => e.split("").map((e) => charToCucumber[e]!).toList())
      .toList();
}

List<Point<int>> ableToMove(World world, Cucumber type) {
  List<Point<int>> result = [];
  for (var y = 0; y < world.length; y++) {
    for (var x = 0; x < world.first.length; x++) {
      switch (type) {
        case Cucumber.right:
          if (world[y][x] == Cucumber.right &&
              world[y][(x + 1) % world.first.length] == Cucumber.none) {
            result.add(Point<int>(x, y));
          }
          break;
        case Cucumber.down:
          if (world[y][x] == Cucumber.down &&
              world[(y + 1) % world.length][x] == Cucumber.none) {
            result.add(Point<int>(x, y));
          }
          break;
        default:
      }
    }
  }
  return result;
}

// return amount of moves made this step
int performStep(World world) {
  List<Point<int>> rightMoves = ableToMove(world, Cucumber.right);
  for (var move in rightMoves) {
    world[move.y][move.x] = Cucumber.none;
    world[move.y][(move.x + 1) % world.first.length] = Cucumber.right;
  }

  List<Point<int>> downMoves = ableToMove(world, Cucumber.down);
  for (var move in downMoves) {
    world[move.y][move.x] = Cucumber.none;
    world[(move.y + 1) % world.length][move.x] = Cucumber.down;
  }
  return rightMoves.length + downMoves.length;
}

void part1(World input) {
  print("\x1b[?25l"); // hide cursor
  print("\x1B[2J\x1B[0;0H");//clear console
  print("Initial");
  printWorld(input);
  stdin.readLineSync();
  int step = 0, moves = 0;
  do {
    step++;
    moves = performStep(input);
    print("\x1B[0;0H");//move carret to 0,0
    print("After $step step:");
    printWorld(input);
    sleep(Duration(milliseconds: 0));
  } while (moves > 0);
  print("Cucumbers stable\nafter ${answer(step)} steps.");
  print("\x1b[?25h"); // show cursor
}

void part2(World input) {
  printTodo();
  print("The answer is: ${answer("todo")}");
}

void main(List<String> args) {
  Day day = Day<World>(25, "smallExample2.txt", parse);
  // Day day = Day<World>(25, "input.txt", parse);
  day.runPart<World>(1, part1);
  // day.runPart<World>(2, part2);
}
