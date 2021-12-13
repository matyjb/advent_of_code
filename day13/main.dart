/*
 * https://adventofcode.com/2021/day/13
 */

import 'dart:io';
import 'dart:math';

class FoldIns {
  final String axis;
  final int value;
  FoldIns(this.axis, this.value);
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

void main(List<String> args) {
  List<String> lines = File("input.txt").readAsLinesSync();
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

  print("\x1B[32m## Part 1 ##\x1B[0m");
  Set<Point<int>> pointsAfterFolding = Set.from(points);
  for (var fold in folds) {
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
    if (fold == folds.first) {
      int dotsAmount = pointsAfterFolding.length;
      print("Found \x1B[33m$dotsAmount\x1B[0m dots after first fold.");
    }
  }

  print("\x1B[32m## Part 2 ##\x1B[0m");
  printCode(pointsAfterFolding);
}
