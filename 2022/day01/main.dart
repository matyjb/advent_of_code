/*
 * https://adventofcode.com/2022/day/1
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<List<int>>;

Input parse(File file) {
  List<String> lines = file.readAsLinesSync();
  Input result = [[]];
  int currentElf = 0;
  for (String line in lines) {
    if(line.isEmpty) {
      // create new elf
      result.add([]);
      currentElf++;
    }else{
      result[currentElf].add(int.parse(line));
    }
  }
  return result;
}

int sum(int a, int b) => a+b;

void part1(Input input) {
  int result = input.fold(0,(maxValue, elf) => max(maxValue, elf.reduce(sum)));

  print("Most calories carried by one elf: ${answer(result)}");
}

void part2(Input input) {
  List<int> caloriesSums = input.map((elf) => elf.reduce(sum)).toList();
  caloriesSums.sort();
  int result = caloriesSums.sublist(caloriesSums.length-3).reduce(sum);

  print("Sum of top 3 elfs with most calories: ${answer(result)}");
}

void main(List<String> args) {
  Day day = Day(1, "input.txt", parse);
  day.runPart<Input>(1, part1);
  day.runPart<Input>(2, part2);
}