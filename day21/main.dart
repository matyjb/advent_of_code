/*
 * https://adventofcode.com/2021/day/21
 */

import 'dart:io';
import 'dart:math';
import 'package:quiver/core.dart';
import '../day.dart';

class PuzzleInput {
  final int p1StartingPos;
  final int p2StartingPos;

  PuzzleInput(this.p1StartingPos, this.p2StartingPos);
}

PuzzleInput parse(File file) {
  List<String> lines = file.readAsLinesSync();
  return PuzzleInput(
    int.parse(lines[0].replaceAll("Player 1 starting position: ", "")),
    int.parse(lines[1].replaceAll("Player 2 starting position: ", "")),
  );
}

void part1(PuzzleInput input) {
  int p1State = input.p1StartingPos - 1;
  int p2State = input.p2StartingPos - 1;
  int p1Points = 0, p2Points = 0;
  int diceState = 0, maxDice = 100;
  int winningPoints = 1000;
  int rolls = 0;
  bool p1Moves = true;
  do {
    rolls += 3;
    int diceSum = 0;
    for (var i = 0; i < 3; i++) {
      diceSum += diceState + 1;
      diceState++;
      diceState %= maxDice;
    }
    if (p1Moves) {
      // p1
      int points = (p1State + diceSum) % 10 + 1;
      p1Points += points;
      p1State = points - 1;
    } else {
      // p2
      int points = (p2State + diceSum) % 10 + 1;
      p2Points += points;
      p2State = points - 1;
    }
    // print("P${p1Moves ? "1" : "2"} rolls ${diceState-2}+${diceState-1}+${diceState} and moves to space ${p1Moves ? p1State+1 : p2State+1} for a total score of ${p1Moves ? p1Points : p2Points}");
    p1Moves = !p1Moves;
  } while (p1Points < winningPoints && p2Points < winningPoints);
  // printTodo();
  int score = (p1Moves ? p1Points : p2Points) * rolls;
  print(
      "The answer is: ${(p1Moves ? p1Points : p2Points)}*$rolls=${answer(score)}");
}

class GameState {
  int p1State, p2State;
  int p1Score, p2Score;
  bool p1Moves = true;
  bool get isPending => p1Score < 21 && p2Score < 21;
  int get winningPlayer => p1Score > p2Score ? 1 : (p1Score == p2Score ? 0 : 2);
  GameState(
      this.p1State, this.p1Score, this.p2State, this.p2Score, this.p1Moves);
  bool operator ==(Object other) =>
      other is GameState &&
      p1State == other.p1State &&
      p1Score == other.p1Score &&
      p2State == other.p2State &&
      p2Score == other.p2Score &&
      p1Moves == other.p1Moves;

  int get hashCode => hashObjects([
        p1State,
        p1Score,
        p2State,
        p2Score,
        p1Moves.hashCode,
      ]);
}

void part2(PuzzleInput input) {
  // map of gamestates to number of universes in this state
  Map<GameState, int> universeCounters = Map();
  universeCounters.putIfAbsent(
    GameState(input.p1StartingPos - 1, 0, input.p2StartingPos - 1, 0, true),
    () => 1,
  );
  // possible score after 3 rolls mapped to number of universes that gives that score
  Map<int, int> splits = {
    3: 1,
    4: 3,
    5: 6,
    6: 7,
    7: 6,
    8: 3,
    9: 1,
  };

  while (universeCounters.entries.any((element) => element.key.isPending)) {
    List<MapEntry<GameState, int>> pendingGames = universeCounters.entries
        .where((element) => element.key.isPending)
        .toList();

    for (var unis in pendingGames) {
      int universesEvaluated = unis.value;
      universeCounters.remove(unis.key);
      GameState currentState = unis.key;

      if (currentState.p1Moves) {
        splits.forEach((key, value) {
          GameState newState = GameState(
            (currentState.p1State + key) % 10,
            currentState.p1Score + (currentState.p1State + key) % 10 + 1,
            currentState.p2State,
            currentState.p2Score,
            false,
          );
          universeCounters.update(
            newState,
            (v) => v + universesEvaluated * value,
            ifAbsent: () => universesEvaluated * value,
          );
        });
      } else {
        splits.forEach((key, value) {
          GameState newState = GameState(
            currentState.p1State,
            currentState.p1Score,
            (currentState.p2State + key) % 10,
            currentState.p2Score + (currentState.p2State + key) % 10 + 1,
            true,
          );
          universeCounters.update(
            newState,
            (v) => v + universesEvaluated * value,
            ifAbsent: () => universesEvaluated * value,
          );
        });
      }
    }
  }
  List<int> unisWon = [0, 0];
  universeCounters.entries.forEach((element) {
    unisWon[element.key.winningPlayer - 1] += element.value;
  });
  // printTodo();
  print("The answer is: ${answer(max(unisWon[0], unisWon[1]))}");
}

void main(List<String> args) {
  Day day = Day<PuzzleInput>(21, "input.txt", parse);
  day.runPart<PuzzleInput>(1, part1);
  day.runPart<PuzzleInput>(2, part2);
}
