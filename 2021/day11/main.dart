/*
 * https://adventofcode.com/2021/day/11
 */

import 'dart:io';
import '../../day.dart';

typedef Grid = List<List<int>>;

bool increaseEnergyLevel(Grid grid, int x, int y) {
  if (x < 0 || x >= grid.length) return false;
  if (y < 0 || y >= grid.first.length) return false;
  if (grid[x][y] == 0) return false;

  grid[x][y]++;
  return true;
}

int flash(Grid grid, int x, int y) {
  if (x < 0 || x >= grid.length) return 0;
  if (y < 0 || y >= grid.first.length) return 0;
  if (grid[x][y] < 10) return 0;

  // x and y in bounds and energy level is enough for a flash
  grid[x][y] = 0;
  increaseEnergyLevel(grid, x + 1, y + 1);
  increaseEnergyLevel(grid, x + 1, y - 1);
  increaseEnergyLevel(grid, x - 1, y + 1);
  increaseEnergyLevel(grid, x - 1, y - 1);
  increaseEnergyLevel(grid, x, y + 1);
  increaseEnergyLevel(grid, x, y - 1);
  increaseEnergyLevel(grid, x + 1, y);
  increaseEnergyLevel(grid, x - 1, y);
  return 1 +
      flash(grid, x + 1, y + 1) +
      flash(grid, x + 1, y - 1) +
      flash(grid, x - 1, y + 1) +
      flash(grid, x - 1, y - 1) +
      flash(grid, x, y + 1) +
      flash(grid, x, y - 1) +
      flash(grid, x + 1, y) +
      flash(grid, x - 1, y);
}

int simulationStep(Grid octopusesGrid) {
  int totalFlashesThisSteps = 0;
  for (var i = 0; i < octopusesGrid.length; i++) {
    for (var j = 0; j < octopusesGrid.first.length; j++) {
      octopusesGrid[i][j]++;
    }
  }

  for (var i = 0; i < octopusesGrid.length; i++) {
    for (var j = 0; j < octopusesGrid.first.length; j++) {
      if (octopusesGrid[i][j] > 9) {
        int tmp = flash(octopusesGrid, i, j);
        totalFlashesThisSteps += tmp;
      }
    }
  }
  return totalFlashesThisSteps;
}

Grid parse(File file) {
  return file
      .readAsLinesSync()
      .map(
        (e) => e.split("").map((e) => int.parse(e)).toList(),
      )
      .toList();
}

void part1(Grid octopusesGrid) {
  int totalFlashes100steps = 0;
  for (var i = 0; i < 100; i++) {
    totalFlashes100steps += simulationStep(octopusesGrid);
  }
  print("Total flashed after 100 steps: ${answer(totalFlashes100steps)}");
}

void part2(Grid octopusesGrid) {
  bool didFlashSimultaneously = true;
  int step = 0;
  do {
    didFlashSimultaneously = true;
    simulationStep(octopusesGrid);
    step++;

    // check if all flashed at the same time
    for (var i = 0; i < octopusesGrid.length; i++) {
      for (var j = 0; j < octopusesGrid.first.length; j++) {
        if (octopusesGrid[i][j] != 0) {
          didFlashSimultaneously = false;
        }
      }
    }
  } while (!didFlashSimultaneously);
  print("First time all flashed: ${answer(step)} step");
}

void main(List<String> args) {
  Day day = Day(11, "input.txt", parse);
  day.runPart<Grid>(1, part1);
  day.runPart<Grid>(2, part2);
}
