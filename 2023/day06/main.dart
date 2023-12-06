/*
 * https://adventofcode.com/2023/day/6
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<({int time, int distance})>;

Input parse(File file) {
  final numberRe = RegExp(r"\d+");
  final lines = file.readAsLinesSync();

  List<int> times = [];
  List<int> distances = [];

  for (var line in lines) {
    if (line.startsWith("Time:")) {
      times.addAll(
        numberRe.allMatches(line).map((e) => int.parse(e.group(0)!)),
      );
    } else if (line.startsWith("Distance:")) {
      distances.addAll(
        numberRe.allMatches(line).map((e) => int.parse(e.group(0)!)),
      );
    }
  }

  Input result = [];
  for (var i = 0; i < min(times.length, distances.length); i++) {
    result.add((time: times[i], distance: distances[i]));
  }

  return result;
}

int findMinimalTimeRequiredToWin(int time, int distance) {
  int minHold = 0;
  int maxHold = time ~/ 2;
  while (minHold < maxHold) {
    int midHold = (minHold + maxHold) ~/ 2;
    if (distance < midHold * (time - midHold)) {
      // distance beaten
      maxHold = midHold;
    } else {
      minHold = midHold + 1;
    }
  }
  return minHold;
}

int getNumberOfWaysToWin(int minHold, int raceTime) =>
    raceTime - 2 * minHold + 1;

int part1(Input input) {
  int result = input.fold(1, (mul, race) {
    final t = findMinimalTimeRequiredToWin(race.time, race.distance);
    return mul * getNumberOfWaysToWin(t, race.time);
  });

  print(
    "Number of ways multiplied by itself across all races: ${answer(result)}",
  );
  return result;
}

int part2(Input input) {
  final time = int.parse(input.map((e) => e.time).join());
  final distance = int.parse(input.map((e) => e.distance).join());

  int result = getNumberOfWaysToWin(
    findMinimalTimeRequiredToWin(time, distance),
    time,
  );

  print("Number of ways to win this race: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(6, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 288)]);
  day.runPart(2, part2, [Pair("example_input.txt", 71503)]);
}
