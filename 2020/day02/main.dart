/*
 * https://adventofcode.com/2020/day/2
 */

import 'dart:io';
import '../../day.dart';

typedef Password = ({int min, int max, String letter, String password});
typedef Input = Iterable<Password>;

extension PasswordExtension on Password {
  bool isValid1() {
    int count = this.letter.allMatches(this.password).length;
    return count >= this.min && count <= this.max;
  }

  bool isValid2() {
    return (password[min-1] == letter) ^ (password[max-1] == letter);
  }
}

Input parse(File file) {
  final r = RegExp(r'(\d+)-(\d+) (.+): (.+)');
  return file.readAsLinesSync().map((e) {
    final x = r.firstMatch(e)!;
    return (
      min: int.parse(x.group(1)!),
      max: int.parse(x.group(2)!),
      letter: x.group(3)!,
      password: x.group(4)!,
    );
  });
}

int part1(Input input) {
  int result = input.fold(
    0,
    (count, element) => element.isValid1() ? count + 1 : count,
  );
  print("Valid passwords: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = input.fold(
    0,
    (count, element) => element.isValid2() ? count + 1 : count,
  );
  print("Valid passwords: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(2, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 2)]);
  day.runPart(2, part2, [Pair("example_input.txt", 1)]);
}
