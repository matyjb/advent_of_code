/*
 * https://adventofcode.com/2022/day/14
 */

import 'dart:collection';
import 'dart:io';
import 'dart:math';
import '../../day.dart';

class Cave {
  final List<List<bool>> _rocks;
  final Point2D topLeft;
  final Point2D bottomRight;
  Cave(this._rocks, this.topLeft, this.bottomRight);
  operator [](Point2D coords) {
    Point2D c = coords - topLeft;
    return _rocks[c.v0][c.v1];
  }

  bool inBounds(Point2D p) {
    return p.v1 >= topLeft.v1 &&
        p.v0 >= topLeft.v0 &&
        p.v1 <= bottomRight.v1 &&
        p.v0 <= bottomRight.v0;
  }

  @override
  String toString() {
    return _rocks.map((e) => e.map((v) => v ? "#" : ".").join()).join("\n");
  }
}

Cave parse(File file) {
  List<List<Point2D>> pointsInRow = [];
  int maxX = 0, minX = 99999999;
  int maxY = 0, minY = 99999999;
  for (var line in file.readAsLinesSync()) {
    pointsInRow.add([]);
    for (var p in line
        .split(" -> ")
        .map((e) => e.split(","))
        .map((e) => e.map(int.parse))) {
      Point2D p2d = Point2D(p.first, p.last);
      maxX = max(p2d.v0, maxX);
      maxY = max(p2d.v1, maxY);
      minX = min(p2d.v0, minX);
      minY = min(p2d.v1, minY);
      pointsInRow.last.add(p2d);
    }
  }
  List<List<bool>> rocks = List.generate(
    maxY - minY + 1,
    (i) => List.generate(maxX - minX + 1, (i) => false),
  );

  for (var struct in pointsInRow) {
    while (struct.length > 1) {
      Point2D start = struct.first;
      Point2D end = struct[1];
      int l =
          (start.v0 == end.v0 ? start.v1 - end.v1 : start.v0 - end.v0).abs();
      Point2D dir = (end - start) ~/ l;

      for (Point2D i = start; i != end; i += dir) {
        rocks[i.v1 - minY][i.v0 - minX] = true;
      }
      rocks[end.v1 - minY][end.v0 - minX] = true;
      struct.removeAt(0);
    }
  }

  return Cave(rocks, Point2D(minY, minX), Point2D(maxY, maxX));
}

Iterable<Point2D> genNextPoints(Point2D p) sync* {
  yield p + Point2D(1, 0);
  yield p + Point2D(1, -1);
  yield p + Point2D(1, 1);
}

int part1(Cave input) {
  List<Point2D> path = [Point2D(0, 500)];
  HashSet grainsSettled = HashSet();

  while (!grainsSettled.contains(path.first)) {
    Point2D? next;
    try {
      next = genNextPoints(path.last).firstWhere(
        (p) =>
            !grainsSettled.contains(p) &&
            // not a wall
            (!input.inBounds(p) || !input[p]),
      );
    } catch (e) {}
    if (next != null) {
      // if next in void -> break;
      if (next.v1 < input.topLeft.v1 ||
          next.v1 > input.bottomRight.v1 ||
          next.v0 > input.bottomRight.v0) {
        break;
      }
      // next is in ok spot -> go there
      path.add(next);
    } else {
      // cant go anywhere = grain settled
      grainsSettled.add(path.removeLast());
    }
  }

  int result = grainsSettled.length;
  print("Grains settled: ${answer(result)}");
  return result;
}

int part2(Cave input) {
  List<Point2D> path = [Point2D(0, 500)];
  HashSet grainsSettled = HashSet();
  int height = input.bottomRight.v0 + 2;
  int voidyLeftHeight = height, voidyRightHeight = height;

  while (path.length != 0) {
    Point2D? next;
    try {
      next = genNextPoints(path.last).firstWhere(
        (p) =>
            !grainsSettled.contains(p) &&
            // not a wall
            (!input.inBounds(p) || !input[p]) &&
            // not a floor
            height > p.v0,
      );
    } catch (e) {}
    if (next != null) {
      // if next in left void -> continue;
      // those will be counted later
      if (next.v1 < input.topLeft.v1 - 1) {
        voidyLeftHeight = min(voidyLeftHeight, next.v0);
        grainsSettled.add(next);
        continue;
      }
      // if next in right void -> continue
      // those will be counted later
      if (next.v1 > input.bottomRight.v1 + 1) {
        voidyRightHeight = min(voidyRightHeight, next.v0);
        grainsSettled.add(next);
        continue;
      }
      path.add(next);
    } else {
      // cant go anywhere = grain settled
      grainsSettled.add(path.removeLast());
    }
  }

  int f(int n) => (pow(n, 2) + n) ~/ 2;
  int leftGrainsTriangleH = height - voidyLeftHeight - 1;
  int rightGrainsTriangleH = height - voidyRightHeight - 1;
  int voidyGrains = f(leftGrainsTriangleH) + f(rightGrainsTriangleH);

  int result = grainsSettled.length + voidyGrains;
  print("Grains settled: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(14, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 24)]);
  day.runPart(2, part2, [Pair("example_input.txt", 93)]);
}
