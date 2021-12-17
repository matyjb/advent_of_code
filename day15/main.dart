/*
 * https://adventofcode.com/2021/day/15
 */

import 'dart:collection';
import 'dart:io';
import 'dart:math';

import '../day.dart';

int genCostForPoint(Point<int> point, List<List<int>> graph) {
  int chunkXIndex = point.x ~/ graph.length;
  int chunkYIndex = point.y ~/ graph.first.length;
  int origCost = graph[point.x % graph.length][point.y % graph.first.length];
  if (origCost + chunkXIndex + chunkYIndex > 9)
    return (origCost + chunkXIndex + chunkYIndex) % 9;
  else
    return origCost + chunkXIndex + chunkYIndex;
}

class AstarDataRow {
  Point<int> point;
  int cost;
  late int distance;
  AstarDataRow? prevPoint;

  int get totalCost => cost + distance;

  AstarDataRow(this.point, this.cost, this.prevPoint, Point<int> end) {
    distance = (end.x - point.x) + (end.y - point.y);
  }

  @override
  String toString() {
    return "$point | $totalCost | $prevPoint";
  }

  @override
  int get hashCode => point.hashCode;
}

int astar(List<List<int>> graph, Point<int> start, Point<int> end) {
  HashSet<AstarDataRow> astarQueue = HashSet()
    ..add(AstarDataRow(start, 0, null, end));
  HashMap<Point, AstarDataRow> visited = HashMap();

  AstarDataRow currentPoint;
  int pointsDone = 0;
  int lowestH = astarQueue.first.totalCost;
  do {
    currentPoint = astarQueue.reduce(
      (value, element) =>
          value.totalCost <= element.totalCost ? value : element,
    );
    if (currentPoint.distance < lowestH) lowestH = currentPoint.distance;

    List<Point<int>> adjacentPoints = [
      currentPoint.point + Point(0, 1),
      currentPoint.point + Point(0, -1),
      currentPoint.point + Point(1, 0),
      currentPoint.point + Point(-1, 0),
    ]
        .where((p) => p.x >= 0 && p.y >= 0)
        .where((p) => p.x < end.x + 1 && p.y < end.y + 1)
        .where((p) => !visited.containsKey(p))
        .toList();

    for (var p in adjacentPoints) {
      int cost = currentPoint.cost + genCostForPoint(p, graph);
      AstarDataRow tmp =
          astarQueue.firstWhere((element) => element.point == p, orElse: () {
        AstarDataRow t = AstarDataRow(p, cost, currentPoint, end);
        astarQueue.add(t);
        return t;
      });
      if (tmp.cost > cost) {
        tmp.cost = cost;
        tmp.prevPoint = currentPoint;
      }
      astarQueue.add(tmp);
    }

    astarQueue.remove(currentPoint);
    visited.putIfAbsent(currentPoint.point, () => currentPoint);

    pointsDone++;
    stdout.write("${pointsDone}/${(end.x + 1) * (end.y + 1)} H: $lowestH\r");
  } while (currentPoint.point != end && astarQueue.length > 0);

  return currentPoint.cost;
}

List<List<int>> parse(File file) {
  return file
      .readAsLinesSync()
      .map((e) => e.split("").map((e) => int.parse(e)).toList())
      .toList();
}

void part1(List<List<int>> graph) {
  Point<int> end = Point<int>(graph.first.length - 1, graph.length - 1);
  int costToFinish = astar(graph, Point<int>(0, 0), end);
  print("Cost of getting to finish: ${answer(costToFinish)}");
}

void part2(List<List<int>> graph) {
  Point<int> end = Point<int>(graph.first.length * 5 - 1, graph.length * 5 - 1);
  int costToFinish = astar(graph, Point<int>(0, 0), end);
  print("Cost of getting to finish: ${answer(costToFinish)}");
}

void main(List<String> args) {
  Day day = Day(15, "input.txt", parse);
  day.part1(part1);
  day.part2(part2);
}
