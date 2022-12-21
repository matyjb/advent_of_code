/*
 * https://adventofcode.com/2022/day/21
 */

import 'dart:io';
import '../../day.dart';

typedef Monkeys = Map<String, MonkeyYells>;

class MonkeyYells {
  final List<String> dependencies;
  final String? operation;
  final int? immedieteValue;

  MonkeyYells._({
    required this.dependencies,
    this.operation,
    this.immedieteValue,
  });

  MonkeyYells.value(int value)
      : this._(dependencies: [], immedieteValue: value);

  MonkeyYells.operation(String dep1, String operation, String dep2)
      : this._(dependencies: [dep1, dep2], operation: operation);

  int yell(Monkeys allMonkeys) {
    if (immedieteValue != null) return immedieteValue!;
    int val1 = allMonkeys[dependencies.first]!.yell(allMonkeys);
    int val2 = allMonkeys[dependencies.last]!.yell(allMonkeys);
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

Monkeys parse(File file) {
  RegExp monkeyWithValue = RegExp(r'(.+): (-?\d+)');
  RegExp monkeyWithOperation = RegExp(r'(.+): (.+) (.) (.+)');
  return Map.fromEntries(file.readAsLinesSync().map((e) {
    if (monkeyWithValue.hasMatch(e)) {
      var match = monkeyWithValue.firstMatch(e)!;
      String id = match.group(1)!;
      int value = int.parse(match.group(2)!);
      return MapEntry(
        id,
        MonkeyYells.value(value),
      );
    } else {
      var match = monkeyWithOperation.firstMatch(e)!;
      String id = match.group(1)!;
      String dep1 = match.group(2)!;
      String dep2 = match.group(4)!;
      String operation = match.group(3)!;
      return MapEntry(
        id,
        MonkeyYells.operation(dep1, operation, dep2),
      );
    }
  }));
}

int part1(Monkeys input) {
  int result = input["root"]!.yell(input);

  print("'root' value: ${answer(result)}");
  return result;
}

int part2(Monkeys input) {
  // 1. znaleźć dfs'em w której gałęzi jest humn i wypluć ścieżkę
  // 2. dla drugiej gałęzi obliczyć value (expected value)
  // 3. podążając ścieżką wykonywać obliczenia odwrotnie i obliczać nowe expected value
  //    aż dojdziemy do humn
  List<String>? _findDfsPath(
    Monkeys allMonkeys,
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
  String end = "humn";
  String dep1 = input[start]!.dependencies.first;
  String dep2 = input[start]!.dependencies.last;

  List<String>? path1 = _findDfsPath(input, dep1, end);
  List<String>? path2 = _findDfsPath(input, dep2, end);

  // 2.
  int expectedValue =
      path1 != null ? input[dep2]!.yell(input) : input[dep1]!.yell(input);

  // 3.
  List<String> path = (path1 ?? path2)!;
  MonkeyYells parentMonkey = input[path.first]!;
  for (var pathMonkey in path.skip(1)) {
    String op = parentMonkey.operation!;
    int otherMonkeyValue =
        input[parentMonkey.dependencies.firstWhere((dep) => dep != pathMonkey)]!
            .yell(input);

    switch (op) {
      case "+":
        expectedValue -= otherMonkeyValue;
        break;
      case "*":
        expectedValue ~/= otherMonkeyValue;
        break;
      case "/":
        if (parentMonkey.dependencies.indexOf(pathMonkey) == 0) {
          // expectedValue = x / otherValue
          // => x = expectedValue * otherValue
          expectedValue *= otherMonkeyValue;
        } else {
          // expectedValue = otherValue / x;
          // => x = otherValue / expectedValue
          expectedValue = otherMonkeyValue ~/ expectedValue;
        }
        break;
      case "-":
        if (parentMonkey.dependencies.indexOf(pathMonkey) == 0) {
          // expectedValue = x - otherValue
          // => x = expectedValue + otherValue
          expectedValue += otherMonkeyValue;
        } else {
          // expectedValue = otherValue - x;
          // => x = otherValue - expectedValue
          expectedValue = otherMonkeyValue - expectedValue;
        }
        break;
      default:
        throw "Unimplemented inverse operation $op";
    }

    parentMonkey = input[pathMonkey]!;
  }

  int result = expectedValue;

  print("Expected value for '$end': ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(21, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 152)]);
  day.runPart(2, part2, [Pair("example_input.txt", 301)]);
}
