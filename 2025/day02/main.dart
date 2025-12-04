/*
 * https://adventofcode.com/2025/day/2
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<(int start, int end)>;

Input parse(File file) {
  final line = file.readAsStringSync();
  final rx = RegExp(r'(\d+)-(\d+)');

  return [
    for (final match in rx.allMatches(line))
      (int.parse(match.group(1)!), int.parse(match.group(2)!)),
  ];
}

int part1(Input input) {
  int result = 0;
  // operate only in terms of first halfs of the palindromes
  // for odd length numbers the next palindrom must be in even
  // the amount of palindromes will be a difference between the first halfs of the start end palindromes

  for (var (start, end) in input) {
    int startRepeatHalfInt = 0;
    int endRepeatHalfInt = 0;
    // calc first palindrom bigger or equal to start
    final startStr = start.toString();
    if (startStr.length % 2 == 0) {
      //even
      final palindrom = startStr.toString();
      final palindromHalf = palindrom.substring(0, palindrom.length ~/ 2);
      final palindromOtherHalf = palindrom.substring(palindrom.length ~/ 2);

      int palindromHalfInt = int.parse(palindromHalf);
      final palindromOtherHalfInt = int.parse(palindromOtherHalf);

      if (palindromHalfInt < palindromOtherHalfInt) {
        palindromHalfInt++;
      }
      startRepeatHalfInt = palindromHalfInt;
    } else {
      // odd
      final palindrom = (pow(10, startStr.length)).toString();
      final palindromHalf = palindrom.substring(0, palindrom.length ~/ 2);

      startRepeatHalfInt = int.parse(palindromHalf);
    }

    // calc last palindrom smaller or equal to end
    final endStr = end.toString();
    if (endStr.length % 2 == 0) {
      //even
      final palindrom = endStr.toString();
      final palindromHalf = palindrom.substring(0, palindrom.length ~/ 2);
      final palindromOtherHalf = palindrom.substring(palindrom.length ~/ 2);

      int palindromHalfInt = int.parse(palindromHalf);
      final palindromOtherHalfInt = int.parse(palindromOtherHalf);

      if (palindromHalfInt > palindromOtherHalfInt) {
        palindromHalfInt--;
      }
      endRepeatHalfInt = palindromHalfInt;
    } else {
      // odd

      final palindrom = (pow(10, endStr.length - 1) - 1).toString();
      final palindromHalf = palindrom.substring(0, palindrom.length ~/ 2);

      endRepeatHalfInt = int.parse(palindromHalf);
    }
    print(
      "$startRepeatHalfInt$startRepeatHalfInt - $endRepeatHalfInt$endRepeatHalfInt, ${max(endRepeatHalfInt - startRepeatHalfInt, -1) + 1}",
      true,
    );

    for (var i = startRepeatHalfInt; i <= endRepeatHalfInt; i++) {
      result += int.parse("$i$i");
    }
  }
  //
  printTodo();
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;

  printTodo();
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(2, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 1227775554)]);
  // day.runPart(2, part2, [Pair("example_input.txt", 0)]);
}
