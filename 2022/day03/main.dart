/*
 * https://adventofcode.com/2022/day/3
 */

import 'dart:io';
import '../../day.dart';

typedef Rucksacks = List<String>;
final int lowerCaseLetterUnitStart = 'a'.codeUnitAt(0);
final int upperCaseLetterUnitStart = 'A'.codeUnitAt(0);

Rucksacks parse(File file) {
  return file.readAsLinesSync();
}

int getPriority(String character) {
  if(character.toUpperCase() == character) {
    return character.codeUnitAt(0)-upperCaseLetterUnitStart+1+26;
  }else{
    return character.codeUnitAt(0)-lowerCaseLetterUnitStart+1;
  }
}

int part1(Rucksacks input) {
  int result = 0;
  for (var r in input) {
    int halfIndex = r.length~/2;
    String firstHalf = r.substring(0, halfIndex);
    String secondHalf = r.substring(halfIndex);
    for (var i = 0; i < firstHalf.length; i++) {
      var character = firstHalf[i];
      if(secondHalf.contains(character)){
        result+=getPriority(character);
        break;
      }
    } 
  }
  print("Sum of all priorities: ${answer(result)}");
  return result;
}

int part2(Rucksacks input) {
  int result = 0;
  for (var groupIndex = 0; groupIndex < input.length~/3; groupIndex++) {
    int groupStartIndex = groupIndex*3;
    for (var i = 0; i < input[groupStartIndex].length; i++) {
      String character = input[groupStartIndex][i];
      if(input[groupStartIndex+1].contains(character) && input[groupStartIndex+2].contains(character)) {
        result += getPriority(character);
        break;
      }
    }
  }
  print("Sum of all priorities: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(3, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 157)]);
  day.runPart(2, part2, [Pair("example_input.txt", 70)]);
}