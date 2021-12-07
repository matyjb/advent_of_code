/*
 * https://adventofcode.com/2021/day/6
 */

import 'dart:io';

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

void main(List<String> args) {
  List<int> initialFishes = File("input.txt")
      .readAsStringSync()
      .split(",")
      .map((e) => int.parse(e))
      .toList();

  int maxDays = 256;

  //map of fish timer to how many of these fishes there are with that timer state
  List<int> oceanState = List.filled(9, 0);
  initialFishes.forEach((fishTimer) => oceanState[fishTimer] += 1);

  // solution
  print("⏱ start");
  Stopwatch sw = Stopwatch()..start();
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
  sw.stop();
  print("⏱ stop: ${sw.elapsedTicks} ticks");
}
