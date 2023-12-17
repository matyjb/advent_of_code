/*
 * https://adventofcode.com/2023/day/16
 */

import 'dart:collection';
import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<String>;

enum Direction { up, down, left, right }

typedef Beam = ({int row, int col, Direction direction});

Input parse(File file) {
  return file.readAsLinesSync();
}

getNextOnDot(Beam beam) => switch (beam.direction) {
      Direction.up => (
          row: beam.row - 1,
          col: beam.col,
          direction: Direction.up
        ),
      Direction.down => (
          row: beam.row + 1,
          col: beam.col,
          direction: Direction.down
        ),
      Direction.left => (
          row: beam.row,
          col: beam.col - 1,
          direction: Direction.left
        ),
      Direction.right => (
          row: beam.row,
          col: beam.col + 1,
          direction: Direction.right
        ),
    };

getNextOnForwSlash(Beam beam) {
  return switch (beam.direction) {
    Direction.up => (
        row: beam.row,
        col: beam.col + 1,
        direction: Direction.right
      ),
    Direction.down => (
        row: beam.row,
        col: beam.col - 1,
        direction: Direction.left
      ),
    Direction.left => (
        row: beam.row + 1,
        col: beam.col,
        direction: Direction.down
      ),
    Direction.right => (
        row: beam.row - 1,
        col: beam.col,
        direction: Direction.up
      ),
  };
}

getNextOnBackSlash(Beam beam) {
  return switch (beam.direction) {
    Direction.up => (
        row: beam.row,
        col: beam.col - 1,
        direction: Direction.left
      ),
    Direction.down => (
        row: beam.row,
        col: beam.col + 1,
        direction: Direction.right
      ),
    Direction.left => (
        row: beam.row - 1,
        col: beam.col,
        direction: Direction.up
      ),
    Direction.right => (
        row: beam.row + 1,
        col: beam.col,
        direction: Direction.down
      ),
  };
}

simulate(Beam start, Input input) {
  List<Beam> beams = [start];
  // remove beam on already used splits
  Set<(int, int)> usedSplits = {};

  HashSet<(int, int)> visited = HashSet();

  while (beams.isNotEmpty) {
    // handle interactions with grid
    int beamsToUpdate = beams.length;
    while (beamsToUpdate > 0) {
      final beam = beams.removeAt(0);
      // remove beam if out of bounds or split used
      if (beam.row >= 0 &&
          beam.row < input.length &&
          beam.col >= 0 &&
          beam.col < input.first.length &&
          !usedSplits.contains((beam.row, beam.col))) {
        visited.add((beam.row, beam.col));
        switch (input[beam.row][beam.col]) {
          case ".":
            beams.add(getNextOnDot(beam));
            break;
          case "\\":
            beams.add(getNextOnBackSlash(beam));
            break;
          case "/":
            beams.add(getNextOnForwSlash(beam));
            break;
          case "-":
            usedSplits.add((beam.row, beam.col));
            beams.addAll(switch (beam.direction) {
              Direction.up || Direction.down => [
                  (row: beam.row, col: beam.col - 1, direction: Direction.left),
                  (
                    row: beam.row,
                    col: beam.col + 1,
                    direction: Direction.right
                  ),
                ],
              _ => [getNextOnDot(beam)],
            });

            break;
          case "|":
            usedSplits.add((beam.row, beam.col));
            beams.addAll(switch (beam.direction) {
              Direction.left || Direction.right => [
                  (row: beam.row - 1, col: beam.col, direction: Direction.up),
                  (row: beam.row + 1, col: beam.col, direction: Direction.down),
                ],
              _ => [getNextOnDot(beam)],
            });
            break;

          default:
        }
      }
      beamsToUpdate--;
    }
  }
  return visited.length;
}

int part1(Input input) {
  int result = simulate((row: 0, col: 0, direction: Direction.right), input);

  print("Energized tiles: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;
  // top&bottom
  for (var col = 0; col < input.first.length; col++) {
    result = max(
        result,
        simulate(
          (row: 0, col: col, direction: Direction.down),
          input,
        ));
    result = max(
        result,
        simulate(
          (row: input.length - 1, col: col, direction: Direction.up),
          input,
        ));
  }
  // left&right
  for (var row = 0; row < input.length; row++) {
    result = max(
        result,
        simulate(
          (row: row, col: 0, direction: Direction.right),
          input,
        ));
    result = max(
        result,
        simulate(
          (row: row, col: input.first.length - 1, direction: Direction.left),
          input,
        ));
  }

  print("Maximum energized tiles: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(16, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 46)]);
  day.runPart(2, part2, [Pair("example_input.txt", 51)]);
}
