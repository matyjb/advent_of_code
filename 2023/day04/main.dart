/*
 * https://adventofcode.com/2023/day/4
 */

import 'dart:io';
import '../../day.dart';

typedef Card = ({int id, List<int> winning, List<int> owned});

typedef Input = List<Card>;

Input parse(File file) {
  final lineRe =
      RegExp(r'Card\s+(?<id>\d+): (?<winning>[\d ]+)\|(?<owned>[\d ]+)');
  final numberRe = RegExp(r'\d+');
  return file.readAsLinesSync().map((e) {
    final lineMatch = lineRe.firstMatch(e)!;
    final winning = numberRe
        .allMatches(lineMatch.namedGroup("winning")!)
        .map((e) => int.parse(e.group(0)!))
        .toList();
    final owned = numberRe
        .allMatches(lineMatch.namedGroup("owned")!)
        .map((e) => int.parse(e.group(0)!))
        .toList();
    final id = int.parse(lineMatch.namedGroup("id")!);
    return (id: id, winning: winning, owned: owned);
  }).toList();
}

int part1(Input input) {
  int _calcScore(Card card) {
    return card.winning.fold(
      0,
      (score, winNum) => card.owned.contains(winNum)
          ? score == 0
              ? 1
              : score * 2
          : score,
    );
  }

  int result = input.fold(0, (score, card) => score + _calcScore(card));
  print("Final scrore of all cards: ${answer(result)}");
  return result;
}

int part2(Input input) {
  _wins(Card card) => card.winning.fold(
        0,
        (wins, winNum) => card.owned.contains(winNum) ? wins + 1 : wins,
      );
  // holds number of cards that this card id creates including the original
  Map<int, int> cardsAccuired = {};

  for (var card in input.reversed) {
    final wins = _wins(card);
    int winsScore = 0;
    for (var i = 1; i <= wins; i++) {
      winsScore += cardsAccuired[card.id + i] ?? 0;
    }
    cardsAccuired[card.id] = winsScore + 1;
  }

  int result = cardsAccuired.values.sum();

  print("Amount of cards accuired: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(4, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 13)]);
  day.runPart(2, part2, [Pair("example_input.txt", 30)]);
}
