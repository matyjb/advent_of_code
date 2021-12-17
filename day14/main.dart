/*
 * https://adventofcode.com/2021/day/14
 */

import 'dart:io';

import '../day.dart';

class Input {
  String template;
  Map<String, String> rules;

  Input(this.template, this.rules);

  @override
  String toString() {
    return "Template: $template, rules: ${rules.length}";
  }
}

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

Input parse(File file) {
  List<String> lines = file.readAsLinesSync();
  String template = lines[0];

  Map<String, String> rules = {
    for (var item in lines.skip(2))
      item.split(" -> ")[0]: item.split(" -> ")[1],
  };

  return Input(template, rules);
}

void part1(Input input){
  Map<String, String> rulesConcatSuffixes = {
    for (var r in input.rules.entries) r.key: r.value + r.key[1],
  };
  int maxSteps = 10;
  String currentPolymer = input.template;
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

      print("After step $step: $max - $min = ${answer(max - min)}");
    }
  }
}

void part2(Input input){
  int maxSteps = 40;
  Map<String, int> countedPairs = {};
  for (var i = 0; i < input.template.length - 1; i++) {
    countedPairs.update(
      input.template.substring(i, i + 2),
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }
  // print(countedPairs);
  for (var step = 1; step <= maxSteps; step++) {
    Map<String, int> tmp = {};
    for (var entry in countedPairs.entries) {
      if (input.rules.containsKey(entry.key)) {
        String pair1 = entry.key[0] + (input.rules[entry.key] ?? "");
        String pair2 = (input.rules[entry.key] ?? "") + entry.key[1];
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

    countedLetters.update(input.template[0], (value) => value + 1);
    countedLetters.update(input.template[input.template.length - 1], (value) => value + 1);

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

void main(List<String> args) {
  Day day = Day<Input>(14, "input.txt", parse);
  day.runPart<Input>(1,part1);
  day.runPart<Input>(2,part2);
}
