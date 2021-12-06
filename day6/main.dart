/*
 * https://adventofcode.com/2021/day/6
 */

import 'dart:io';

void simulationStep(Map<int, int> oceanState) {
  int createdFishesThisDay = 0;
  for (var j = 0; j <= 8; j++) {
    int currentFishesTimerState = oceanState[j] ?? 0;
    oceanState.update(j, (value) => 0);
    if (j == 0) {
      createdFishesThisDay += currentFishesTimerState;
    } else {
      oceanState.update(j - 1, (value) => value + currentFishesTimerState);
    }
  }
  oceanState.update(8, (value) => createdFishesThisDay);
  oceanState.update(6, (value) => value + createdFishesThisDay);
}

void main(List<String> args) {
  List<int> initialFishes = File("input.txt")
      .readAsLinesSync()[0]
      .split(",")
      .map((e) => int.parse(e))
      .toList();

  int maxDays = 256;

  //map of fish timer to how many of these fishes there are with that timer state
  Map<int, int> oceanState = {
    for (var i = 0; i < 9; i++) i: 0,
  };
  initialFishes.forEach(
    (fish) => oceanState.update(
      fish,
      (value) => value + 1,
    ),
  );

  // solution
  for (var i = 1; i <= maxDays; i++) {
    simulationStep(oceanState);
    if (i == 80 || i == 256) {
      int sumOfAllFishes = oceanState.values.fold<int>(
        0,
        (previousValue, element) => previousValue + element,
      );
      print("After ${i} days ${sumOfAllFishes} fishes.");
    }
  }
}
