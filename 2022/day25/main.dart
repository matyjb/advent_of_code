/*
 * https://adventofcode.com/2022/day/25
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<String>;

Input parse(File file) {
  return file.readAsLinesSync().toList();
}

class DigitAndCarry {
  final String digit;
  final String carry;

  DigitAndCarry(this.digit, this.carry);
}

Map<String, DigitAndCarry> additionResults = {
  "==": DigitAndCarry("1", "-"),
  "=-": DigitAndCarry("2", "-"),
  "=0": DigitAndCarry("=", "0"),
  "=1": DigitAndCarry("-", "0"),
  "=2": DigitAndCarry("0", "0"),
  "--": DigitAndCarry("=", "0"),
  "-0": DigitAndCarry("-", "0"),
  "-1": DigitAndCarry("0", "0"),
  "-2": DigitAndCarry("1", "0"),
  "00": DigitAndCarry("0", "0"),
  "01": DigitAndCarry("1", "0"),
  "02": DigitAndCarry("2", "0"),
  "11": DigitAndCarry("2", "0"),
  "12": DigitAndCarry("=", "1"),
  "22": DigitAndCarry("-", "1"),
};

DigitAndCarry halfAdder(String digit1, String digit2) {
  return additionResults[digit1 + digit2] ?? additionResults[digit2 + digit1]!;
}

DigitAndCarry fullAdder(String a, String b, String carry) {
  DigitAndCarry APlusB = halfAdder(a, b);
  DigitAndCarry APlusBPlusCarry = halfAdder(APlusB.digit, carry);
  String newCarry = halfAdder(APlusB.carry, APlusBPlusCarry.carry).digit;

  return DigitAndCarry(APlusBPlusCarry.digit, newCarry);
}

String part1(Input input) {
  String result = input.reduce(
    (sum, number) {
      List<String> digits = [];
      String carry = "0";
      for (var i = 1; i <= max(sum.length, number.length); i++) {
        String a = sum.length - i < 0 ? "0" : sum[sum.length - i];
        String b = number.length - i < 0 ? "0" : number[number.length - i];

        DigitAndCarry addResult = fullAdder(a, b, carry);
        carry = addResult.carry;
        digits.add(addResult.digit);
      }
      if (carry != "0") digits.add(carry);
      return digits.reversed.join();
    },
  );

  print("Sum of SNAFU numbers: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(25, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", "2=-1=0")]);
}
