/*
 * https://adventofcode.com/2021/day/9
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';
typedef Grid = List<List<int>>;

Iterable<Point<int>> findAllLowPoints(Grid heightMap) sync* {
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

int fillHeightMap(Point<int> startingPoint, Grid heightMap) {
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

Grid parse(File file) {
  return file.readAsLinesSync()
      .map((line) => line.split("").map((e) => int.parse(e)).toList())
      .toList();
}

void part1(Grid heightMap) {
  int sumOfRiskLevels = 0;
  List<Point<int>> lowPoints = findAllLowPoints(heightMap).toList();
  for (var lowPoint in lowPoints) {
    sumOfRiskLevels += 1 + heightMap[lowPoint.x][lowPoint.y];
  }
  print("Found ${lowPoints.length} low points");
  print("Sum of risk levels: ${answer(sumOfRiskLevels)}");
}

void part2(Grid heightMap) {
  List<int> basinsRanking = [];
  // for every lowpoint run fill algorithm
  List<Point<int>> lowPoints = findAllLowPoints(heightMap).toList();
  for (var lowPoint in lowPoints) {
    basinsRanking.add(fillHeightMap(lowPoint, heightMap));
  }
  basinsRanking.sort();
  List<int> top3BasinSizes = basinsRanking.sublist(basinsRanking.length - 3);
  print("Top 3 basins sizes: $top3BasinSizes");
  int finalResult = top3BasinSizes.fold(1, (mul, basinSize) => mul * basinSize);
  print("Final puzzle answer: ${answer(finalResult)}");
}

void main(List<String> args) {
  Day day = Day(9, "input.txt", parse);
  day.runPart<Grid>(1, part1);
  day.runPart<Grid>(2, part2);
}
