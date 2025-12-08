/*
 * https://adventofcode.com/2025/day/8
 */

import 'dart:collection';
import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef JunctionBox = ({int x, int y, int z});
typedef Input = List<JunctionBox>;

Input parse(File file) {
  return file.readAsLinesSync().map((e) {
    final parts = e.split(',');
    return (
      x: int.parse(parts[0]),
      y: int.parse(parts[1]),
      z: int.parse(parts[2]),
    );
  }).toList();
}

int part1(Input input, int maxConnections) {
  final distances = HashMap<(JunctionBox, JunctionBox), double>.fromIterable(
    input.expand((a) {
      final aIdx = input.indexOf(a);
      return input.skip(aIdx + 1).map((b) => (a, b));
    }),
    key: (pair) => pair,
    value: (pair) {
      final (a, b) = pair!;
      final dx = a.x - b.x;
      final dy = a.y - b.y;
      final dz = a.z - b.z;
      return sqrt(dx * dx + dy * dy + dz * dz);
    },
  );

  final circuits = List<HashSet<JunctionBox>>.empty(growable: true);
  for (final closestsPair
      in distances.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value))) {
    final (a, b) = closestsPair.key;

    final circuitA = circuits
        .where((circuit) => circuit.contains(a))
        .firstOrNull;
    final circuitB = circuits
        .where((circuit) => circuit.contains(b))
        .firstOrNull;

    if (circuitA == null && circuitB == null) {
      final newCircuit = HashSet<JunctionBox>()
        ..add(a)
        ..add(b);
      circuits.add(newCircuit);
    } else if (circuitA != null && circuitB == null) {
      circuitA.add(b);
    } else if (circuitA == null && circuitB != null) {
      circuitB.add(a);
    } else if (circuitA != circuitB) {
      circuitA!.addAll(circuitB!);
      circuits.remove(circuitB);
    }
    maxConnections--;

    if (maxConnections <= 0) {
      break;
    }
  }

  final circuitSizes = circuits.map((c) => c.length).toList();
  final threeLargestSizes = (circuitSizes..sort((a, b) => b.compareTo(a)))
      .take(3)
      .toList();

  int result = threeLargestSizes.multiply();

  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

int part2(Input input) {
  final distances = HashMap<(JunctionBox, JunctionBox), double>.fromIterable(
    input.expand((a) {
      final aIdx = input.indexOf(a);
      return input.skip(aIdx + 1).map((b) => (a, b));
    }),
    key: (pair) => pair,
    value: (pair) {
      final (a, b) = pair!;
      final dx = a.x - b.x;
      final dy = a.y - b.y;
      final dz = a.z - b.z;
      return sqrt(dx * dx + dy * dy + dz * dz);
    },
  );

  final circuits = List<HashSet<JunctionBox>>.empty(growable: true);
  (JunctionBox, JunctionBox)? lastConnectionMade;
  for (final closestsPair
      in distances.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value))) {
    final (a, b) = closestsPair.key;

    final circuitA = circuits
        .where((circuit) => circuit.contains(a))
        .firstOrNull;
    final circuitB = circuits
        .where((circuit) => circuit.contains(b))
        .firstOrNull;

    if (circuitA == null && circuitB == null) {
      final newCircuit = HashSet<JunctionBox>()
        ..add(a)
        ..add(b);
      circuits.add(newCircuit);
      lastConnectionMade = closestsPair.key;
    } else if (circuitA != null && circuitB == null) {
      circuitA.add(b);
      lastConnectionMade = closestsPair.key;
    } else if (circuitA == null && circuitB != null) {
      circuitB.add(a);
      lastConnectionMade = closestsPair.key;
    } else if (circuitA != circuitB) {
      circuitA!.addAll(circuitB!);
      circuits.remove(circuitB);
      lastConnectionMade = closestsPair.key;
    }
  }

  print(lastConnectionMade, true);

  int result = lastConnectionMade!.$1.x * lastConnectionMade.$2.x;
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(8, "input.txt", parse);
  // day.runPart<Input>(1, (input) => part1(input, 10), [
  //   Pair("example_input.txt", 40),
  // ]);
  // day.runPart<Input>(1, (input) => part1(input, 1000), []);
  day.runPart(2, part2, [Pair("example_input.txt", 25272)]);
}
