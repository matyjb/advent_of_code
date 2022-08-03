/*
 * https://adventofcode.com/2021/day/12
 */

import 'dart:io';
import '../../day.dart';

typedef Graph = Map<String, List<String>>;

bool isBigCave(String s) => s.toUpperCase() == s && s != "start" && s != "end";
Iterable<List<String>> dfsFindAllPathsPart1(
  Graph graph,
  List<String> currentPathStack, [
  String start = "start",
  String end = "end",
]) sync* {
  if (start == end) {
    yield currentPathStack + [start];
  } else {
    currentPathStack.add(start);
    List<String> possibleNextCaves = graph[start]!
        .where((element) =>
            isBigCave(element) || !currentPathStack.contains(element))
        .toList();

    for (var nextCave in possibleNextCaves) {
      for (var path
          in dfsFindAllPathsPart1(graph, currentPathStack, nextCave)) {
        yield path;
      }
    }

    currentPathStack.removeLast();
  }
}

Iterable<List<String>> dfsFindAllPathsPart2(
  Graph graph,
  List<String> currentPathStack, [
  bool hasDuplicateInPathStack = false,
  String start = "start",
  String end = "end",
]) sync* {
  if (start == end) {
    yield currentPathStack + [start];
  } else {
    currentPathStack.add(start);
    List<String> possibleNextCaves;

    if (hasDuplicateInPathStack)
      possibleNextCaves = graph[start]!
          .where(
            (element) =>
                isBigCave(element) || !currentPathStack.contains(element),
          )
          .toList();
    else
      possibleNextCaves = graph[start]!
          .where(
            (element) => element != "start",
          )
          .toList();

    for (var nextCave in possibleNextCaves) {
      bool hasDup =
          currentPathStack.contains(nextCave) && !isBigCave(nextCave) ||
              hasDuplicateInPathStack;
      var paths = dfsFindAllPathsPart2(
        graph,
        currentPathStack,
        hasDup,
        nextCave,
      );
      for (var path in paths) {
        yield path;
      }
    }

    currentPathStack.removeLast();
  }
}

void printGraph(Graph graph) {
  int keysMaxWidth = graph.keys.fold(
      0, (value, element) => element.length > value ? element.length : value);
  graph.forEach((key, value) =>
      print("\x1B[32m${key.padLeft(keysMaxWidth)}\x1B[0m => $value"));
}

Graph parse(File file) {
  List<String> connections = File("input.txt").readAsLinesSync();
  Graph graph = {};
  for (var connection in connections) {
    List<String> tmp = connection.split("-");
    graph.update(tmp[0], (value) => value..add(tmp[1]),
        ifAbsent: () => [tmp[1]]);
    graph.update(tmp[1], (value) => value..add(tmp[0]),
        ifAbsent: () => [tmp[0]]);
  }
  return graph;
}

void part1(Graph graph) {
  // printGraph(graph);
  int pathsCount = dfsFindAllPathsPart1(graph, [])
      .fold<int>(0, (count, element) => count + 1);
  print("Found ${answer(pathsCount)} possible paths.");
}

void part2(Graph graph) {
  // printGraph(graph);
  int pathsCount2 = dfsFindAllPathsPart2(graph, [])
      .fold<int>(0, (count, element) => count + 1);
  print("Found ${answer(pathsCount2)} possible paths.");
}

void main(List<String> args) {
  Day day = Day(12, "input.txt", parse);
  day.runPart<Graph>(1, part1);
  day.runPart<Graph>(2, part2);
}
