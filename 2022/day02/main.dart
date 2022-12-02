/*
 * https://adventofcode.com/2022/day/2
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<Pair<String, String>>;

Input parse(File file) {
  return file.readAsLinesSync().map((e) {
    var splitVal = e.split(" ");
    return Pair(splitVal[0], splitVal[1]);
  }).toList();
}

const lettersToIntsMap = {
  "A": 0,
  "B": 1,
  "C": 2,
  "X": 0,
  "Y": 1,
  "Z": 2,
};
Pair<int, int> mapToInts(Pair<String, String> game) {
  return Pair(lettersToIntsMap[game.v0]!, lettersToIntsMap[game.v1]!);
}

int calcGameScore(Pair<int, int> game) {
  int playerHandScore = game.v1 + 1;
  if (game.v0 == game.v1) return playerHandScore + 3;
  if (game.v0 == (game.v1 + 1) % 3) return playerHandScore + 0;
  if (game.v0 == (game.v1 + 2) % 3) return playerHandScore + 6;
  throw "Weird game ${game.v0} ${game.v1}";
}

int calcScore(List<Pair<int, int>> games) {
  return games.fold(0, (acc, game) => acc + calcGameScore(game));
}

int part1(Input input) {
  List<Pair<int, int>> mappedLetters = input.map(mapToInts).toList();

  int score = calcScore(mappedLetters);
  print("Final score: ${answer(score)}");
  return score;
}

int part2(Input input) {
  List<Pair<int, int>> mappedLetters = input.map(mapToInts).toList();
  // X = 0 = must lose
  // Y = 1 = must draw
  // Z = 2 = must win
  List<Pair<int, int>> mappedLettersWithDesiredHand =
      mappedLetters.map((e) => Pair(e.v0, (e.v0 + e.v1 + 2) % 3)).toList();

  int score = calcScore(mappedLettersWithDesiredHand);
  print("Final score: ${answer(score)}");
  return score;
}

void main(List<String> args) {
  Day day = Day(2, "input.txt", parse);
  day.runPart<Input>(1, part1, [Pair("example_input.txt", 15)]);
  day.runPart<Input>(2, part2, [Pair("example_input.txt", 12)]);
}
