/*
 * https://adventofcode.com/2021/day/6
 */

import 'dart:io';

void main(List<String> args) {
  List<int> initialFishes = File("input.txt")
      .readAsLinesSync()[0]
      .split(",")
      .map((e) => int.parse(e))
      .toList();

  print("## Part 1 ##");
  List<int> fishes = List.from(initialFishes);

  for (var i = 0; i < 80; i++) {
    int aliveFishesCount = fishes.length;
    for (var j = 0; j < aliveFishesCount; j++) {
      if (fishes[j] == 0) {
        // create new fish 8
        fishes.add(8);
        // reset current to 6
        fishes[j] = 6;
      } else {
        fishes[j]--;
      }
    }
  }
  print("After 80 days ${fishes.length} fishes.");

  print("## Part 2 ##");
  //map of fish timer to how many of these fishes there are with that timer state
  Map<int, int> fishTimers = {
    for (var i = 0; i < 9; i++) i: 0,
  };
  initialFishes.forEach(
    (fish) => fishTimers.update(
      fish,
      (value) => value + 1,
    ),
  );
  for (var i = 0; i < 256; i++) {
    int createdFishesThisDay = 0;
    for (var j = 0; j <= 8; j++) {
      int currentFishesTimerState = fishTimers[j] ?? 0;
      fishTimers.update(j, (value) => 0);
      if (j == 0) {
        createdFishesThisDay += currentFishesTimerState;
      } else {
        fishTimers.update(j - 1, (value) => value + currentFishesTimerState);
      }
    }
    fishTimers.update(8, (value) => createdFishesThisDay);
    fishTimers.update(6, (value) => value + createdFishesThisDay);
  }
  int sumOfAllFishes = fishTimers.values.fold<int>(
    0,
    (previousValue, element) => previousValue + element,
  );
  print("After 256 days ${sumOfAllFishes} fishes.");
}
