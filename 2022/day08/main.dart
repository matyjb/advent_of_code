/*
 * https://adventofcode.com/2022/day/8
 */

import 'dart:collection';
import 'dart:io';
import '../../day.dart';

typedef Input = List<String>;
final zeroCodeUnit = "0".codeUnitAt(0);

Input parse(File file) {
  return file.readAsLinesSync().toList();
}

HashSet<Pair<int, int>> findVisibleTrees(Input input) {
  HashSet<Pair<int, int>> result = HashSet();
  
  // left right
  for (var row = 0; row < input.length; row++) {
    String currentRow = input[row];
    int highestTreeFromLeft = 0;
    int highestTreeFromRight = 0;
    for (var col = 0; col < currentRow.length; col++) {
      if (currentRow.codeUnitAt(col) > highestTreeFromLeft) {
        highestTreeFromLeft = currentRow.codeUnitAt(col);
        result.add(Pair(row, col));
      }
      int antiCol = currentRow.length - col - 1;
      if (currentRow.codeUnitAt(antiCol) > highestTreeFromRight) {
        highestTreeFromRight = currentRow.codeUnitAt(antiCol);
        result.add(Pair(row, antiCol));
      }
    }
  }

  // top bottom
  for (var col = 0; col < input.first.length; col++) {
    int highestTreeFromTop = 0;
    int highestTreeFromBottom = 0;
    for (var row = 0; row < input.length; row++) {
      String currentRow = input[row];
      if (currentRow.codeUnitAt(col) > highestTreeFromTop) {
        highestTreeFromTop = currentRow.codeUnitAt(col);
        result.add(Pair(row, col));
      }

      String currentAntiRow = input[input.length - row - 1];
      if (currentAntiRow.codeUnitAt(col) > highestTreeFromBottom) {
        highestTreeFromBottom = currentAntiRow.codeUnitAt(col);
        result.add(Pair(input.length - row - 1, col));
      }
    }
  }

  return result;
}

int part1(Input input) {
  HashSet trees = findVisibleTrees(input);
  int result = trees.length;
  print("Trees visible from outside: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;

  for (var row = 1; row < input.length - 1; row++) {
    for (var col = 1; col < input.first.length - 1; col++) {
      int currentTree = input[row].codeUnitAt(col);
      // look up
      int visTreesUp = 0;
      for (var r = row - 1; r >= 0; r--) {
        if (input[r].codeUnitAt(col) >= currentTree) {
          visTreesUp++;
          break;
        }
        visTreesUp++;
      }
      // look down
      int visTreesDown = 0;
      for (var r = row + 1; r < input.length; r++) {
        if (input[r].codeUnitAt(col) >= currentTree) {
          visTreesDown++;
          break;
        }
        visTreesDown++;
      }
      // look left
      int visTreesLeft = 0;
      for (var c = col - 1; c >= 0; c--) {
        if (input[row].codeUnitAt(c) >= currentTree) {
          visTreesLeft++;
          break;
        }
        visTreesLeft++;
      }
      // look right
      int visTreesRight = 0;
      for (var c = col + 1; c < input.first.length; c++) {
        if (input[row].codeUnitAt(c) >= currentTree) {
          visTreesRight++;
          break;
        }
        visTreesRight++;
      }

      int scenicScore =
          visTreesUp * visTreesDown * visTreesLeft * visTreesRight;

      if (scenicScore > result) {
        // print("${Pair(row,col)} ${currentTree-zeroCodeUnit}",true);
        result = scenicScore;
      }
    }
  }

  print("Maximum scenic score: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(8, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 21)]);
  day.runPart(2, part2, [Pair("example_input.txt", 8)]);
}
