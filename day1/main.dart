/*
 * https://adventofcode.com/2021/day/1
 */

import 'dart:io';

void main(List<String> args) {
  print("## Part 1 ##");
  int result = 0;
  List<int> measurements = File("input.txt").readAsLinesSync().map((e) => int.parse(e)).toList();

  int prevMeasurement = measurements[0];
  for (var i = 1; i < measurements.length; i++) {
    int currentMeasurement = measurements[i];
    if(prevMeasurement < currentMeasurement)
      result++;
    
    prevMeasurement = currentMeasurement;
  }

  print("Number of measurement increases: $result");

  print("## Part 2 ##");
  result = 0;
  prevMeasurement = measurements[0] + measurements[1] + measurements[2];
  for (var i = 1; i < measurements.length - 2; i++) {
    int currentMeasurement = measurements[i] + measurements[i + 1] + measurements[i + 2];
    if(prevMeasurement < currentMeasurement)
      result++;
    
    prevMeasurement = currentMeasurement;
  }
  print("Number of measurement increases: $result");
}