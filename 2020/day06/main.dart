/*
 * https://adventofcode.com/2020/day/6
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<List<String>>;

Input parse(File file) {
  return file
      .readAsStringSync()
      .split(RegExp(r'\n\s*\n', multiLine: true))
      .map(
        (e) => RegExp(r'\w+')
            .allMatches(e)
            .map((e) => e.group(0).toString())
            .toList(),
      )
      .toList();
}

int part1(Input input) {
  int sum = 0;
  for (var group in input) {
    Set<String> questions = {};
    for (var person in group) {
      questions.addAll(person.split(''));
    }
    sum += questions.length;
  }
  print("Sum of all questions: ${answer(sum)}");
  return sum;
}

int part2(Input input) {
  int sum = 0;
  for (var group in input) {
    Set<String> questions = {}..addAll(group.first.split(''));
    for (var person in group.skip(1)) {
      final q = person.split('');
      questions.retainWhere(q.contains);
    }
    sum += questions.length;
  }
  print("Sum of all questions with answer yes by everyone: ${answer(sum)}");
  return sum;
}

void main(List<String> args) {
  Day day = Day(6, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 11)]);
  day.runPart(2, part2, [Pair("example_input.txt", 6)]);
}
