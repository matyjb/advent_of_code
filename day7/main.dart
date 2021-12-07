/*
 * https://adventofcode.com/2021/day/7
 */

import 'dart:io';

void main(List<String> args) {
  List<int> crabsHeights = File("input.txt")
      .readAsStringSync()
      .split(",")
      .map((e) => int.parse(e))
      .toList();

  print("## Part 1 ##");
  // accroding to https://math.stackexchange.com/questions/318381/on-a-1-d-line-the-point-that-minimizes-the-sum-of-the-distances-is-the-median
  // median minimizes distances
  crabsHeights.sort();
  num median = crabsHeights.length % 2 == 0
      ? (crabsHeights[(crabsHeights.length ~/ 2) - 1] +
              crabsHeights[(crabsHeights.length ~/ 2)]) /
          2
      : crabsHeights[(crabsHeights.length - 1) ~/ 2];
  int fuelCost = crabsHeights.fold<int>(0,
      (fuelCostSum, element) => fuelCostSum + (element - median.toInt()).abs());
  print("Final target position: ${median.toInt()}");
  print("Final fuel cost:       $fuelCost");

  print("## Part 2 ##");
  // super ultra naive and extremly bad solution

  // helper functions
  int calcFuelCostForPosToPos(int pos0, int pos1) {
    int sum = 0;
    for (var i = 0; i < (pos0 - pos1).abs(); i++) {
      sum += i + 1;
    }
    return sum;
  }

  int calcSubFuelCost(int fuelCostSum, MapEntry<int, int> element, int pos) =>
      fuelCostSum + calcFuelCostForPosToPos(element.key, pos) * element.value;
  ///
    
  Map<int, int> crabsHeightsDict = Map<int, int>();
  crabsHeights.forEach((element) {
    crabsHeightsDict.update(element, (value) => value + 1, ifAbsent: () => 1);
  });

  // initial candidate
  int minFuelCost = crabsHeightsDict.entries.fold(
    0,
    (fuelCostSum, element) =>
        calcSubFuelCost(fuelCostSum, element, crabsHeights[0]),
  );
  int finalTarget = 0;
  // searching for the better candidate
  for (var i = crabsHeights[1]; i <= crabsHeights.last; i++) {
    int candidate = crabsHeightsDict.entries.fold(
      0,
      (fuelCostSum, element) => calcSubFuelCost(fuelCostSum, element, i),
    );
    if (candidate < minFuelCost) {
      minFuelCost = candidate;
      finalTarget = i;
    }
  }
  print("Final target position: $finalTarget");
  print("Final fuel cost:       $minFuelCost");
}
