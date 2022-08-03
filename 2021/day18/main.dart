/*
 * https://adventofcode.com/2021/day/18
 */

import 'dart:io';
import '../../day.dart';

List<String> parse(File file) {
  return file.readAsLinesSync();
}

RegExp regPairRegexp = RegExp(r'\[\d+,\d+\]');
RegExp numberRegexp = RegExp(r'\d+');

int calcMagnitude(String number) {
  var allRegularPairs = regPairRegexp.allMatches(number);
  String result = number;
  while (allRegularPairs.length > 0) {
    int indexOffset = 0;
    for (var pair in allRegularPairs) {
      String pairString = pair.group(0) ?? "";
      List<int> values = numberRegexp
          .allMatches(pairString)
          .map((e) => int.parse(e.group(0) ?? ""))
          .toList();

      String magnitudeString = (3 * values[0] + 2 * values[1]).toString();

      result = result.replaceRange(
          pair.start - indexOffset, pair.end - indexOffset, magnitudeString);

      indexOffset += pairString.length - magnitudeString.length;
    }

    allRegularPairs = regPairRegexp.allMatches(result);
  }
  return int.parse(result);
}

String reduceNumbers(List<String> numbers) => numbers.reduce((l0, l1) {
      String afterAddition = "[$l0,$l1]";

      bool didOperation = false;
      String currentString = afterAddition;
      do {
        didOperation = false;
        var allRegularsToExplode =
            regPairRegexp.allMatches(currentString).where((element) {
          int leftBrackets = currentString
              .substring(0, element.start)
              .split("")
              .fold(0, (s, element) => element == "[" ? s + 1 : s);
          int rightBrackets = currentString
              .substring(0, element.start)
              .split("")
              .fold(0, (s, element) => element == "]" ? s + 1 : s);
          int level = leftBrackets - rightBrackets;
          return level == 4;
        });
        if (allRegularsToExplode.length > 0) {
          //there is a number to explode
          RegExpMatch explodingNumberThisIteration = allRegularsToExplode.first;
          String? number = explodingNumberThisIteration.group(0) ?? "";
          List<int> numbers = numberRegexp
              .allMatches(number)
              .map((e) => int.parse(e.group(0) ?? ""))
              .toList();

          String beforeExplodingNumber =
              currentString.substring(0, explodingNumberThisIteration.start);
          if (numberRegexp.hasMatch(beforeExplodingNumber)) {
            // can transfer left number to last number in beforeExplodingNumber
            var lastValue = numberRegexp.allMatches(beforeExplodingNumber).last;
            int value = int.parse(lastValue.group(0) ?? "");
            beforeExplodingNumber = beforeExplodingNumber.replaceRange(
                lastValue.start,
                lastValue.end,
                (value + numbers[0]).toString());
          }
          String afterExplodingNumber =
              currentString.substring(explodingNumberThisIteration.end);
          if (numberRegexp.hasMatch(afterExplodingNumber)) {
            // can transfer left number to last number in afterExplodingNumber
            var firstValue =
                numberRegexp.allMatches(afterExplodingNumber).first;
            int value = int.parse(firstValue.group(0) ?? "");
            afterExplodingNumber = afterExplodingNumber.replaceRange(
                firstValue.start,
                firstValue.end,
                (value + numbers[1]).toString());
          }

          currentString = beforeExplodingNumber + "0" + afterExplodingNumber;
          didOperation = true;
        } else {
          // maybe there is something to split
          var allNumbersToSplit =
              numberRegexp.allMatches(currentString).where((element) {
            return (element.group(0) ?? "").length >=
                2; // number is bigger then 9
          });
          if (allNumbersToSplit.length > 0) {
            var firstValue = allNumbersToSplit.first;
            int value = int.parse(firstValue.group(0) ?? "");

            currentString = currentString.replaceRange(
                firstValue.start,
                firstValue.end,
                "[${(value / 2).floor()},${(value / 2).ceil()}]");

            didOperation = true;
          }
        }
      } while (didOperation);

      return currentString;
    });

void part1(List<String> numbers) {
  String finalString = reduceNumbers(numbers);

  print("Final number: $finalString");
  print("Magnitude: ${answer(calcMagnitude(finalString))}");
}

void part2(List<String> numbers) {
  int maxMagnitude = 0;
  for (var i = 0; i < numbers.length; i++) {
    for (var j = i + 1; j < numbers.length; j++) {
      List<String> pairOfNumbers0 = [numbers[i], numbers[j]];
      List<String> pairOfNumbers1 = [numbers[j], numbers[i]];

      String sum0 = reduceNumbers(pairOfNumbers0);
      String sum1 = reduceNumbers(pairOfNumbers1);

      int magnitude0 = calcMagnitude(sum0);
      int magnitude1 = calcMagnitude(sum1);

      if(maxMagnitude < magnitude0) maxMagnitude = magnitude0;
      if(maxMagnitude < magnitude1) maxMagnitude = magnitude1;
    }
  }
  print("Max magnitude of sum of any two snailfish numbers: ${answer(maxMagnitude)}");
}

void main(List<String> args) {
  Day day = Day<List<String>>(18, "input.txt", parse);
  day.runPart<List<String>>(1, part1);
  day.runPart<List<String>>(2, part2);
}
