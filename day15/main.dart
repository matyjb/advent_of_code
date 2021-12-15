/*
 * https://adventofcode.com/2021/day/15
 */

import 'dart:io';

import 'dart:math';

class DjikstraDataRow {
  Point<int> point;
  int cost;
  Point<int>? prevPoint;

  DjikstraDataRow(this.point, this.cost, this.prevPoint);

  @override
  String toString() {
    return "$point | $cost | $prevPoint";
  }
}

int genCostForPoint(Point<int> point, List<List<int>> graph) {
  int chunkXIndex = point.x ~/ graph.length;
  int chunkYIndex = point.y ~/ graph.first.length;
  if(graph[point.x][point.y] + chunkXIndex + chunkYIndex > 9)
    return (graph[point.x][point.y] + chunkXIndex + chunkYIndex) % 9;
  else
    return graph[point.x][point.y] + chunkXIndex + chunkYIndex;
}

List<DjikstraDataRow> djikstra(List<List<int>> graph, Point<int> start) {
  List<Point<int>> visited = [];
  List<DjikstraDataRow> result = [DjikstraDataRow(start, 0, null)];

  Point<int> currentPoint = start;
  while (visited.length != graph.length * graph.first.length) {
    stdout.write("${visited.length}/${graph.length * graph.first.length}\r");
    // set current to smallest from result
    currentPoint = result
        .where((p) => !visited.contains(p.point))
        .reduce(
          (value, element) => value.cost <= element.cost ? value : element,
        )
        .point;

    List<Point<int>> adjacentUnvisitedPoints = [
      currentPoint + Point(0, 1),
      currentPoint + Point(0, -1),
      currentPoint + Point(1, 0),
      currentPoint + Point(-1, 0),
    ]
        .where((p) => p.x >= 0 && p.y >= 0)
        .where((p) => p.x < graph.first.length && p.y < graph.length)
        .where((p) => !visited.contains(p))
        .toList();

    for (var p in adjacentUnvisitedPoints) {
      int cost = genCostForPoint(p, graph) +
          result.firstWhere((element) => element.point == currentPoint).cost;
      // update costs in result
      DjikstraDataRow ddr = result.firstWhere(
        (element) => element.point == p,
        orElse: () {
          result.add(DjikstraDataRow(p, cost, currentPoint));
          return result.last;
        },
      );
      if (ddr.cost > cost) {
        ddr.cost = cost;
        ddr.prevPoint = currentPoint;
      }
    }
    visited.add(currentPoint);
  }
  return result;
}

void main(List<String> args) {
  // List<List<int>> graph = File("smallExample.txt")
  List<List<int>> graph = File("input.txt")
      .readAsLinesSync()
      .map((e) => e.split("").map((e) => int.parse(e)).toList())
      .toList();

  print("\x1B[32m## Part 1 ##\x1B[0m");
  // djikstra
  // djikstra(graph, Point(0, 0)).forEach((element) => print(element));
  Stopwatch sw = Stopwatch()..start();
  Point<int> end = Point<int>(graph.first.length - 1, graph.length - 1);
  int costToFinish = djikstra(graph, Point<int>(0, 0))
      .firstWhere((element) => element.point == end)
      .cost;
  sw.stop();
  print("");
  print("Got \x1B[33m${costToFinish}\x1B[0m");
  print("⏱ \x1B[33m${sw.elapsedMilliseconds}\x1B[0m ms");

  print("\x1B[32m## Part 2 ##\x1B[0m");
}
