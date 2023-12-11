/*
 * https://adventofcode.com/2023/day/11
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<String>;

Input parse(File file) {
  return file.readAsLinesSync();
}

int sumDistancesAfterExpansion(Input input, int expansion) {
  List<int> emptyColsIndexes = [];
  List<int> emptyRowsIndexes = [];
  List<(int row, int col)> galaxies = [];

  // tmp list for calculating which columns dont have galaxies
  List<bool> emptyCols = List.generate(input.first.length, (_) => true);

  for (var row = 0; row < input.length; row++) {
    bool isEmptyRow = true;
    for (var col = 0; col < input.first.length; col++) {
      if (input[row][col] == "#") {
        emptyCols[col] = false;
        isEmptyRow = false;
        galaxies.add((row, col));
      }
    }
    if (isEmptyRow) {
      emptyRowsIndexes.add(row);
    }
  }

  for (var col = 0; col < emptyCols.length; col++) {
    if (emptyCols[col]) {
      emptyColsIndexes.add(col);
    }
  }

  int sumOfPaths = 0;
  for (var i = 0; i < galaxies.length; i++) {
    final g1 = galaxies[i];
    for (var j = i + 1; j < galaxies.length; j++) {
      final g2 = galaxies[j];
      final rowMin = min(g1.$1, g2.$1);
      final rowMax = max(g1.$1, g2.$1);
      final colMin = min(g1.$2, g2.$2);
      final colMax = max(g1.$2, g2.$2);
      final rowsExpanded = emptyRowsIndexes
          .where((rowIdx) => rowIdx > rowMin && rowIdx < rowMax)
          .length;
      final colsExpanded = emptyColsIndexes
          .where((colIdx) => colIdx > colMin && colIdx < colMax)
          .length;
      final origDistance = (g1.$1 - g2.$1).abs() + (g1.$2 - g2.$2).abs();
      final dist =
          origDistance + (rowsExpanded + colsExpanded) * (expansion - 1);
      // print("$g1<->$g2: $origDistance + $rowsExpanded + $colsExpanded = $dist", true);
      sumOfPaths += dist;
    }
  }
  return sumOfPaths;
}

int part1(Input input) {
  final expansion = 2; // count empty this many times
  final result = sumDistancesAfterExpansion(input, expansion);
  print("Sum of distances (expansion=$expansion): ${answer(result)}");
  return result;
}

int part2(Input input) {
  final expansion = 1000000;
  final result = sumDistancesAfterExpansion(input, expansion);
  print("Sum of distances (expansion=$expansion): ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(11, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 374)]);
  day.runPart(2, part2);
}
