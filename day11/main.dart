/*
 * https://adventofcode.com/2021/day/11
 */

import 'dart:io';

bool increaseEnergyLevel(List<List<int>> grid, int x, int y) {
  if (x < 0 || x >= grid.length) return false;
  if (y < 0 || y >= grid.first.length) return false;
  if (grid[x][y] == 0) return false;

  grid[x][y]++;
  return true;
}

int flash(List<List<int>> grid, int x, int y) {
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

void main(List<String> args) {
  List<List<int>> octopusesEnergyLevelsGrid = File("input.txt")
      .readAsLinesSync()
      .map(
        (e) => e.split("").map((e) => int.parse(e)).toList(),
      )
      .toList();

  print("\x1B[32m## Part 1 ##\x1B[0m");
  int firstTimeAllFlash = 0;
  int totalFlashes100steps = 0;
  for (var n = 0; n < 500; n++) {
    for (var i = 0; i < octopusesEnergyLevelsGrid.length; i++) {
      for (var j = 0; j < octopusesEnergyLevelsGrid.first.length; j++) {
        octopusesEnergyLevelsGrid[i][j]++;
      }
    }


    for (var i = 0; i < octopusesEnergyLevelsGrid.length; i++) {
      for (var j = 0; j < octopusesEnergyLevelsGrid.first.length; j++) {
        if(octopusesEnergyLevelsGrid[i][j] > 9) {
          int tmp = flash(octopusesEnergyLevelsGrid, i, j);
          if(n < 100)
            totalFlashes100steps += tmp;
        }
      }
    }

    // check if all flashed at the same time
    bool didFlashSimultaneously = true;
    for (var i = 0; i < octopusesEnergyLevelsGrid.length; i++) {
      for (var j = 0; j < octopusesEnergyLevelsGrid.first.length; j++) {
        if(octopusesEnergyLevelsGrid[i][j] != 0) {
          didFlashSimultaneously = false;
        }
      }
    }
    if(didFlashSimultaneously && firstTimeAllFlash == 0) {
      firstTimeAllFlash = n;
      break;
    }
  }
  print("Total flashed after 100 steps: $totalFlashes100steps");
  print("\x1B[32m## Part 2 ##\x1B[0m");
  print("First time all flashed: ${firstTimeAllFlash+1} step");
}
