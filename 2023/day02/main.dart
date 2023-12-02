/*
 * https://adventofcode.com/2023/day/2
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

class Game {
  final int id;
  final List<List<(int, String)>> sets;

  Game({required this.id, required this.sets});

  @override
  String toString() {
    return "Game $id: ${sets.map((e) => e.map((e) => "${e.$1} ${e.$2}").join(", ")).join("; ")}";
  }
}

typedef Input = List<Game>;

Input parse(File file) {
  final gameRe = RegExp(r'Game (?<id>\d+): (?<sets>.+)');
  final setsRe = RegExp(r'(?:\d+ (?:red|green|blue),? ?)+');
  final moveRe = RegExp(r'(?<amount>\d+) (?<color>red|green|blue)');
  return file.readAsLinesSync().map((e) {
    final game = gameRe.firstMatch(e)!;
    final sets = setsRe.allMatches(game.namedGroup("sets")!);

    return Game(
      id: int.parse(game.namedGroup("id")!),
      sets: sets
          .map(
            (e) => moveRe
                .allMatches(e.group(0)!)
                .map(
                  (e) => (
                    int.parse(e.namedGroup("amount")!),
                    e.namedGroup("color")!,
                  ),
                )
                .toList(),
          )
          .toList(),
    );
  }).toList();
}

int part1(Input input) {
  final Map<String, int> maxCubes = {
    "red": 12,
    "green": 13,
    "blue": 14,
  };

  final result = input.fold(
    0,
    (possible, game) => game.sets
            .any((set) => set.any((cubes) => maxCubes[cubes.$2]! < cubes.$1))
        ? possible
        : possible + game.id,
  );
  print("Sum of ids of possible games: ${answer(result)}");
  return result;
}

int part2(Input input) {
  final result = input.fold(0, (sumOfPowers, game) {
    // holds minimum amounts of cubes needed for each color
    // for the game to be possible
    Map<String, int> mins = {};

    for (var sett in game.sets) {
      for (var cubes in sett) {
        mins.update(
          cubes.$2,
          (value) => max(value, cubes.$1),
          ifAbsent: () => cubes.$1,
        );
      }
    }
    return sumOfPowers + mins.values.fold(1, (power, value) => value * power);
  });

  print("Sum of powers of games: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(2, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 8)]);
  day.runPart(2, part2, [Pair("example_input.txt", 2286)]);
}
