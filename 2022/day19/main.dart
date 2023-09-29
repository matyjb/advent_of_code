/*
 * https://adventofcode.com/2022/day/19
 */

import 'dart:collection';
import 'dart:io';
import 'dart:math';
import '../../day.dart';

class Blueprint {
  final int id;
  final int oreRobotCost;
  final int clayRobotCost;
  final List<int> obsidianRobotCost;
  final List<int> geodeRobotCost;

  Blueprint(
    this.id,
    this.oreRobotCost,
    this.clayRobotCost,
    this.obsidianRobotCost,
    this.geodeRobotCost,
  );
}

typedef Input = List<Blueprint>;

Input parse(File file) {
  RegExp idr = RegExp(r'Blueprint (\d+)');
  RegExp oreR = RegExp(r'Each ore robot costs (\d+) ore.');
  RegExp clayR = RegExp(r'Each clay robot costs (\d+) ore.');
  RegExp obsR = RegExp(r'Each obsidian robot costs (\d+) ore and (\d+) clay.');
  RegExp geoR = RegExp(r'Each geode robot costs (\d+) ore and (\d+) obsidian.');

  return file.readAsLinesSync().map((e) {
    int id = int.parse(idr.allMatches(e).first.group(1)!);
    int oreRobotCost = int.parse(oreR.allMatches(e).first.group(1)!);
    int clayRobotCost = int.parse(clayR.allMatches(e).first.group(1)!);
    List<int> obsidianRobotCost = obsR
        .allMatches(e)
        .first
        .groups([1, 2])
        .map((s) => int.parse(s!))
        .toList();
    List<int> geodeRobotCost = geoR
        .allMatches(e)
        .first
        .groups([1, 2])
        .map((s) => int.parse(s!))
        .toList();
    return Blueprint(
        id, oreRobotCost, clayRobotCost, obsidianRobotCost, geodeRobotCost);
  }).toList();
}

class State {
  int ore, clay, obs, geode;
  int oreRobots, clayRobots, obsRobots, geodeRobots;

  State(this.ore, this.clay, this.obs, this.geode, this.oreRobots,
      this.clayRobots, this.obsRobots, this.geodeRobots);

  State get nextState {
    State result = this.copy();
    result.ore += result.oreRobots;
    result.clay += result.clayRobots;
    result.obs += result.obsRobots;
    result.geode += result.geodeRobots;
    return result;
  }

  State copy() => State(
      ore, clay, obs, geode, oreRobots, clayRobots, obsRobots, geodeRobots);

  bool operator ==(Object other) {
    return other is State &&
        ore == other.ore &&
        clay == other.clay &&
        obs == other.obs &&
        geode == other.geode &&
        oreRobots == other.oreRobots &&
        clayRobots == other.clayRobots &&
        obsRobots == other.obsRobots &&
        geodeRobots == other.geodeRobots;
  }
}

int findBestQualityLevelDFS(Blueprint b, State currentState,
    Set<State> discoveredStates, int minutesLeft) {
  if (minutesLeft <= 0) {
    return currentState.geode;
  }

  discoveredStates.add(currentState);
  // TODO: calc possibleNextStates (what can be built + nothing to build)
  // for every posibility calc ores state
  List<State> possibleNextStates = [
    currentState.nextState, // do nothing
  ];
  if (currentState.ore >= b.oreRobotCost) {
    // can build ore robot
    State nextState = currentState.nextState;
    nextState.ore -= b.oreRobotCost;
    nextState.oreRobots++;
    possibleNextStates.add(nextState);
  }
  if (currentState.ore >= b.clayRobotCost) {
    // can build clay robot
    State nextState = currentState.nextState;
    nextState.ore -= b.clayRobotCost;
    nextState.clayRobots++;
    possibleNextStates.add(nextState);
  }
  if (currentState.ore >= b.obsidianRobotCost[0] &&
      currentState.clay >= b.obsidianRobotCost[1]) {
    // can build obsidian robot
    State nextState = currentState.nextState;
    nextState.ore -= b.obsidianRobotCost[0];
    nextState.clay -= b.obsidianRobotCost[1];
    nextState.obsRobots++;
    possibleNextStates.add(nextState);
  }
  if (currentState.ore >= b.geodeRobotCost[0] &&
      currentState.clay >= b.geodeRobotCost[1]) {
    // can build geode robot
    State nextState = currentState.nextState;
    nextState.ore -= b.geodeRobotCost[0];
    nextState.obs -= b.geodeRobotCost[1];
    nextState.geodeRobots++;
    possibleNextStates.add(nextState);
  }
  int maxGeode = currentState.geode;
  for (State possibleNextState in possibleNextStates) {
    if (!discoveredStates.contains(possibleNextState)) {
      maxGeode = max(
        maxGeode,
        findBestQualityLevelDFS(
          b,
          possibleNextState,
          discoveredStates,
          minutesLeft - 1,
        ),
      );
    }
  }
  return maxGeode;
}

int part1(Input input) {
  int minutesLeft = 24;
  Map<Blueprint, int> qualityLevels = {};
  for (var blueprint in input) {
    State startingState = State(0, 0, 0, 0, 1, 0, 0, 0);
    qualityLevels.putIfAbsent(
      blueprint,
      () => findBestQualityLevelDFS(blueprint, startingState, {}, minutesLeft),
    );
  }
  int result =
      qualityLevels.entries.fold(0, (acc, e) => acc + e.key.id * e.value);

  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;

  printTodo();
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(19, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 33)]);
  // day.runPart(2, part2, [Pair("example_input.txt", 0)]);
}
