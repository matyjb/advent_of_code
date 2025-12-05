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

int calcBatteryPackOutput(BatteryJoltages bank, int digitsCount) {
  int digitsLeft = digitsCount;
  int lastDigitIndex = -1;

  int batteryOutput = 0;
  while (digitsLeft > 0) {
    final slice = bank
        .take(bank.length - digitsLeft + 1)
        .skip(lastDigitIndex + 1);
    final digit = slice.reduce(max);
    lastDigitIndex = bank.indexOf(digit, lastDigitIndex + 1);
    digitsLeft--;
    batteryOutput *= 10;
    batteryOutput += digit;
  }
  return batteryOutput;
}

int part1(Banks input) {
  final batteriesPerBank = 2;
  final result = input.fold(0, (acc, bank) {
    return calcBatteryPackOutput(bank, batteriesPerBank) + acc;
  });

  print(
    "Total output of all battery banks ($batteriesPerBank bat per bank): ${answer(result)}",
  );
  return result;
}

int part2(Banks input) {
  final batteriesPerBank = 12;
  final result = input.fold(0, (acc, bank) {
    return calcBatteryPackOutput(bank, batteriesPerBank) + acc;
  });

  print(
    "Total output of all battery banks ($batteriesPerBank bat per bank): ${answer(result)}",
  );
  return result;
}

void main(List<String> args) {
  Day day = Day(3, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 357)]);
  day.runPart(2, part2, [Pair("example_input.txt", 3121910778619)]);
}
