/*
 * https://adventofcode.com/2021/day/5
 */

import 'dart:io';
import 'dart:math';
import '../day.dart';

class Line {
  final int x1, y1, x2, y2;

  Line(this.x1, this.y1, this.x2, this.y2);

  factory Line.fromLine(String line) {
    List<int> coords = line
        .replaceAll(" -> ", ",")
        .split(",")
        .map((e) => int.parse(e))
        .toList();
    return Line(
      coords[0],
      coords[1],
      coords[2],
      coords[3],
    );
  }

  bool isHorizontal() => y1 == y2;
  bool isVertical() => x1 == x2;

  Iterable<Point<int>> get subPoints sync* {
    if (isHorizontal()) {
      for (var i = 0; i <= (x1 - x2).abs(); i++) {
        int deltaX = x1 < x2 ? i : -i;
        yield Point(x1 + deltaX, y1);
      }
    } else if (isVertical()) {
      for (var i = 0; i <= (y1 - y2).abs(); i++) {
        int deltaY = y1 < y2 ? i : -i;
        yield Point(x1, y1 + deltaY);
      }
    } else {
      // diagonal
      for (var i = 0; i <= (x1 - x2).abs(); i++) {
        int deltaX = x1 < x2 ? i : -i;
        int deltaY = y1 < y2 ? i : -i;
        yield Point(x1 + deltaX, y1 + deltaY);
      }
    }
  }
}

List<Line> parse(File file) {
  return file.readAsLinesSync().map((e) => Line.fromLine(e)).toList();
}

void part1(List<Line> lines) {
  // only horizontal or vertical
  List<Line> linesHorOrVer = lines
      .where((element) => element.isHorizontal() || element.isVertical())
      .toList();

  print("Eligible lines for part 1: ${linesHorOrVer.length}");
  Map<Point<int>, int> crossCounters = Map<Point<int>, int>();
  for (var line in linesHorOrVer) {
    for (var point in line.subPoints) {
      crossCounters.update(point, (value) => value + 1, ifAbsent: () => 1);
    }
  }
  print("Unique points: ${crossCounters.entries.length}");
  print(
    "Unique cross points with value >= 2: ${answer(crossCounters.entries.where((element) => element.value >= 2).length)}",
  );
}

void part2(List<Line> lines) {
  print("Eligible lines for part 2: ${lines.length}");
  Map<Point<int>, int> crossCounters = Map<Point<int>, int>();
  for (var line in lines) {
    for (var point in line.subPoints) {
      crossCounters.update(point, (value) => value + 1, ifAbsent: () => 1);
    }
  }
  print("Unique points: ${crossCounters.entries.length}");
  print(
    "Unique cross points with value >= 2: ${answer(crossCounters.entries.where((element) => element.value >= 2).length)}",
  );
}

void main(List<String> args) {
  Day day = Day(5, "input.txt", parse);
  day.runPart<List<Line>>(1, part1);
  day.runPart<List<Line>>(2, part2);
}
