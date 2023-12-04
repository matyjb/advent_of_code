/*
 * https://adventofcode.com/2023/day/3
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = List<String>;

Input parse(File file) {
  return file.readAsLinesSync();
}

int part1(Input input) {
  final symbolRe = RegExp(r'[^\.\d]');
  final numberRe = RegExp(r'\d+');
  _checkIfHasSymbol(String str, int start, int end) {
    return str.substring(start, end).contains(symbolRe);
  }

  int sum = 0;
  for (var i = 0; i < input.length; i++) {
    Iterable<RegExpMatch> numbers = numberRe.allMatches(input[i]).where((n) {
      // top with diagonals
      if (i > 0 &&
          _checkIfHasSymbol(input[i - 1], max(n.start - 1, 0),
              min(n.end + 1, input[i - 1].length))) return true;
      // bottom with diagonals
      if (i < input.length - 1 &&
          _checkIfHasSymbol(input[i + 1], max(n.start - 1, 0),
              min(n.end + 1, input[i + 1].length))) return true;
      // left
      if (n.start > 0 && _checkIfHasSymbol(input[i], n.start - 1, n.start))
        return true;
      // right
      if (n.end < input[i].length - 1 &&
          _checkIfHasSymbol(input[i], n.end, n.end + 1)) return true;

      return false;
    });

    sum += numbers.fold(0, (s, n) => s + int.parse(n.group(0)!));
  }
  print("Sum of all parts numbers: ${answer(sum)}");
  return sum;
}

int part2(Input input) {
  final gearSymbolRe = RegExp(r'\*');
  final numberRe = RegExp(r'\d+');

  _isOverlapping((int, int) section1, (int, int) section2) {
    return !(section1.$2 <= section2.$1 || section2.$2 <= section1.$1);
  }

  int sum = 0;
  for (var i = 0; i < input.length; i++) {
    // search for a gear
    final gearsMatched = gearSymbolRe.allMatches(input[i]);
    for (var gear in gearsMatched) {
      List<int> partsTouched = [];
      final topBottomWithDiagonal = (gear.start - 1, gear.end + 1);
      final left = (gear.start - 1, gear.start);
      final right = (gear.end, gear.end + 1);

      // top numbers
      if (i > 0) {
        partsTouched.addAll(
          numberRe
              .allMatches(input[i - 1])
              .where((n) =>
                  _isOverlapping(topBottomWithDiagonal, (n.start, n.end)))
              .map((e) => int.parse(e.group(0)!)),
        );
      }
      // bottom numbers
      if (i < input.length - 1) {
        partsTouched.addAll(
          numberRe
              .allMatches(input[i + 1])
              .where((n) =>
                  _isOverlapping(topBottomWithDiagonal, (n.start, n.end)))
              .map((e) => int.parse(e.group(0)!)),
        );
      }
      // left right
      partsTouched.addAll(
        numberRe
            .allMatches(input[i])
            .where((n) =>
                _isOverlapping(left, (n.start, n.end)) ||
                _isOverlapping(right, (n.start, n.end)))
            .map((e) => int.parse(e.group(0)!)),
      );

      if(partsTouched.length == 2) {
        sum += partsTouched[0] * partsTouched[1];
      }
    }
  }

  print("Sum of gear ratios: ${answer(sum)}");
  return sum;
}

void main(List<String> args) {
  Day day = Day(3, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 4361)]);
  day.runPart(2, part2, [Pair("example_input.txt", 467835)]);
}
