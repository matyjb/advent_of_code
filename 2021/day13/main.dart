/*
 * https://adventofcode.com/2021/day/13
 */

import 'dart:io';
import 'dart:math';

import '../../day.dart';

class FoldIns {
  final String axis;
  final int value;
  FoldIns(this.axis, this.value);
}

class Input {
  final Set<Point<int>> points;
  final List<FoldIns> folds;

  Input(this.points, this.folds);

  @override
  String toString() {
    return "${points.length} points, ${folds.length} folds.";
  }
}

void printCode(Set<Point<int>> points) {
  int maxX = 0;
  int maxY = 0;
  for (var p in points) {
    maxX = p.x > maxX ? p.x : maxX;
    maxY = p.y > maxY ? p.y : maxY;
  }

  // printing
  stdout.write("\x1B[33m"); // make output yellow
  for (var j = 0; j <= maxY; j++) {
    for (var i = 0; i <= maxX; i++) {
      if (points.contains(Point(i, j))) {
        // filled rectangle character
        stdout.write(String.fromCharCode(0x2588));
      } else {
        stdout.write(" ");
      }
    }
    stdout.write("\n");
  }
  stdout.write("\x1B[0m"); // stop with the yellow
}

Input parse(File file) {
  List<String> lines = file.readAsLinesSync();
  RegExp pointRegex = RegExp(r'^\d+,\d+');
  RegExp foldRegex = RegExp(r'fold along [xy]=');
  Set<Point<int>> points = lines.where((l) => pointRegex.hasMatch(l)).map((e) {
    var coords = e.split(",");
    return Point(int.parse(coords[0]), int.parse(coords[1]));
  }).toSet();
  List<FoldIns> folds = lines.where((l) => foldRegex.hasMatch(l)).map((e) {
    var tmp = e.replaceFirst("fold along ", "").split("=");
    return FoldIns(tmp[0], int.parse(tmp[1]));
  }).toList();

  return Input(points, folds);
}

Iterable<Set<Point<int>>> performFolding(Input input) sync* {
  Set<Point<int>> pointsAfterFolding = Set.from(input.points);
  for (var fold in input.folds) {
    Set<Point<int>> tmp = {};
    for (var p in pointsAfterFolding) {
      switch (fold.axis) {
        case "x":
          if (p.x > fold.value) {
            tmp.add(Point(p.x - (p.x - fold.value) * 2, p.y));
          } else if (p.x < fold.value) {
            tmp.add(p);
          }
          break;
        case "y":
          if (p.y > fold.value) {
            tmp.add(Point(p.x, p.y - (p.y - fold.value) * 2));
          } else if (p.y < fold.value) {
            tmp.add(p);
          }
          break;
        default:
      }
    }
    pointsAfterFolding = tmp;
    yield pointsAfterFolding;
  }
}

void part1(Input input) {
  int dotsAmount = performFolding(input).first.length;
  print("Found ${answer(dotsAmount)}\x1B[0m dots after first fold."); 
}

void part2(Input input) {
  printCode(performFolding(input).last);
}

void main(List<String> args) {
  Day day = Day(13, "input.txt", parse);
  day.runPart<Input>(1, part1);
  day.runPart<Input>(2, part2);
}
