/*
 * https://adventofcode.com/2023/day/19
 */

import 'dart:io';
import '../../day.dart';

typedef PartRating = Map<String, int>;
typedef WorkFlows = Map<String, List<String? Function(PartRating)>>;

typedef Input = ({List<PartRating> parts, WorkFlows workFlows});

Input parse(File file) {
  RegExp ruleRe =
      RegExp(r'(?<property>[xmas])(?<sign>[<>])(?<value>\d+):(?<next>.+)');
  RegExp workflowRe = RegExp(r'(?<name>.+){(?<rules>.+)}');
  RegExp rule2Re = RegExp(r'(?<property>[xmas])=(?<value>\d+)');
  final lines = file.readAsLinesSync();
  List<PartRating> parts = [];
  WorkFlows workFlows = {};
  for (var line in lines) {
    if (line.isNotEmpty) {
      if (line.startsWith("{")) {
        // part rating
        parts.add(PartRating.fromEntries(line.split(",").map((e) {
          final m = rule2Re.firstMatch(e)!;
          final prop = m.namedGroup("property")!;
          final value = int.parse(m.namedGroup("value")!);
          return MapEntry(prop, value);
        })));
      } else {
        // workflow
        final match = workflowRe.firstMatch(line)!;
        final name = match.namedGroup("name")!;
        final rules = match.namedGroup("rules")!.split(",").map((e) {
          if (ruleRe.hasMatch(e)) {
            final m = ruleRe.firstMatch(e)!;
            final prop = m.namedGroup("property")!;
            final sign = m.namedGroup("sign")!;
            final next = m.namedGroup("next")!;
            final value = int.parse(m.namedGroup("value")!);
            return (PartRating p) {
              if (sign == "<") {
                return (p[prop] ?? 0) < value ? next : null;
              } else {
                return (p[prop] ?? 0) > value ? next : null;
              }
            };
          } else {
            return (PartRating p) => e;
          }
        });
        workFlows[name] = rules.toList();
      }
    }
  }
  return (parts: parts, workFlows: workFlows);
}

int part1(Input input) {
  int result = 0;
  List<(PartRating, String)> parts = input.parts.map((e) => (e, "in")).toList();
  while (parts.isNotEmpty) {
    final current = parts.removeAt(0);
    // apply workflow
    String? next;
    int i = 0;
    do {
      next = input.workFlows[current.$2]![i](current.$1);
      i++;
    } while (next == null);

    if(next == "A") {
      result += current.$1.values.sum() as int;
    }else if(next != "R") {
      parts.add((current.$1, next));
    }
  }
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
  Day day = Day(19, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 19114)]);
  day.runPart(2, part2, [Pair("example_input.txt", 167409079868000)]);
}
