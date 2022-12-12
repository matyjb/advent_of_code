/*
 * https://adventofcode.com/2022/day/12
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<String>;

Input parse(File file) {
  return file.readAsLinesSync().toList();
}

Pair<Point2D, Point2D> findStartAndFinish(Input map) {
  Point2D s = Point2D(0, 0);
  Point2D e = Point2D(map.length - 1, map.first.length - 1);
  for (var row = 0; row < map.length; row++) {
    int startIndex = map[row].indexOf("S");
    int endIndex = map[row].indexOf("E");
    if (startIndex != -1) s = Point2D(row, startIndex);
    if (endIndex != -1) e = Point2D(row, endIndex);
  }
  return Pair(s, e);
}

// returns map of distances from start to any other point
Map<Point2D, int> djikstra(
  Input map,
  Point2D start,
  bool Function(Point2D nextPoint, Point2D current) stepIf,
) {
  Map<Point2D, int> distanceToS = {start: 0};
  List<Point2D> queue = [start];
  while (queue.isNotEmpty) {
    Point2D current = queue.reduce((value, element) =>
        distanceToS[value]! < distanceToS[element]! ? value : element);
    queue.remove(current);
    Iterable<Point2D> possiblePaths = [
      current + Point2D(0, 1),
      current + Point2D(0, -1),
      current + Point2D(1, 0),
      current + Point2D(-1, 0),
    ]
        .where(
          // in bounds of map
          (p) =>
              p.v0 >= 0 &&
              p.v0 < map.length &&
              p.v1 >= 0 &&
              p.v1 < map.first.length,
        )
        .where((p) => stepIf(p, current));
    
    for (var ppath in possiblePaths) {
      int newDistance = distanceToS[current]! + 1;
      if (distanceToS[ppath] == null || distanceToS[ppath]! > newDistance) {
        queue.add(ppath);
      }
      distanceToS.update(
        ppath,
        (value) => min(value, newDistance),
        ifAbsent: () => newDistance,
      );
    }
  }
  return distanceToS;
}

int part1(Input input) {
  Pair<Point2D, Point2D> startAndFinish = findStartAndFinish(input);
  // replace start and finish marks with S -> a; E -> z
  input[startAndFinish.v0.v0] =
      input[startAndFinish.v0.v0].replaceAll("S", "a");
  input[startAndFinish.v1.v0] =
      input[startAndFinish.v1.v0].replaceAll("E", "z");

  int result = djikstra(
    input,
    startAndFinish.v0,
    (p, c) => input[p.v0].codeUnitAt(p.v1) <= input[c.v0].codeUnitAt(c.v1) + 1,
  )[startAndFinish.v1]!;
  print("Amount of least steps to reach E: ${answer(result)}");
  return result;
}

int part2(Input input) {
  Pair<Point2D, Point2D> startAndFinish = findStartAndFinish(input);
  // replace start and finish marks with S -> a; E -> z
  input[startAndFinish.v0.v0] =
      input[startAndFinish.v0.v0].replaceAll("S", "a");
  input[startAndFinish.v1.v0] =
      input[startAndFinish.v1.v0].replaceAll("E", "z");

  Point2D end = startAndFinish.v1;
  // find distances from end to any other point
  var distances = djikstra(
    input,
    end,
    (p, c) => input[c.v0].codeUnitAt(c.v1) <= input[p.v0].codeUnitAt(p.v1) + 1,
  );
  // get only points with "a" height
  distances.removeWhere(
      (key, value) => input[key.v0].codeUnitAt(key.v1) != "a".codeUnitAt(0));
  // find minimal distance
  int result = distances.values.reduce((value, element) => min(value, element));

  print("Least steps from any lowest point: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(12, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 31)]);
  day.runPart(2, part2, [Pair("example_input.txt", 29)]);
}
