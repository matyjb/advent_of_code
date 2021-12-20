/*
 * https://adventofcode.com/2021/day/19
 */

import 'dart:io';
import 'dart:math';
import '../day.dart';

class Vec3 {
  int x, y, z;
  Vec3([this.x = 0, this.y = 0, this.z = 0]);

  double distance(Vec3 other) {
    int dx = x - other.x;
    int dy = y - other.y;
    int dz = z - other.z;
    return sqrt(dx * dx + dy * dy + dz * dz);
  }
}

typedef Scanners = List<List<Vec3>>;

List<String> parse(File file) {
  return file.readAsLinesSync();
}

void part1(List<String> numbers) {
  printTodo();
}

void part2(List<String> numbers) {
  printTodo();
}

void main(List<String> args) {
  Day day = Day<List<String>>(19, "input.txt", parse);
  day.runPart<List<String>>(1, part1);
  day.runPart<List<String>>(2, part2);
}
