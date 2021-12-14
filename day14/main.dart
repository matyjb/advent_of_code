/*
 * https://adventofcode.com/2021/day/14
 */

import 'dart:io';

Map<String, int> countLettersPart1(String s) {
  Map<String, int> result = {};
  for (var i = 0; i < s.length; i++) {
    result.update(
      s[i],
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }
  return result;
}

void main(List<String> args) {
  List<String> lines = File("input.txt").readAsLinesSync();
  String template = lines[0];

  Map<String, String> rules = {
    for (var item in lines.skip(2))
      item.split(" -> ")[0]: item.split(" -> ")[1],
  };

  print("Template:     $template");
  print("\x1B[32m## Part 1 ##\x1B[0m");
  Map<String, String> rulesConcatSuffixes = {
    for (var r in rules.entries) r.key: r.value + r.key[1],
  };
  int maxSteps = 10;
  String currentPolymer = template;
  for (var step = 1; step <= maxSteps; step++) {
    StringBuffer polymer = StringBuffer();
    polymer.write(currentPolymer[0]);

    for (var i = 0; i < currentPolymer.length - 1; i++) {
      polymer.write(rulesConcatSuffixes[currentPolymer.substring(i, i + 2)]);
    }

    currentPolymer = polymer.toString();
    var countedLetters = countLettersPart1(currentPolymer);
    // print("After step $step: ${countedLetters}");
    if (step == maxSteps) {
      int max = countedLetters.values
          .fold(0, (max, element) => max < element ? element : max);
      int min = countedLetters.values
          .fold(max, (min, element) => min > element ? element : min);

      print("After step $step: $max - $min = \x1B[33m${max - min}\x1B[0m");
    }
  }

  print("\x1B[32m## Part 2 ##\x1B[0m");
  maxSteps = 40;
  Map<String, int> countedPairs = {};
  for (var i = 0; i < template.length - 1; i++) {
    countedPairs.update(
      template.substring(i, i + 2),
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }
  // print(countedPairs);
  for (var step = 1; step <= maxSteps; step++) {
    Map<String, int> tmp = {};
    for (var entry in countedPairs.entries) {
      if (rules.containsKey(entry.key)) {
        String pair1 = entry.key[0] + (rules[entry.key] ?? "");
        String pair2 = (rules[entry.key] ?? "") + entry.key[1];
        tmp.update(
          pair1,
          (value) => value + entry.value,
          ifAbsent: () => entry.value,
        );
        tmp.update(
          pair2,
          (value) => value + entry.value,
          ifAbsent: () => entry.value,
        );
      }
    }
    countedPairs = tmp;

    Map<String, int> countedLetters = {};
    for (var item in countedPairs.entries) {
      countedLetters.update(
        item.key[0],
        (value) => value + item.value,
        ifAbsent: () => item.value,
      );
      countedLetters.update(
        item.key[1],
        (value) => value + item.value,
        ifAbsent: () => item.value,
      );
    }

    countedLetters.update(template[0], (value) => value + 1);
    countedLetters.update(template[template.length - 1], (value) => value + 1);

    // print("After step $step: ${countedLetters}");

    if (step == maxSteps) {
      int max = countedLetters.values
          .fold(0, (max, element) => max < element ? element : max);
      int min = countedLetters.values
          .fold(max, (min, element) => min > element ? element : min);
      print(
          "After step $step: $max - $min = \x1B[33m${(max - min) ~/ 2}\x1B[0m");
    }
  }
}
