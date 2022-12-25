/*
 * https://adventofcode.com/2022/day/24
 */
import 'dart:io';
import 'dart:math';
import '../../day.dart';

enum Direction { up, down, left, right }

class Blizzard {
  Point2D position;
  final Direction direction;

  Blizzard(this.position, this.direction);

  void move(int maxX, int maxY) {
    switch (direction) {
      case Direction.up:
        position = Point2D(position.v0, (position.v1 - 1) % maxY);
        break;
      case Direction.down:
        position = Point2D(position.v0, (position.v1 + 1) % maxY);
        break;
      case Direction.left:
        position = Point2D((position.v0 - 1) % maxX, position.v1);
        break;
      case Direction.right:
        position = Point2D((position.v0 + 1) % maxX, position.v1);
        break;
      default:
    }
  }
}

class Cave {
  final List<Blizzard> blizzards;
  final int maxX, maxY;

  Cave(this.blizzards, this.maxX, this.maxY);

  void simulationStep() {
    for (var blizzard in blizzards) {
      blizzard.move(maxX, maxY);
    }
  }

  List<Point2D> get emptySpots {
    List<Point2D> result = [];
    for (var x = 0; x < maxX; x++) {
      for (var y = 0; y < maxY; y++) {
        Point2D point2d = Point2D(x, y);
        if (!blizzards.any((element) => element.position == point2d)) {
          result.add(point2d);
        }
      }
    }
    return result;
  }
}

Cave parse(File file) {
  List<String> lines = file.readAsLinesSync();
  int maxX = lines.first.length - 2, maxY = lines.length - 2;
  List<Blizzard> blizzards = [];
  for (var row = 1; row < lines.length - 1; row++) {
    for (var col = 1; col < lines[row].length - 1; col++) {
      Point2D position = Point2D(col - 1, row - 1);
      switch (lines[row][col]) {
        case "^":
          blizzards.add(Blizzard(position, Direction.up));
          break;
        case "v":
          blizzards.add(Blizzard(position, Direction.down));
          break;
        case ">":
          blizzards.add(Blizzard(position, Direction.right));
          break;
        case "<":
          blizzards.add(Blizzard(position, Direction.left));
          break;
        default:
      }
    }
  }

  return Cave(blizzards, maxX, maxY);
}

// returns map of distances from start to any other point
Map<Point3D, int> djikstra(
  List<List<Point2D>> mapInTime,
  Point3D start,
  Point2D end,
) {
  Map<Point3D, int> distanceToS = {start: 0};
  List<Point3D> queue = [start];
  int currentMinStepsToFinish = 1000;
  while (queue.isNotEmpty) {
    Point3D current = queue.removeAt(0);

    List<Point3D> possiblePaths = [
      current + Point3D(0, 1, 1),
      current + Point3D(0, -1, 1),
      current + Point3D(1, 0, 1),
      current + Point3D(-1, 0, 1),
      current + Point3D(0, 0, 1)
    ]
        .where(
          (path) =>
              path.z < currentMinStepsToFinish &&
              mapInTime[(path.z) % mapInTime.length]
                  .any((e) => path.x == e.v0 && path.y == e.v1),
        )
        .toList();

    // some pruning
    if (possiblePaths.length > 0 &&
        possiblePaths.any((e) => e.x == end.v0 && e.y == end.v1)) {
      currentMinStepsToFinish =
          min(currentMinStepsToFinish, possiblePaths.first.z);
    }

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

int goto(List<List<Point2D>> emptySpotsInTime, Point2D startPoint,
    Point2D endPoint, int timeOffset) {
  var distances = djikstra(emptySpotsInTime,
      Point3D(startPoint.v0, startPoint.v1, timeOffset), endPoint);

  var distnacesToFinish = distances.entries
      .where(
        (element) =>
            element.key.x == endPoint.v0 && element.key.y == endPoint.v1,
      )
      .toList();
  return distnacesToFinish.fold(
      distnacesToFinish.first.value, (a, b) => min(a, b.value));
}

List<List<Point2D>> calcEmptySpotsInTime(
    Cave cave, Point2D start, Point2D end) {
  // z każdym krokiem wykonać symulacje i zrobić listę punktów pustych w każdej minucie
  List<List<Point2D>> emptySpotsInTime = [cave.emptySpots..add(end)];
  // ilość kroków można ograniczyć do Najmniejszej wspólnej wielokrotności dla dimXLen, dimYLen
  // (bo stany się zapętlają)
  int maxPrecalculatedSteps = lcm(cave.maxX, cave.maxY);
  for (var i = 1; i < maxPrecalculatedSteps; i++) {
    cave.simulationStep();
    emptySpotsInTime.add(cave.emptySpots
      ..add(end)
      ..add(start));
  }
  return emptySpotsInTime;
}

int part1(Cave input) {
  Point2D end = Point2D(input.maxX - 1, input.maxY);
  Point2D start = Point2D(-1, 0);
  List<List<Point2D>> emptySpotsInTime =
      calcEmptySpotsInTime(input, start, end);
  int minutes = goto(emptySpotsInTime, start, end, 0);
  print("Going to the goal: ${answer(minutes)} minutes");
  return minutes;
}

int part2(Cave input) {
  Point2D end = Point2D(input.maxX - 1, input.maxY);
  Point2D start = Point2D(-1, 0);
  List<List<Point2D>> emptySpotsInTime =
      calcEmptySpotsInTime(input, start, end);

  int minutes = 0;
  // ## TO THE GOAL
  minutes += goto(emptySpotsInTime, start, end, 0);
  // ## TO THE START
  minutes += goto(emptySpotsInTime, end, start, minutes);
  // ## BACK TO THE GOAL
  minutes += goto(emptySpotsInTime, start, end, minutes);

  print(
      "Going to the goal, then back, then to the goal: ${answer(minutes)} minutes");
  return minutes;
}

void main(List<String> args) {
  Day day = Day(24, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 18)]);
  day.runPart(2, part2, [Pair("example_input.txt", 54)]);
}
