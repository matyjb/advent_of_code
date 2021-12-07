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
  int fuelCost = crabsHeights.fold<int>(0, (fuelCostSum, element) => fuelCostSum + (element - median.toInt()).abs());
  print(fuelCost);

  print("## Part 2 ##");
  // super ultra naive and extremly bad solution
  int calcFuelCostForPosToPos(int pos0, int pos1) {
    int sum = 0;
    for (var i = 0; i < (pos0-pos1).abs(); i++) {
      sum += i+1;
    }
    return sum;
  }

  int minFuelCostCandidate = crabsHeights.fold(0, (fuelCostSum, element) => fuelCostSum + calcFuelCostForPosToPos(element, crabsHeights[0]));
  for (var i = crabsHeights[1]; i <= crabsHeights.last; i++) {
    int candidate = crabsHeights.fold(0, (fuelCostSum, element) => fuelCostSum + calcFuelCostForPosToPos(element, i));
    if(candidate < minFuelCostCandidate)
      minFuelCostCandidate = candidate;
  }
  print(minFuelCostCandidate);
}
