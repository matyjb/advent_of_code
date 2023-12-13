/*
 * https://adventofcode.com/2023/day/12
 */

import 'dart:io';
import '../../day.dart';

typedef Spring = ({String format1, List<int> format2});
typedef Input = List<Spring>;

Input parse(File file) {
  final format1Re = RegExp(r'[\?\.#]+');
  final numbersRe = RegExp(r'\d+');

  return file.readAsLinesSync().map((e) {
    final format1 = format1Re.firstMatch(e)!.group(0)!;
    final format2 =
        numbersRe.allMatches(e).map((e) => int.parse(e.group(0)!)).toList();

    return (format1: format1, format2: format2);
  }).toList();
}

int countSeqs(
  Spring spring, [
  String prev = ".",
  int i = 0,
  List<int>? format2tilli,
]) {
  format2tilli ??= [];
  // check if format2tilli is correct
  if (i >= spring.format1.length) {
    if (spring.format2.isEqualTo(format2tilli)) {
      return 1;
    } else {
      return 0;
    }
  } else {
    if (!spring.format2.startsWith(format2tilli, format2tilli.length - 1) ||
        (format2tilli.isNotEmpty &&
            spring.format2[format2tilli.length - 1] < format2tilli.last)) {
      return 0;
    }
  }

  //correct sequence
  if (i >= spring.format1.length) {
    return 1;
  }

  // start checking next
  final current = spring.format1[i];

  int result = 0;

  switch ((prev, current)) {
    case (".", "."):
      result += countSeqs(spring, ".", i + 1, format2tilli);
      break;
    case (".", "#"):
      format2tilli.add(1);
      result += countSeqs(spring, "#", i + 1, format2tilli);
      format2tilli.removeLast();
      break;
    case (".", "?"):
      format2tilli.add(1);
      result += countSeqs(spring, "#", i + 1, format2tilli);
      format2tilli.removeLast();
      result += countSeqs(spring, ".", i + 1, format2tilli);
      break;
    case ("#", "."):
      result += countSeqs(spring, ".", i + 1, format2tilli);
      break;
    case ("#", "#"):
      format2tilli[format2tilli.length - 1]++;
      result += countSeqs(spring, "#", i + 1, format2tilli);
      format2tilli[format2tilli.length - 1]--;
      break;
    case ("#", "?"):
      format2tilli[format2tilli.length - 1]++;
      result += countSeqs(spring, "#", i + 1, format2tilli);
      format2tilli[format2tilli.length - 1]--;
      result += countSeqs(spring, ".", i + 1, format2tilli);
      break;
  }
  return result;
}

int part1(Input input) {
  // int result = countSeqs(input[1]);
  int result = input.fold(0, (sum, spring) => sum + countSeqs(spring));
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
  Day day = Day(12, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 21)]);
  day.runPart(2, part2, [Pair("example_input.txt", 525152)]);
}
