/*
 * https://adventofcode.com/2022/day/2
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<Pair<String, String>>;

enum rps { rock, paper, scrissors }

enum gameResult { win, draw, lose }

const lettersMap = {
  "A": rps.rock,
  "B": rps.paper,
  "C": rps.scrissors,
  "X": rps.rock,
  "Y": rps.paper,
  "Z": rps.scrissors,
};
const lettersResultMap = {
  "X": gameResult.lose,
  "Y": gameResult.draw,
  "Z": gameResult.win,
};

const resultPointsMap = {
  gameResult.win: 6,
  gameResult.draw: 3,
  gameResult.lose: 0,
};

const handPoints = {
  rps.rock: 1,
  rps.paper: 2,
  rps.scrissors: 3,
};

gameResult calcGameResult(rps opponent, rps player) {
  if (opponent == player) return gameResult.draw;
  if (player == rps.rock && opponent == rps.scrissors) return gameResult.win;
  if (player == rps.paper && opponent == rps.rock) return gameResult.win;
  if (player == rps.scrissors && opponent == rps.paper) return gameResult.win;
  return gameResult.lose;
}

int calcGameScore(rps opponent, rps player) {
  return handPoints[player]! +
      resultPointsMap[calcGameResult(opponent, player)]!;
}

int calcScore(List<Pair<rps,rps>> games) {
  return games.fold(0, (acc, game) => acc + calcGameScore(game.v0, game.v1));
}

Input parse(File file) {
  return file.readAsLinesSync().map((e) {
    var splitVal = e.split(" ");
    return Pair(splitVal[0], splitVal[1]);
  }).toList();
}

int part1(Input input) {
  List<Pair<rps, rps>> mappedLetters =
      input.map((e) => Pair(lettersMap[e.v0]!, lettersMap[e.v1]!)).toList();

  int score = calcScore(mappedLetters);
  print("Final score: ${answer(score)}");
  return score;
}

rps getPlayerHand(rps opponent, gameResult result) {
  if (result == gameResult.win) {
    if (opponent == rps.rock) return rps.paper;
    if (opponent == rps.paper)
      return rps.scrissors;
    else
      return rps.rock;
  } else if (result == gameResult.lose) {
    if (opponent == rps.rock) return rps.scrissors;
    if (opponent == rps.paper)
      return rps.rock;
    else
      return rps.paper;
  } else
    return opponent;
}

int part2(Input input) {
  List<Pair<rps, rps>> mappedLetters = input.map((e) {
    rps opponent = lettersMap[e.v0]!;
    rps player = getPlayerHand(opponent, lettersResultMap[e.v1]!);
    return Pair(opponent, player);
  }).toList();

  int score = calcScore(mappedLetters);
  print("Final score: ${answer(score)}");
  return score;
}

void main(List<String> args) {
  Day day = Day(2, "input.txt", parse);
  day.runPart<Input>(1, part1, [Pair("example_input.txt", 15)]);
  day.runPart<Input>(2, part2, [Pair("example_input.txt", 12)]);
}
