/*
 * https://adventofcode.com/2021/day/8
 */

import 'dart:io';
import '../../day.dart';

String sortPattern(String pattern) {
  var tmp = pattern.split("");
  tmp.sort();
  return tmp.join();
}

class Display {
  final List<String> uniqueSignalPatters;
  final List<String> fourDigitOutput;

  Display(this.uniqueSignalPatters, this.fourDigitOutput);

  factory Display.fromLine(String line) {
    List<String> tmp = line.split(" | ");
    return Display(tmp[0].split(" "), tmp[1].split(" "));
  }

  List<String> deducePatterns() {
    List<String> knownPatters = List.generate(10, (_) => "");
    // init all known patters
    for (var digit in {1: 2, 4: 4, 7: 3, 8: 7}.entries) {
      knownPatters[digit.key] = uniqueSignalPatters
          .where((element) => digit.value == element.length)
          .toList()
          .first;
    }
    List<String> sixSegmentsPatters =
        uniqueSignalPatters.where((element) => 6 == element.length).toList();
    List<String> fiveSegmentsPatters =
        uniqueSignalPatters.where((element) => 5 == element.length).toList();

    int countOverLappingSegments(String pattern0, String pattern1) {
      int counter = 0;
      for (var l in pattern1.split("")) {
        if (pattern0.contains(l)) counter++;
      }
      return counter;
    }

    // deduce 6
    for (var s in sixSegmentsPatters) {
      // only one of them does not contain number 1 all segments
      if (countOverLappingSegments(s, knownPatters[1]) == 1) {
        knownPatters[6] = s;
        break;
      }
    }
    sixSegmentsPatters.remove(knownPatters[6]);

    // deduce 3
    for (var s in fiveSegmentsPatters) {
      // only one of them does contain number 1 all segments
      if (countOverLappingSegments(s, knownPatters[1]) == 2) {
        knownPatters[3] = s;
        break;
      }
    }
    fiveSegmentsPatters.remove(knownPatters[3]);

    // deduce 0 and 9 by counting overlap with 4
    // 0 and 4 has 3 segments overlapped
    // 9 and 4 has 4 segments overlapped
    for (var s in sixSegmentsPatters) {
      int overLappingSegments = countOverLappingSegments(s, knownPatters[4]);
      if (overLappingSegments == 3) {
        knownPatters[0] = s;
      } else if (overLappingSegments == 4) {
        knownPatters[9] = s;
      }
    }
    // sixSegmentsPatters.remove(knownPatters[0]);
    // sixSegmentsPatters.remove(knownPatters[9]);
    // six segments digits done

    // deduce 2 and 5 by counting overlap with 4
    // 2 and 4 has 2 segments overlapped
    // 5 and 4 has 3 segments overlapped
    for (var s in fiveSegmentsPatters) {
      int overLappingSegments = countOverLappingSegments(s, knownPatters[4]);
      if (overLappingSegments == 2) {
        knownPatters[2] = s;
      } else if (overLappingSegments == 3) {
        knownPatters[5] = s;
      }
    }
    // fiveSegmentsPatters.remove(knownPatters[2]);
    // fiveSegmentsPatters.remove(knownPatters[5]);
    // all numbers done
    return knownPatters;
  }

  int decodeOutput() {
    String digits = "";
    List<String> knownPatters = deducePatterns();
    // sort everything for easier comparison
    knownPatters = knownPatters.map((e) => sortPattern(e)).toList();
    for (var outputDigitPattern in this.fourDigitOutput) {
      digits +=
          knownPatters.indexOf(sortPattern(outputDigitPattern)).toString();
    }
    return int.parse(digits);
  }
}

List<Display> parse(File file) {
  return file.readAsLinesSync().map((line) => Display.fromLine(line)).toList();
}

void part1(List<Display> puzzleInputs) {
  int output1478sum = 0;
  puzzleInputs.forEach((puzzle) {
    puzzle.fourDigitOutput.forEach((element) {
      if ([2, 4, 3, 7].contains(element.length)) output1478sum++;
    });
  });
  print("Count of 1 4 7 8 in output signals: ${answer(output1478sum)}");
}

void part2(List<Display> puzzleInputs) {
  int sumOfAllDeducedOutputs =
      puzzleInputs.fold<int>(0, (sum, element) => sum + element.decodeOutput());
  print("Sum of all deduced outputs: ${answer(sumOfAllDeducedOutputs)}");
}

void main(List<String> args) {
  Day day = Day(8, "input.txt", parse);
  day.runPart<List<Display>>(1, part1);
  day.runPart<List<Display>>(2, part2);
}
