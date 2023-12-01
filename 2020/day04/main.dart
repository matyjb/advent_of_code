/*
 * https://adventofcode.com/2020/day/4
 */

import 'dart:io';
import '../../day.dart';

typedef Passport = Map<String, String>;
typedef Input = List<Passport>;

Input parse(File file) {
  return file
      .readAsStringSync()
      .split(RegExp(r'\n\s*\n', multiLine: true))
      .map((e) => Map<String, String>.fromIterable(
            RegExp(r'(?<key>\S+):(?<value>\S+)').allMatches(e),
            key: (e) => (e as RegExpMatch).namedGroup("key")!,
            value: (e) => (e as RegExpMatch).namedGroup("value")!,
          ))
      .toList();
}

List<String> requiredFields = [
  "byr",
  "iyr",
  "eyr",
  "hgt",
  "hcl",
  "ecl",
  "pid",
  // "cid", // this one is optional
];
int part1(Input input) {
  int result = input.fold(
    0,
    (valid, passport) =>
        requiredFields.every((key) => passport.containsKey(key))
            ? valid + 1
            : valid,
  );
  print("Valid passports: ${answer(result)}");
  return result;
}

int part2(Input input) {
  _isIntBetween(String value, int min, int max) {
    final n = int.tryParse(value);
    return n == null ? false : n >= min && n <= max;
  }

  Map<String, bool Function(String)> validators = {
    "byr": (value) => _isIntBetween(value, 1920, 2002),
    "iyr": (value) => _isIntBetween(value, 2010, 2020),
    "eyr": (value) => _isIntBetween(value, 2020, 2030),
    "hgt": (value) {
      final match = RegExp(r'^(\d+)(cm|in)$').firstMatch(value);
      if (match == null) return false;
      final val = int.parse(match.group(1).toString());
      final unit = match.group(2).toString();
      return switch (unit) {
        "cm" => val >= 150 && val <= 193,
        "in" => val >= 59 && val <= 76,
        _ => false,
      };
    },
    "hcl": (value) => RegExp(r'^#[a-f0-9]{6}$').hasMatch(value),
    "ecl": (value) => RegExp(r'^amb|blu|brn|gry|grn|hzl|oth$').hasMatch(value),
    "pid": (value) => RegExp(r'^\d{9}$').hasMatch(value),
    "cid": (value) => true,
  };

  int result = input.fold(
    0,
    (valid, passport) => requiredFields.every(
      (key) => passport.containsKey(key) && validators[key]!(passport[key]!),
    )
        ? valid + 1
        : valid,
  );
  print("Valid passports: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(4, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 2)]);
  day.runPart(2, part2, []);
}
