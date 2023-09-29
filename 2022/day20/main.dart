/*
 * https://adventofcode.com/2022/day/20
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<int>;

Input parse(File file) {
  return file.readAsLinesSync().map(int.parse).toList();
}

void mix(List<int> numbers) {
  List<int> instructions = List.from(numbers);

  void moveToPos(int from, int to) {
    if (to != 0) {
      int number = numbers.removeAt(from);
      numbers.insert(to, number);
    } else {
      int number = numbers.removeAt(from);
      numbers.add(number);
    }
  }

  for (var ni in instructions) {
    int numberPosition = numbers.indexOf(ni);
    int destinationIndex =
        (numberPosition + ni + (numberPosition + ni) ~/ instructions.length) %
            instructions.length;
    if (numberPosition + ni < 0) destinationIndex -= 1;

    moveToPos(numberPosition, destinationIndex);
    print(numbers.join(", "), true);
  }
}

int part1(Input input) {
  mix(input);
  List<int> desiredNumbersIndexes = [1000, 2000, 3000];
  int result = desiredNumbersIndexes
      .map((e) => input[(e-2 + (e-2) ~/ input.length) % input.length])
      .reduce((v, e) => v + e);

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
  Day day = Day(20, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 3)]);
  day.runPart(2, part2, [Pair("example_input.txt", 0)]);
}
