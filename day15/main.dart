/*
 * https://adventofcode.com/2021/day/15
 */

import 'dart:collection';
import 'dart:io';
import 'dart:math';

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

void main(List<String> args) {
  // List<List<int>> graph = File("smallExample.txt")
  List<List<int>> graph = File("input.txt")
      .readAsLinesSync()
      .map((e) => e.split("").map((e) => int.parse(e)).toList())
      .toList();

  print("\x1B[32m## Part 1 ##\x1B[0m");
  Stopwatch sw = Stopwatch()..start();
  Point<int> end = Point<int>(graph.first.length - 1, graph.length - 1);
  int costToFinish = astar(graph, Point<int>(0, 0), end);
  sw.stop();
  print("Cost of getting to finish: \x1B[33m${costToFinish}\x1B[0m");
  print("⏱ \x1B[36m${sw.elapsedMilliseconds}\x1B[0m ms");

  print("\x1B[32m## Part 2 ##\x1B[0m");
  sw.reset(); sw.start();
  Point<int> end2 = Point<int>(graph.first.length * 5 - 1, graph.length * 5 - 1);
  int costToFinish2 = astar(graph, Point<int>(0, 0), end2);
  sw.stop();
  print("Cost of getting to finish: \x1B[33m${costToFinish2}\x1B[0m");
  print("⏱ \x1B[36m${sw.elapsedMilliseconds}\x1B[0m ms");
}
