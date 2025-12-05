/*
 * https://adventofcode.com/2025/day/4
 */

import 'dart:collection';
import 'dart:io';
import '../../day.dart';

typedef PaperRollsCoords = HashSet<(int row, int col)>;

PaperRollsCoords parse(File file) {
  final result = HashSet<(int row, int col)>();
  final lines = file.readAsLinesSync();
  for (var row = 0; row < lines.length; row++) {
    for (var col = 0; col < lines[row].length; col++) {
      if (lines[row][col] == '@') {
        result.add((row, col));
      }
    }
  }

  return result;
}

int part1(PaperRollsCoords input) {
  int result = input.fold(0, (acc, coord) {
    int adjecentCount = 0;
    final (row, col) = coord;
    for (var adjRow = row - 1; adjRow <= row + 1; adjRow++) {
      for (var adjCol = col - 1; adjCol <= col + 1; adjCol++) {
        if (adjRow == row && adjCol == col) {
          continue;
        }
        if (input.contains((adjRow, adjCol))) {
          adjecentCount++;
        }
      }
    }

    return adjecentCount < 4 ? acc + 1 : acc;
  });

  print("Rolls of paper to be able to be accessed: ${answer(result)}");
  return result;
}

int part2(PaperRollsCoords input) {
  final originalPaperRollsCount = input.length;

  HashSet<(int row, int col)> getRemoveable(
    HashSet<(int row, int col)> current,
  ) {
    final toRemove = HashSet<(int row, int col)>();
    for (var coord in current) {
      int adjecentCount = 0;
      final (row, col) = coord;
      for (var adjRow = row - 1; adjRow <= row + 1; adjRow++) {
        for (var adjCol = col - 1; adjCol <= col + 1; adjCol++) {
          if (adjRow == row && adjCol == col) {
            continue;
          }
          if (current.contains((adjRow, adjCol))) {
            adjecentCount++;
          }
        }
      }

      if (adjecentCount < 4) {
        toRemove.add(coord);
      }
    }

    return toRemove;
  }

  var toRemove = getRemoveable(input);
  while (toRemove.isNotEmpty) {
    input.removeAll(toRemove);
    toRemove = getRemoveable(input);
  }

  final result = originalPaperRollsCount - input.length;
  print("Rolls of paper to be able to be removed: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(4, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 13)]);
  day.runPart(2, part2, [Pair("example_input.txt", 43)]);
}
