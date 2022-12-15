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

int part2(Input input) {
  int maxRowCol = 4000000;
  // int maxRowCol = 20;
  int result = 0;

  for (var i = 0; i <= maxRowCol; i++) {
    int row = i;
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
    while (current != null) {
      lines.removeWhere((l) => l.v1.v0 < current!.v1.v0);
      try {
        Pair<Point2D, Point2D> next = lines.firstWhere(
            (l) => l.v0.v0 > current!.v1.v0 || l.v1.v0 > current.v1.v0);
        next = Pair(
            Point2D(max(next.v0.v0, current.v1.v0 + 1), next.v0.v1), next.v1);
        if (next.v0.v0 - current.v1.v0 == 2) {
          // the only position in this line is possible
          // this is the one
          result = (next.v0.v0 - 1) * 4000000 + next.v0.v1;
          i = maxRowCol + 1; // to break main loop
          break; // to break while loop
        } else if (next.v0.v0 - current.v1.v0 > 3) {
          // we can skip lines
          i += (next.v0.v0 - current.v1.v0) ~/ 2 - 1;
          break;
        }
        current = next;
      } catch (e) {
        current = null;
      }
    }
  }

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
