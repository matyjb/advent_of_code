/*
 * https://adventofcode.com/2022/day/23
 */

import 'dart:collection';
import 'dart:io';
import '../../day.dart';

typedef Elves = List<Point2D>;

Elves parse(File file) {
  List<Point2D> elves = [];
  List<String> lines = file.readAsLinesSync();
  for (var row = 0; row < lines.length; row++) {
    for (var col = 0; col < lines[row].length; col++) {
      if (lines[row][col] == "#") elves.add(Point2D(col, row));
    }
  }
  return elves;
}

List<Point2D> moveVectorsByDirIndex = [
  Point2D(0, -1), // N
  Point2D(0, 1), // S
  Point2D(-1, 0), // W
  Point2D(1, 0), // E
  //
  Point2D(-1, -1), // NW
  Point2D(1, 1), // SE
  Point2D(-1, 1), // SW
  Point2D(1, -1), // NE
];

List<bool Function(Point2D, Elves)> moveRules = [
  // north
  (p, e) => ![0, 4, 7]
      .any((dirIndex) => e.contains(p + moveVectorsByDirIndex[dirIndex])),
  // south
  (p, e) => ![1, 5, 6]
      .any((dirIndex) => e.contains(p + moveVectorsByDirIndex[dirIndex])),
  // west
  (p, e) => ![2, 4, 6]
      .any((dirIndex) => e.contains(p + moveVectorsByDirIndex[dirIndex])),
  // east
  (p, e) => ![3, 5, 7]
      .any((dirIndex) => e.contains(p + moveVectorsByDirIndex[dirIndex])),
  // main rule - must have other elf around
  (p, e) => moveVectorsByDirIndex.any((element) => e.contains(element + p))
];

void printElves(Elves elves) {
  Pair<Point2D, Point2D> rect = Point2D.boundingRect(elves);
  Point2D topLeft = rect.v0;
  Point2D bottomRight = rect.v1;

  for (var row = topLeft.v1; row <= bottomRight.v1; row++) {
    for (var col = topLeft.v0; col <= bottomRight.v0; col++) {
      stdout.write(elves.contains(Point2D(col, row)) ? "#" : ".");
    }
    stdout.writeln();
  }
}

HashMap<Point2D, Point2D> proposedMoves(Elves elves, int roundCount) {
  // calculates all possible moves for each elf
  HashMap<Point2D, Point2D> result = HashMap();
  for (var elf in elves) {
    if (moveRules.last(elf, elves))
      for (var i = 0; i < 4; i++) {
        int moveDirIndex = (roundCount + i) % 4;
        if (moveRules[moveDirIndex](elf, elves)) {
          result.putIfAbsent(
            elf,
            () => elf + moveVectorsByDirIndex[moveDirIndex],
          );
          break;
        }
      }
  }
  return result;
}

void filterConflicts(HashMap<Point2D, Point2D> moves) {
  // if each two or more elves has the same proposition delete them from the map
  moves.removeWhere((key, value) =>
      moves.entries.any((e) => e.key != key && e.value == value));
}

// return number of moves done this round
int simulateRound(Elves elves, int roundCount) {
  HashMap<Point2D, Point2D> nextPositionsForEachElf =
      proposedMoves(elves, roundCount);
  filterConflicts(nextPositionsForEachElf);
  for (var change in nextPositionsForEachElf.entries) {
    elves.remove(change.key);
    elves.add(change.value);
  }
  return nextPositionsForEachElf.length;
}

int part1(Elves input) {
  int roundCount = 0;
  Elves elves = List.from(input);

  for (roundCount = 0; roundCount < 10; roundCount++) {
    simulateRound(elves, roundCount);
  }

  // calculate empty spaces
  Pair<Point2D, Point2D> rect = Point2D.boundingRect(elves);
  Point2D topLeft = rect.v0;
  Point2D bottomRight = rect.v1;

  int dimXLen = (bottomRight.v0 - topLeft.v0).abs() + 1;
  int dimYLen = (bottomRight.v1 - topLeft.v1).abs() + 1;

  int result = dimXLen * dimYLen - elves.length;
  print("Empty spaces: ${answer(result)}");
  return result;
}

int part2(Elves input) {
  int roundCount = 0;
  Elves elves = List.from(input);

  int movesThisRound = 0;
  do {
    movesThisRound = simulateRound(elves, roundCount);
    roundCount++;
  } while (movesThisRound != 0);

  int result = roundCount;
  print("Empty spaces: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(23, "input.txt", parse);
  day.runPart(1, part1, [
    Pair("example_input_1.txt", 25),
    Pair("example_input_2.txt", 110),
  ]);
  day.runPart(2, part2, [
    Pair("example_input_1.txt", 4),
    Pair("example_input_2.txt", 20),
  ]);
}
