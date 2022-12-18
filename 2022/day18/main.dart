/*
 * https://adventofcode.com/2022/day/18
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<Point3D>;

Input parse(File file) {
  RegExp point3DRegexp = RegExp(r'(-?\d+),\s?(-?\d+),\s?(-?\d+)');
  return file.readAsLinesSync().map((e) {
    var coordsMatch = point3DRegexp.allMatches(e).first;
    var coords =
        [1, 2, 3].map((i) => int.parse(coordsMatch.group(i)!)).toList();
    return Point3D(coords[0], coords[1], coords[2]);
  }).toList();
}

int part1(Input input) {
  Map<int, int> exposedSides =
      Map(); // key: index of the point, value: exposed sides (default=6)
  for (var i = 0; i < input.length - 1; i++) {
    // for each count the number of covered sides
    // if pair of points covers their sides than decrement exposedSides for both of the points
    for (var j = i + 1; j < input.length; j++) {
      int distance = input[i].manhattanDistance(input[j]);
      if (distance == 1) {
        exposedSides.update(i, (value) => value - 1, ifAbsent: () => 5);
        exposedSides.update(j, (value) => value - 1, ifAbsent: () => 5);
      } else {
        exposedSides.putIfAbsent(i, () => 6);
        exposedSides.putIfAbsent(j, () => 6);
      }
    }
  }
  int result = exposedSides.values.reduce((value, element) => value + element);

  print("Exposed sides: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;
  // find bounding box of the lava droplet
  Point3D maxCoords = input.reduce(
    (v, point) => Point3D(
      max(v.x, point.x),
      max(v.y, point.y),
      max(v.z, point.z),
    ),
  );
  maxCoords += Point3D(1, 1, 1);
  Point3D minCoords = input.reduce(
    (v, point) => Point3D(
      min(v.x, point.x),
      min(v.y, point.y),
      min(v.z, point.z),
    ),
  );
  minCoords -= Point3D(1, 1, 1);

  // flood algo around the droplet
  Set<Point3D> visitedAir = {minCoords};
  List<Point3D> queue = [minCoords];
  while (queue.isNotEmpty) {
    Point3D current = queue.removeAt(0);
    Iterable<Point3D> neighbors = [
      current + Point3D(1, 0, 0),
      current + Point3D(-1, 0, 0),
      current + Point3D(0, 1, 0),
      current + Point3D(0, -1, 0),
      current + Point3D(0, 0, 1),
      current + Point3D(0, 0, -1),
    ].where(
      // in bounds
      (element) =>
          element.x <= maxCoords.x &&
          element.y <= maxCoords.y &&
          element.z <= maxCoords.z &&
          element.x >= minCoords.x &&
          element.y >= minCoords.y &&
          element.z >= minCoords.z,
    );
    for (var n in neighbors) {
      if (input.contains(n)) {
        // its lava
        result++;
      } else {
        // its air
        if (!visitedAir.contains(n)) {
          visitedAir.add(n);
          queue.add(n);
        }
      }
    }
  }

  print("Exposed sides to water: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(18, "input.txt", parse);
  day.runPart(1, part1, [
    Pair("example_input_1.txt", 10),
    Pair("example_input_2.txt", 64),
  ]);
  day.runPart(2, part2, [
    Pair("example_input_1.txt", 10),
    Pair("example_input_2.txt", 58),
  ]);
}
