/*
 * https://adventofcode.com/2022/day/13
 */

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import '../../day.dart';

class Packet implements Comparable<Packet> {
  // values can be of type int or List
  List<dynamic> values;
  Packet(this.values);
  factory Packet.fromLine(String line) {
    return Packet(jsonDecode(line));
  }

  @override
  int compareTo(Packet other) {
    for (var i = 0; i < min(values.length, other.values.length); i++) {
      dynamic left = values[i];
      dynamic right = other.values[i];
      int cmp = 0;
      if (left is int && right is int) {
        cmp = left.compareTo(right);
      } else if (left is int && right is List) {
        Packet tmp = Packet([left]);
        cmp = tmp.compareTo(Packet(right));
      } else if (left is List && right is int) {
        Packet tmp = Packet([right]);
        cmp = Packet(left).compareTo(tmp);
      } else if (left is List && right is List) {
        cmp = Packet(left).compareTo(Packet(right));
      }
      if (cmp != 0) return cmp;
    }

    return values.length.compareTo(other.values.length);
  }
}

typedef Input = Iterable<Packet>;

Input parse(File file) {
  return file.readAsLinesSync().where((l) => l.isNotEmpty).map(Packet.fromLine);
}

Iterable<Pair<T, T>> getPairs<T extends Object>(Iterable<T> iterable) sync* {
  List stack = [];
  for (var element in iterable) {
    stack.add(element);
    if (stack.length == 2) {
      yield Pair(stack[0], stack[1]);
      stack.clear();
    }
  }
}

int part1(Input input) {
  int result = 0;
  int index = 1;
  for (Pair<Packet, Packet> pair in getPairs(input)) {
    if (pair.v0.compareTo(pair.v1) == -1) result += index;
    index++;
  }
  print("Packets out of order: ${answer(result)}");
  return result;
}

int part2(Input input) {
  Packet p2 = Packet.fromLine("[[2]]");
  Packet p6 = Packet.fromLine("[[6]]");

  List<Packet> allPackets = input.toList();
  allPackets.addAll([p2, p6]);

  allPackets.sort();

  int p2Index = allPackets.indexOf(p2) + 1;
  int p6Index = allPackets.indexOf(p6) + 1;
  int result = p2Index * p6Index;
  print("Deviders found on $p2Index*$p6Index = ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(13, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 13)]);
  day.runPart(2, part2, [Pair("example_input.txt", 140)]);
}
