/*
 * https://adventofcode.com/2023/day/7
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<({String hand, int bid})>;

Input parse(File file) {
  final handRe = RegExp(r'(?<cards>[2-9AKQJT]{5}) (?<bid>\d+)');
  return file.readAsLinesSync().map((e) {
    final match = handRe.firstMatch(e)!;
    final hand = match.namedGroup("cards")!;
    final bid = int.parse(match.namedGroup("bid")!);
    return (hand: hand, bid: bid);
  }).toList();
}

Map<String, int> countChars(String str) {
  Map<String, int> charCount = {};
  for (var i = 0; i < str.length; i++) {
    charCount.update(
      str[i],
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }
  return charCount;
}

Map<int, int> mapCharsCountToPoints = {
  2: 1,
  3: 3,
  4: 5,
  5: 6,
};

int calcHandTypePart1(String hand) {
  return countChars(hand)
      .values
      .map((e) => mapCharsCountToPoints[e] ?? 0)
      .sum();
}

int calcHandTypePart2(String hand) {
  final counters = countChars(hand);
  final handType = counters.entries
      .where((element) => element.key != "J")
      .map((e) => mapCharsCountToPoints[e.value] ?? 0)
      .sum();
  // level up points with "J"s
  final js = counters["J"] ?? 0;
  return switch (handType) {
    // every card is unique (no cards used)
    0 => switch (js) {
        0 => 0,
        1 => 1, // one pair
        2 => 3, // three of a kind
        3 => 5, // four of a kind
        4 => 6, // five
        5 => 6, // five
        _ => throw "no way",
      },
    // one pair (2 cards used)
    1 => switch (js) {
        0 => 1,
        1 => 3, // three
        2 => 5, // four
        3 => 6, // five
        _ => throw "no way",
      },
    // two pairs (4 cards used)
    2 => switch (js) {
        0 => 2,
        1 => 4, // full house
        _ => throw "no way",
      },
    // three of a kind (3 cards used)
    3 => switch (js) {
        0 => 3,
        1 => 5, // four
        2 => 6, // five
        _ => throw "no way",
      },
    // four of a kind (4 cards used)
    5 => switch (js) {
        0 => 5,
        1 => 6, // five
        _ => throw "no way",
      },
    _ => handType, // full house or five of a kind (all cards used, no "J"s)
  };
}

int getCardValuePart1(String card) => switch (card) {
      "A" => 14,
      "K" => 13,
      "Q" => 12,
      "J" => 11,
      "T" => 10,
      _ => int.tryParse(card) ?? 0,
    };

int getCardValuePart2(String card) => switch (card) {
      "A" => 13,
      "K" => 12,
      "Q" => 11,
      "T" => 10,
      "J" => 1,
      _ => int.tryParse(card) ?? 0,
    };

int compareHandsByCard(
  String a,
  String b,
  int Function(String) cardValueComparer,
) {
  final minLen = min(a.length, b.length);
  int i = 0;
  while (i < minLen) {
    final c = cardValueComparer(a[i]).compareTo(cardValueComparer(b[i]));
    if (c != 0) return c;
    i++;
  }
  return a.length.compareTo(b.length);
}

sortHands(
  Input hands,
  int Function(String) calcHandType,
  int Function(String) getCardValue,
) {
  Map<String, int> handsTypes = {};
  for (var hand in hands) {
    handsTypes.putIfAbsent(hand.hand, () => calcHandType(hand.hand));
  }

  hands.sort(
    (a, b) {
      final aHandType = handsTypes[a.hand] ?? 0;
      final bHandType = handsTypes[b.hand] ?? 0;
      final typeCompare = aHandType.compareTo(bHandType);
      return switch (typeCompare) {
        0 => compareHandsByCard(a.hand, b.hand, getCardValue),
        _ => typeCompare,
      };
    },
  );
}

int calcScore(
  Input hands,
  int Function(String) calcHandType,
  int Function(String) getCardValue,
) {
  sortHands(hands, calcHandType, getCardValue);
  int result = 0;
  for (var rank = 1; rank <= hands.length; rank++) {
    result += hands[rank - 1].bid * rank;
  }
  return result;
}

int part1(Input input) {
  int result = calcScore(input, calcHandTypePart1, getCardValuePart1);
  print("Final game score: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = calcScore(input, calcHandTypePart2, getCardValuePart2);
  print("Final game score: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(7, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 6440)]);
  day.runPart(2, part2, [Pair("example_input.txt", 5905)]);
}
