/*
 * https://adventofcode.com/2021/day/9
 */

import 'dart:io';
import 'dart:math';

Iterable<Point<int>> findAllLowPoints(List<List<int>> heightMap) sync* {
  int heightMapXLenght = heightMap.first.length;
  int heightMapYLenght = heightMap.length;
  for (var x = 0; x < heightMapXLenght; x++) {
    for (var y = 0; y < heightMapYLenght; y++) {
      int currentHeight = heightMap[x][y];
      if (x > 0 && heightMap[x - 1][y] <= currentHeight) continue;
      if (x < heightMapXLenght - 1 && heightMap[x + 1][y] <= currentHeight)
        continue;
      if (y > 0 && heightMap[x][y - 1] <= currentHeight) continue;
      if (y < heightMapYLenght - 1 && heightMap[x][y + 1] <= currentHeight)
        continue;

      yield Point(x, y);
    }
  }
}

int fillHeightMap(Point<int> startingPoint, List<List<int>> heightMap) {
  int heightMapXLenght = heightMap.first.length;
  int heightMapYLenght = heightMap.length;
  if (startingPoint.x < 0 || startingPoint.y < 0) return 0;
  if (startingPoint.x >= heightMapXLenght ||
      startingPoint.y >= heightMapYLenght) return 0;
  if (heightMap[startingPoint.x][startingPoint.y] == 9) return 0;

  heightMap[startingPoint.x][startingPoint.y] = 9;
  return 1 +
      fillHeightMap(startingPoint + Point(1, 0), heightMap) +
      fillHeightMap(startingPoint + Point(-1, 0), heightMap) +
      fillHeightMap(startingPoint + Point(0, 1), heightMap) +
      fillHeightMap(startingPoint + Point(0, -1), heightMap);
}

void main(List<String> args) {
  List<List<int>> heightMap = File("input.txt")
      .readAsLinesSync()
      .map((line) => line.split("").map((e) => int.parse(e)).toList())
      .toList();
  print("## Part 1 ##");
  int sumOfRiskLevels = 0;
  List<Point<int>> lowPoints = findAllLowPoints(heightMap).toList();
  for (var lowPoint in lowPoints) {
    sumOfRiskLevels += 1 + heightMap[lowPoint.x][lowPoint.y];
  }
  print("Found ${lowPoints.length} low points");
  print("Sum of risk levels: $sumOfRiskLevels");
  print("## Part 2 ##");
  List<int> basinsRanking = [];
  // for every lowpoint run fill algorithm
  for (var lowPoint in lowPoints) {
    basinsRanking.add(fillHeightMap(lowPoint, heightMap));
  }
  basinsRanking.sort();
  List<int> top3BasinSizes = basinsRanking.sublist(basinsRanking.length - 3);
  print("Top 3 basins sizes: $top3BasinSizes");
  int finalResult = top3BasinSizes.fold(1, (mul, basinSize) => mul * basinSize);
  print("Final puzzle answer: $finalResult");
}
