/*
 * https://adventofcode.com/2022/day/16
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

// 1st map = key: valve label, value: flow rate
// 2nd map = key: valve label, value: list of next valves
typedef Input = Pair<Map<String, int>, Map<String, List<String>>>;

Input parse(File file) {
  Map<String, int> flowRates = {};
  Map<String, List<String>> nextValves = {};
  // lets learn regexp groups this time
  // https://medium.com/flutter-community/extracting-text-from-a-string-with-regex-groups-in-dart-b6be604c8a69
  RegExp r = RegExp(
      r'Valve (.+) has flow rate\=(\d+); tunnels? leads? to valves? (.+)');
  for (var line in file.readAsLinesSync()) {
    var match = r.allMatches(line).first;
    String label = match.group(1).toString();
    int flowRate = int.parse(match.group(2).toString());
    List<String> nextValvesTmp =
        match.group(3)!.split(",").map((e) => e.trim()).toList();
    flowRates.addAll({label: flowRate});
    nextValves.addAll({label: nextValvesTmp});
  }
  return Pair(flowRates, nextValves);
}

// returns released presure from current valve + from traversed path later
int traverseTunnelsBFSPart1(Map<String, Map<String, int>> valvesMap,
    Map<String, int> flowRates, String current,
    [int? minutesLeft, Set<String>? openedValves]) {
  minutesLeft ??= 30;
  openedValves ??= Set.from([current]);
  if (minutesLeft < 0) {
    return 0;
  }

  int flowRate = flowRates[current]!;
  minutesLeft -= flowRate == 0 ? 0 : 1;

  int maxFlowRate = 0;
  List<MapEntry<String, int>> nextClosedValves = valvesMap[current]!
      .entries
      .where((valve) => !openedValves!.contains(valve.key))
      .toList();

  Set<String> visitedCopy = Set.from(openedValves)..add(current);
  for (var nextClosedValve in nextClosedValves) {
    int possibleFlowRate = traverseTunnelsBFSPart1(
      valvesMap,
      flowRates,
      nextClosedValve.key,
      minutesLeft - nextClosedValve.value,
      visitedCopy,
    );
    maxFlowRate = max(maxFlowRate, possibleFlowRate);
  }

  return minutesLeft * flowRate + maxFlowRate;
}

Map<String, int> djikstra(Input g, String start, [int maxCost = 30]) {
  Map<String, int> distances = {start: 0};
  List<String> queue = [start];

  while (queue.isNotEmpty) {
    String current = queue.removeAt(0);
    for (var nextValve in g.v1[current]!) {
      int nextCost = distances[current]! + 1;
      if (nextCost <= maxCost &&
          (distances[nextValve] == null || distances[nextValve]! > nextCost)) {
        distances.update(
          nextValve,
          (value) => nextCost,
          ifAbsent: () => nextCost,
        );
        queue.add(nextValve);
      }
    }
  }
  distances.removeWhere((key, value) => g.v0[key]! <= 0);
  distances.removeWhere((key, value) => value <= 0);
  return distances;
}

int part1(Input input) {
  Map<String, Map<String, int>> precomputedDistancesToValves = Map.fromEntries(
      input.v0.entries
          .where((e) => e.value > 0)
          .map((e) => MapEntry(e.key, djikstra(input, e.key))));
  precomputedDistancesToValves.addAll({"AA": djikstra(input, "AA")});

  int result = traverseTunnelsBFSPart1(
    precomputedDistancesToValves,
    input.v0,
    "AA",
  );

  print("Max flow: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;
  printTodo();
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(16, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 1651)]);
  day.runPart(2, part2, [Pair("example_input.txt", 1707)]);
}
