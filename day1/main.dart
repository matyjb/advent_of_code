/*
 * https://adventofcode.com/2021/day/1
 */

import 'dart:io';

import '../day.dart';

List<int> parse(File file) {
  return file.readAsLinesSync().map((e) => int.parse(e)).toList();
}

void part1(List<int> measurements) {
  int result = 0;
  int prevMeasurement = measurements[0];
  for (var i = 1; i < measurements.length; i++) {
    int currentMeasurement = measurements[i];
    if(prevMeasurement < currentMeasurement)
      result++;
    
    prevMeasurement = currentMeasurement;
  }

  print("Number of measurement increases: ${answer(result)}");
}

void part2(List<int> measurements) {
  int result = 0;
  int prevMeasurement = measurements[0] + measurements[1] + measurements[2];
  for (var i = 1; i < measurements.length - 2; i++) {
    int currentMeasurement = measurements[i] + measurements[i + 1] + measurements[i + 2];
    if(prevMeasurement < currentMeasurement)
      result++;
    
    prevMeasurement = currentMeasurement;
  }
  print("Number of measurement increases: ${answer(result)}");
}

void main(List<String> args) {
  Day day = Day(1, "input.txt", parse);
  day.runPart<List<int>>(1, part1);
  day.runPart<List<int>>(2, part2);
}