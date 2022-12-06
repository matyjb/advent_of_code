/*
 * https://adventofcode.com/2022/day/6
 */

import 'dart:io';
import '../../day.dart';

typedef Input = String;

Input parse(File file) {
  return file.readAsLinesSync().first;
}

bool isListItemsUnique(List<String> list) {
  for (var i = 0; i < list.length-1; i++) {
    for (var j = i+1; j < list.length; j++) {
      if(list[i] == list[j])
        return false;
    }
  }
  return true;
}

int searchForUniqueSubstringChars(String input,int bufferLen) {
  List<String> lettersBuffer = [];
  for (var i = 0; i < input.length; i++) {
    if(lettersBuffer.length >= bufferLen)
      lettersBuffer.removeAt(0);
    lettersBuffer.add(input[i]);
    if(lettersBuffer.length == bufferLen && isListItemsUnique(lettersBuffer)) {
      return i+1;
    }
  }
  return -1;
}

int part1(Input input) {
  int result = searchForUniqueSubstringChars(input, 4);
  print("First start-of-packet marker after character: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = searchForUniqueSubstringChars(input, 14);
  print("First start-of-message marker after character: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(6, "input.txt", parse);
  day.runPart(1, part1, [
    Pair("example_input_1.txt", 7),
    Pair("example_input_2.txt", 5),
    Pair("example_input_3.txt", 6),
    Pair("example_input_4.txt", 10),
    Pair("example_input_5.txt", 11),
  ]);
  day.runPart(2, part2, [
    Pair("example_input_1.txt", 19),
    Pair("example_input_2.txt", 23),
    Pair("example_input_3.txt", 23),
    Pair("example_input_4.txt", 29),
    Pair("example_input_5.txt", 26),
  ]);
}
