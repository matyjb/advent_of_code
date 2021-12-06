/*
 * https://adventofcode.com/2021/day/6
 */

import 'dart:io';

void simulationStep(List<int> oceanState) {
  int createdFishesThisDay = 0;
  for (var j = 0; j <= 8; j++) {
    int currentFishesTimerState = oceanState[j];
    // just a shift down the array [j-1] <- [j]
    oceanState[j] = 0;
    if (j == 0) {
      createdFishesThisDay += currentFishesTimerState;
    } else {
      oceanState[j - 1] += currentFishesTimerState;
    }
  }
  // special cases when needed to update upper values after shift down happens
  oceanState[8] = createdFishesThisDay;
  oceanState[6] += createdFishesThisDay;
}

void main(List<String> args) {
  List<int> initialFishes = File("input.txt")
      .readAsLinesSync()[0]
      .split(",")
      .map((e) => int.parse(e))
      .toList();

  int maxDays = 256;

  //map of fish timer to how many of these fishes there are with that timer state
  List<int> oceanState = List.filled(9, 0);
  initialFishes.forEach((fishTimer) => oceanState[fishTimer] += 1);

  // solution
  for (var i = 1; i <= maxDays; i++) {
    simulationStep(oceanState);
    if (i == 80 || i == 256) {
      int sumOfAllFishes = oceanState.fold<int>(
        0,
        (previousValue, element) => previousValue + element,
      );
      print("After ${i} days ${sumOfAllFishes} fishes.");
    }
  }
}
