/*
 * https://adventofcode.com/2022/day/15
 */

import 'dart:collection';
import 'dart:io';
import 'dart:math';
import '../../day.dart';

// pair of sensor and beacon
typedef Input = List<Pair<Point2D, Point2D>>;
final digitsRegex = RegExp(r'-?\d+');

Input parse(File file) {
  return file.readAsLinesSync().map((e) {
    List<int> numbers =
        digitsRegex.allMatches(e).map((e) => int.parse(e.group(0)!)).toList();
    return Pair(
        Point2D(numbers[0], numbers[1]), Point2D(numbers[2], numbers[3]));
  }).toList();
}

int part1(Input input) {
  int row = 2000000;
  // int row = 10;
  // HashSet<Point2D> cannotContainInRow = HashSet();
  List<Pair<Point2D, Point2D>> lines = [];
  HashSet<Point2D> beaconsInRow = HashSet();

  for (var sensorBeacon in input) {
    int signalRadius = sensorBeacon.v0.manhattanDistance(sensorBeacon.v1);
    int distToRow = (sensorBeacon.v0.v1 - row).abs();
    Point2D signalRowCrossCenter = Point2D(sensorBeacon.v0.v0, row);

    if (signalRadius >= distToRow)
      lines.add(Pair(
          signalRowCrossCenter - Point2D(signalRadius - distToRow, 0),
          signalRowCrossCenter + Point2D(signalRadius - distToRow, 0)));

    if (sensorBeacon.v1.v1 == row) beaconsInRow.add(sensorBeacon.v1);
  }

  // sort by start x
  lines.sort((a, b) => a.v0.v0.compareTo(b.v0.v0));
  Pair<Point2D, Point2D>? current = lines.removeAt(0);
  int result = 0;
  while (current != null) {
    result += current.v1.v0 - current.v0.v0 + 1;
    lines.removeWhere((l) => l.v1.v0 < current!.v1.v0);
    try {
      Pair<Point2D, Point2D> next = lines.firstWhere(
          (l) => l.v0.v0 > current!.v1.v0 || l.v1.v0 > current.v1.v0);
      current = Pair(
          Point2D(max(next.v0.v0, current.v1.v0 + 1), next.v0.v1), next.v1);
    } catch (e) {
      current = null;
    }
  }
  result -= beaconsInRow.length;

  print("Impossible positions for beacons in row $row: ${answer(result)}");
  return result;
}

List<Pair<Point2D, Point2D>> getPerimeterLines(Point2D sensor, int radius) {
  List<Point2D> points = [
    sensor + Point2D(radius, 0),
    sensor + Point2D(0, radius),
    sensor + Point2D(-radius, 0),
    sensor + Point2D(0, -radius),
  ];
  return [
    Pair(points[0], points[1]),
    Pair(points[1], points[2]),
    Pair(points[2], points[3]),
    Pair(points[3], points[0]),
  ];
}

Point2D? crossPoint(
    Pair<Point2D, Point2D> line1, Pair<Point2D, Point2D> line2) {
  Point2D xdiff = Point2D(line1.v0.v0 - line1.v1.v0, line2.v0.v0 - line2.v1.v0);
  Point2D ydiff = Point2D(line1.v0.v1 - line1.v1.v1, line2.v0.v1 - line2.v1.v1);

  int det(Point2D a, Point2D b) {
    return a.v0 * b.v1 - a.v1 * b.v0;
  }

  int div = det(xdiff, ydiff);
  if (div == 0) {
    return null;
  }

  Point2D d = Point2D(det(line1.v0, line1.v1), det(line2.v0, line2.v1));
  double x = det(d, xdiff) / div;
  double y = det(d, ydiff) / div;
  if (x - x.truncate() > 0.2 || y - y.truncate() > 0.2) {
    return null;
  } else {
    Point2D cand = Point2D(x.round(), y.round());
    int line1Len = line1.v0.planckLength(line1.v1);
    int line2Len = line2.v0.planckLength(line2.v1);
    if (cand.planckLength(line1.v0) <= line1Len &&
        cand.planckLength(line1.v1) <= line1Len &&
        cand.planckLength(line2.v0) <= line2Len &&
        cand.planckLength(line2.v1) <= line2Len) {
      return cand;
    } else {
      return null;
    }
  }
}

int part2(Input input) {
  var p = crossPoint(Pair(Point2D(-1, -1), Point2D(1, 1)),
      Pair(Point2D(-1, 1), Point2D(1, -1)));
  print(p);
  p = crossPoint(Pair(Point2D(-1, -1), Point2D(1, 1)),
      Pair(Point2D(1, -1), Point2D(4, -4)));
  print(p);
  p = crossPoint(Pair(Point2D(-1, -1), Point2D(1, 1)),
      Pair(Point2D(-1, -1), Point2D(1, 1)));
  print(p);
  p = crossPoint(
      Pair(Point2D(-1, -1), Point2D(1, 1)), Pair(Point2D(1, 0), Point2D(3, 2)));
  print(p);

  int maxRowCol = 4000000;
  // int maxRowCol = 20;
  int result = 0;

  List<List<Pair<Point2D, Point2D>>> sensorsLines = input
      .map((e) => getPerimeterLines(e.v0, e.v0.manhattanDistance(e.v1)))
      .toList();

  // TODO: find 4 lines that intersect in one point 
  

  print("Tuning frequency of the beacon: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(15, "input.txt", parse);
  day.runPart(1, part1, [
    // Pair("example_input.txt", 26),
  ]);
  day.runPart(2, part2, [
    // Pair("example_input.txt", 56000011),
  ]);
}
