/*
 * https://adventofcode.com/2022/day/21
 */

import 'dart:io';
import '../../day.dart';

class MonkeyOperation {
  final List<String> dependencies;
  final String? operation;
  final int? immedieteValue;

  MonkeyOperation({
    required this.dependencies,
    this.operation,
    this.immedieteValue,
  });

  int getValue(Map<String, MonkeyOperation> allMonkeys) {
    if (immedieteValue != null) return immedieteValue!;
    int val1 = allMonkeys[dependencies.first]!.getValue(allMonkeys);
    int val2 = allMonkeys[dependencies.last]!.getValue(allMonkeys);
    switch (operation) {
      case "+":
        return val1 + val2;
      case "-":
        return val1 - val2;
      case "*":
        return val1 * val2;
      case "/":
        return val1 ~/ val2;
      default:
        throw "Unimplemented operation $operation";
    }
  }
}

typedef Input = Map<String, MonkeyOperation>;

Input parse(File file) {
  RegExp monkeyWithValue = RegExp(r'(.+): (-?\d+)');
  RegExp monkeyWithOperation = RegExp(r'(.+): (.+) (.) (.+)');
  return Map.fromEntries(file.readAsLinesSync().map((e) {
    if (monkeyWithValue.hasMatch(e)) {
      var match = monkeyWithValue.firstMatch(e)!;
      String id = match.group(1)!;
      int value = int.parse(match.group(2)!);
      return MapEntry(
        id,
        MonkeyOperation(
          immedieteValue: value,
          dependencies: [],
        ),
      );
    } else {
      var match = monkeyWithOperation.firstMatch(e)!;
      String id = match.group(1)!;
      String dep1 = match.group(2)!;
      String dep2 = match.group(4)!;
      String operation = match.group(3)!;
      return MapEntry(
        id,
        MonkeyOperation(
          dependencies: [dep1, dep2],
          operation: operation,
        ),
      );
    }
  }));
}

int part1(Input input) {
  int result = input["root"]!.getValue(input);

  print("'root' value: ${answer(result)}");
  return result;
}

int part2(Input input) {
  // 1. znaleźć dfs'em w której gałęzi jest humn i wypluć ścieżkę
  // 2. dla drugiej gałęzi obliczyć value (expected value)
  // 3. podążając ścieżką wykonywać obliczenia odwrotnie i obliczać nowe expected value
  //    aż dojdziemy do humn
  List<String>? _findDfsPath(
    Map<String, MonkeyOperation> allMonkeys,
    String start,
    String end, [
    List<String>? currentPathStack,
  ]) {
    currentPathStack ??= [];
    currentPathStack.add(start);
    if (start == end) {
      return currentPathStack;
    }
    for (var dep in allMonkeys[start]!.dependencies) {
      var path = _findDfsPath(allMonkeys, dep, end, currentPathStack);
      if (path != null) return path;
    }
    currentPathStack.removeLast();
    return null;
  }

  // 1.
  String start = "root";
  String dep1 = input[start]!.dependencies.first;
  String dep2 = input[start]!.dependencies.last;

  List<String>? path1 = _findDfsPath(input, dep1, "humn");
  List<String>? path2 = _findDfsPath(input, dep2, "humn");

  // 2.
  int expectedValue = path1 != null
      ? input[dep2]!.getValue(input)
      : input[dep1]!.getValue(input);

  // 3.
  List<String> path = (path1 ?? path2)!;
  String parent = path.first;
  for (var p in path.skip(1)) {
    String op = input[parent]!.operation!;
    int otherValue = input[
            input[parent]!.dependencies.firstWhere((element) => element != p)]!
        .getValue(input);

    switch (op) {
      case "+":
        expectedValue -= otherValue;
        break;
      case "*":
        expectedValue ~/= otherValue;
        break;
      case "/":
        if (input[parent]!.dependencies.indexOf(p) == 0) {
          // expectedValue = x / otherValue
          // => x = expectedValue * otherValue
          expectedValue *= otherValue;
        } else {
          // expectedValue = otherValue / x;
          // => x = otherValue / expectedValue
          expectedValue = otherValue ~/ expectedValue;
        }
        break;
      case "-":
        if (input[parent]!.dependencies.indexOf(p) == 0) {
          // expectedValue = x - otherValue
          // => x = expectedValue + otherValue
          expectedValue += otherValue;
        } else {
          // expectedValue = otherValue - x;
          // => x = otherValue - expectedValue
          expectedValue = otherValue - expectedValue;
        }
        break;
      default:
    }

    parent = p;
  }

  int result = expectedValue;

  print("Expected value for 'humn': ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(21, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 152)]);
  day.runPart(2, part2, [Pair("example_input.txt", 301)]);
}
