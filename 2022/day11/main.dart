/*
 * https://adventofcode.com/2022/day/11
 */

import 'dart:io';
import '../../day.dart';

class Monkey {
  final int id;
  List<int> items;
  final int Function(int) operation;
  final int testDivBy;
  final int ifTrueThrowTo;
  final int ifFalseThrowTo;

  Monkey(
    this.id,
    this.items,
    this.operation,
    this.testDivBy,
    this.ifTrueThrowTo,
    this.ifFalseThrowTo,
  );

  @override
  String toString() {
    return """
Monkey $id:
  Items: ${items.join(", ")}
  Test: divisible by $testDivBy
    If true: throw to monkey $ifTrueThrowTo
    If false: throw to monkey $ifFalseThrowTo"
    """;
  }
}

typedef Input = List<Monkey>;

Input parse(File file) {
  List<String> lines = file.readAsLinesSync()
    ..removeWhere((element) => element.isEmpty);
  List<int> ids = lines.where((element) {
    return element.trim().startsWith('Monkey ');
  }).map((e) {
    String num = RegExp(r'\d+').allMatches(e).first.group(0)!;
    return int.parse(num);
  }).toList();
  List<List<int>> items = lines
      .where((element) => element.trim().startsWith('Starting items: '))
      .map((e) => RegExp(r'\d+')
          .allMatches(e)
          .map((e) => int.parse(e.group(0)!))
          .toList())
      .toList();
  List<int Function(int)> operations = lines
      .where((element) => element.trim().startsWith('Operation: '))
      .map((e) {
    var matchesAdd = RegExp(r'new = old \+ \d+').allMatches(e);
    var matchesTimes = RegExp(r'new = old \* \d+').allMatches(e);
    var matchesSquare = RegExp(r'new = old \* old').allMatches(e);
    if (matchesAdd.isNotEmpty) {
      String add = matchesAdd.first.group(0)!;
      return (int arg) =>
          arg + int.parse(RegExp(r'\d+').allMatches(add).first.group(0)!);
    } else if (matchesSquare.isNotEmpty) {
      return (int arg) => arg * arg;
    } else if (matchesTimes.isNotEmpty) {
      String times = matchesTimes.first.group(0)!;
      return (int arg) =>
          arg * int.parse(RegExp(r'\d+').allMatches(times).first.group(0)!);
    } else {
      return (int arg) => arg;
    }
  }).toList();
  List<int> divBy = lines
      .where((element) => element.trim().startsWith('Test: divisible by '))
      .map((e) => int.parse(RegExp(r'\d+').allMatches(e).first.group(0)!))
      .toList();
  List<int> ifTrueThrowTo = lines
      .where(
          (element) => element.trim().startsWith('If true: throw to monkey '))
      .map((e) => int.parse(RegExp(r'\d+').allMatches(e).first.group(0)!))
      .toList();
  List<int> ifFalseThrowTo = lines
      .where(
          (element) => element.trim().startsWith('If false: throw to monkey '))
      .map((e) => int.parse(RegExp(r'\d+').allMatches(e).first.group(0)!))
      .toList();

  return ids
      .map(
        (e) => Monkey(e, items[e], operations[e], divBy[e], ifTrueThrowTo[e],
            ifFalseThrowTo[e]),
      )
      .toList()
    ..sort((a, b) => a.id.compareTo(b.id));
}

void simulateRound(
  Input monkeys,
  List<int> inspections,
  int Function(int) newWorryLvlDecorator,
) {
  for (var monkeyId = 0; monkeyId < monkeys.length; monkeyId++) {
    // each monkey throws its items
    Monkey monkey = monkeys[monkeyId];
    for (var item in monkey.items) {
      inspections[monkeyId]++;
      // calc new worry level for the item and apply decorator
      // in part1 the decorator divides by 3
      // in part2 the decorator divides by multiplication of all test division value
      // - this way we preserve information about divisibility for all the monkeys
      // - and dont go into huge numbers
      int newWorryLvlItem = newWorryLvlDecorator(monkey.operation(item));
      monkeys[newWorryLvlItem % monkey.testDivBy == 0
              ? monkey.ifTrueThrowTo
              : monkey.ifFalseThrowTo]
          .items
          .add(newWorryLvlItem);
    }
    // all items have been thrown, this monkey no longer have any items
    monkey.items.clear();
  }
}

int part1(Input input) {
  List<int> inspections = List.filled(input.length, 0);

  for (var round = 0; round < 20; round++) {
    simulateRound(input, inspections, (p0) => p0 ~/ 3);
  }
  inspections.sort();

  int result = inspections.last * inspections[inspections.length - 2];
  print("The level of monkey business: ${answer(result)}");
  return result;
}

int part2(Input input) {
  List<int> inspections = List.filled(input.length, 0);
  // multiplies values in "Test: divisible by X" line
  // in example its equal to 23*19*13*17
  int maxWorryLvl = input
      .map((e) => e.testDivBy)
      .reduce((value, testDivBy) => value * testDivBy);

  for (var round = 0; round < 10000; round++) {
    simulateRound(input, inspections, (p0) => p0 % maxWorryLvl);
  }
  inspections.sort();

  int result = inspections.last * inspections[inspections.length - 2];
  print("The level of monkey business: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(11, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 10605)]);
  day.runPart(2, part2, [Pair("example_input.txt", 2713310158)]);
}
