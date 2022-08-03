/*
 * https://adventofcode.com/2021/day/6
 */

import 'dart:io';
import '../../day.dart';

void simulationStep(List<int> oceanState) {
  int createdFishesThisDay = oceanState[0];
  // just a shift down the array [j-1] <- [j]
  for (var j = 1; j < oceanState.length; j++) {
    oceanState[j - 1] = oceanState[j];
  }
  // special cases when needed to update upper values after shift down happens
  oceanState[8] = createdFishesThisDay;
  oceanState[6] += createdFishesThisDay;
}

int runSimFor(List<int> initialFishes, int days){
  List<int> oceanState = List.filled(9, 0);
  initialFishes.forEach((fishTimer) => oceanState[fishTimer] += 1);
  for (var i = 1; i <= days; i++) {
    simulationStep(oceanState);
  }
  return oceanState.fold<int>(
    0,
    (previousValue, element) => previousValue + element,
  );
}

List<int> parse(File file) {
  return file.readAsStringSync().split(",").map((e) => int.parse(e)).toList();
}

void part1(List<int> initialFishes) {
  int days = 80;
  print("After $days days ${answer(runSimFor(initialFishes, days))} fishes.");
}

void part2(List<int> initialFishes) {
  int days = 256;
  print("After $days days ${answer(runSimFor(initialFishes, days))} fishes.");
}

void main(List<String> args) {
  Day day = Day(6, "input.txt", parse);
  day.runPart<List<int>>(1, part1);
  day.runPart<List<int>>(2, part2);
}
