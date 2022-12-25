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

class SumAndCarry {
  final String sum;
  final String carry;

  SumAndCarry(this.sum, this.carry);
}

Map<String, SumAndCarry> additionResults = {
  "=+=": SumAndCarry("1", "-"),
  "=+-": SumAndCarry("2", "-"),
  "=+0": SumAndCarry("=", "0"),
  "=+1": SumAndCarry("-", "0"),
  "=+2": SumAndCarry("0", "0"),
  "-+-": SumAndCarry("=", "0"),
  "-+0": SumAndCarry("-", "0"),
  "-+1": SumAndCarry("0", "0"),
  "-+2": SumAndCarry("1", "0"),
  "0+0": SumAndCarry("0", "0"),
  "0+1": SumAndCarry("1", "0"),
  "0+2": SumAndCarry("2", "0"),
  "1+1": SumAndCarry("2", "0"),
  "1+2": SumAndCarry("=", "1"),
  "2+2": SumAndCarry("-", "1"),
};

SumAndCarry halfAdder(String digit1, String digit2) {
  return additionResults["$digit1+$digit2"] ??
      additionResults["$digit2+$digit1"]!;
}

SumAndCarry fullAdder(String a, String b, String carry) {
  SumAndCarry APlusB = halfAdder(a, b);
  SumAndCarry APlusBPlusCarry = halfAdder(APlusB.sum, carry);
  String newCarry = halfAdder(APlusB.carry, APlusBPlusCarry.carry).sum;

  return SumAndCarry(APlusBPlusCarry.sum, newCarry);
}

String part1(Input input) {
  String result = input.reduce(
    (sum, number) {
      List<String> digits = [];
      String carry = "0";
      for (var i = 1; i <= max(sum.length, number.length); i++) {
        String a = sum.length - i < 0 ? "0" : sum[sum.length - i];
        String b = number.length - i < 0 ? "0" : number[number.length - i];

        SumAndCarry addResult = fullAdder(a, b, carry);
        carry = addResult.carry;
        digits.add(addResult.sum);
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
