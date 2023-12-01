/*
 * https://adventofcode.com/2020/day/5
 */

import 'dart:io';
import 'dart:math';
import 'package:collection/collection.dart';

import '../../day.dart';

typedef Input = List<String>;

Input parse(File file) {
  return file.readAsLinesSync();
}

int calcID(String pass) {
  int lowRow = 0, highRow = 128;
  int lowCol = 0, highCol = 8;
  for (var i = 0; i < pass.length; i++) {
    switch (pass[i]) {
      case "B":
        lowRow = (lowRow + highRow) ~/ 2;
        break;
      case "F":
        highRow = (lowRow + highRow) ~/ 2;
        break;
      case "R":
        lowCol = (lowCol + highCol) ~/ 2;
        break;
      case "L":
        highCol = (lowCol + highCol) ~/ 2;
        break;
    }
  }
  return lowRow * 8 + lowCol;
}

int part1(Input input) {
  int maxID = input.fold(0, (maxID, pass) => max(maxID, calcID(pass)));
  print("Maximum seat ID: ${answer(maxID)}");
  return maxID;
}

int part2(Input input) {
  HeapPriorityQueue<int> pq = HeapPriorityQueue();
  for (var pass in input) {
    pq.add(calcID(pass));
  }
  int last = pq.removeFirst();
  while (pq.isNotEmpty) {
    final next = pq.removeFirst();
    if(next - last >= 2) {
      int result = last + 1;
      print("Missing seat ID: ${answer(result)}");
      return result;
    }
    last = next;
  }
  throw "All seats occupied";
}

void main(List<String> args) {
  Day day = Day(5, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 820)]);
  day.runPart(2, part2, []);
}
