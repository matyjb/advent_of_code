/*
 * https://adventofcode.com/2025/day/3
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef BatteryJoltages = List<int>;
typedef Banks = List<BatteryJoltages>;

Banks parse(File file) {
  return file
      .readAsLinesSync()
      .map((e) => e.split('').map(int.parse).toList())
      .toList();
}

int part1(Banks input) {
  final result = input.fold(0, (acc, bank) {
    final digitOfTenths = bank.take(bank.length - 1).reduce(max);
    final digitOfTenthsIndex = bank.indexOf(digitOfTenths);
    final digitOfOnes = bank.skip(digitOfTenthsIndex + 1).reduce(max);
    final batteryOutput = digitOfTenths * 10 + digitOfOnes;
    return acc + batteryOutput;
  });

  print("Total output of all battery bank (2 bat per bank): ${answer(result)}");
  return result;
}

int part2(Banks input) {
  final result = input.fold(0, (acc, bank) {
    int digitsLeft = 12;
    int lastDigitIndex = -1;
    List<int> selectedDigits = [];
    while (digitsLeft > 0) {
      final slice = bank
          .take(bank.length - digitsLeft + 1)
          .skip(lastDigitIndex + 1);
      final digit = slice.reduce(max);
      lastDigitIndex = bank.indexOf(digit, lastDigitIndex + 1);
      digitsLeft--;
      selectedDigits.add(digit);
    }
    int batteryOutput = 0;
    for (var i = 0; i < selectedDigits.length; i++) {
      batteryOutput +=
          selectedDigits[i] * pow(10, selectedDigits.length - i - 1).toInt();
    }
    return acc + batteryOutput;
  });

  print(
    "Total output of all battery banks (12 bat per bank): ${answer(result)}",
  );
  return result;
}

void main(List<String> args) {
  Day day = Day(3, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 357)]);
  day.runPart(2, part2, [Pair("example_input.txt", 3121910778619)]);
}
