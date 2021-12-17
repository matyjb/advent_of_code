/*
 * https://adventofcode.com/2021/day/10
 */

import 'dart:io';
import '../day.dart';

typedef Lines = List<String>;

List<String> openingChars = ["(", "[", "{", "<"];
List<String> closingChars = [")", "]", "}", ">"];

Map<String, int> illegalCharacterScores = {
  ")": 3,
  "]": 57,
  "}": 1197,
  ">": 25137,
};

Map<String, int> incompleteCharacterScores = {
  "(": 1,
  "[": 2,
  "{": 3,
  "<": 4,
};

// return score
// 0 points line is ok
// else according to illegalCharacterScores
int checkSyntax(String line, List<String> charBufferStack,
    [bool printDebug = false]) {
  for (var i = 0; i < line.length; i++) {
    String currentChar = line[i];
    if (openingChars.contains(currentChar)) {
      charBufferStack.add(currentChar);
    } else if (closingChars.contains(currentChar)) {
      if (charBufferStack.length > 0) {
        String expectedCharacter =
            closingChars[openingChars.indexOf(charBufferStack.last)];
        if (expectedCharacter == currentChar) {
          // ok
          charBufferStack.removeLast();
        } else {
          // not ok
          if (printDebug)
            print(
              "Expected $expectedCharacter, but found $currentChar instead",
            );
          return illegalCharacterScores[currentChar]!;
        }
      } else {
        // new chunk but no opening character
        if (printDebug)
          print(
            "New chunk started with closing character $currentChar instead",
          );
        return illegalCharacterScores[currentChar]!;
      }
    }
  }

  // whole string done but maybe its incomplete
  if (charBufferStack.length > 0) {
    if (printDebug) print("Line is incomplete.");
    return 0;
  }

  return 0;
}

Lines parse(File file) {
  return file.readAsLinesSync();
}

void part1(Lines lines) {
  int sum = 0;
  for (var line in lines) {
    sum += checkSyntax(line, []);
  }
  print("Sum of scores for illegal lines: ${answer(sum)}");
}

void part2(Lines lines) {
  List<int> incompleteLinesRanking = [];
  for (var line in lines) {
    List<String> charbuffer = [];
    int isOk = checkSyntax(line, charbuffer);
    if (charbuffer.length > 0 && isOk == 0) {
      // line is incomplete
      // calc score
      int score = 0;
      for (var i = charbuffer.length - 1; i >= 0; i--) {
        score *= 5;
        score += incompleteCharacterScores[charbuffer[i]]!;
      }
      incompleteLinesRanking.add(score);
    }
  }
  incompleteLinesRanking.sort();
  int middleIndex = incompleteLinesRanking.length ~/ 2;
  print(
    "Middle value of incomplete lines scores: ${answer(incompleteLinesRanking[middleIndex])}",
  );
}

void main(List<String> args) {
  Day day = Day(10, "input.txt", parse);
  day.runPart<Lines>(1, part1);
  day.runPart<Lines>(2, part2);
}
