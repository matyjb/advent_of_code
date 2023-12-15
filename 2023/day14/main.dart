/*
 * https://adventofcode.com/2023/day/14
 */

import 'dart:collection';
import 'dart:io';
import '../../day.dart';

typedef Input = List<String>;

Input parse(File file) {
  return file.readAsLinesSync();
}

printWorld(HashSet<(int, int)> world, List<(int, int)> reflectors, int rows,
    int cols) {
  for (var row = 0; row < rows; row++) {
    StringBuffer line = StringBuffer();
    for (var col = 0; col < cols; col++) {
      line.write(switch ((
        world.contains((row, col)),
        reflectors.contains((row, col))
      )) {
        (true, true) => "O",
        (true, false) => "#",
        _ => "."
      });
    }
    print(line.toString(), true);
    line.clear();
  }
}

int part1(Input input) {
  int result = 0;
  for (int col = 0; col < input.first.length; col++) {
    int countEmptyAbove = 0;
    for (int row = 0; row < input.length; row++) {
      final char = input[row][col];
      switch (char) {
        case ".":
          countEmptyAbove++;
          break;
        case "O":
          final destinationRow = row - countEmptyAbove;
          final load = input.length - destinationRow;
          result += load;
          break;
        case "#":
          countEmptyAbove = 0;
          break;
        default:
      }
    }
  }

  print("Final load: ${answer(result)}");
  return result;
}

int part2(Input input) {
  List<(int, int)> reflectors = [];
  HashSet<(int, int)> world = HashSet();
  // create world
  for (var row = 0; row < input.length; row++) {
    for (var col = 0; col < input.first.length; col++) {
      final char = input[row][col];
      switch (char) {
        case "O":
          reflectors.add((row, col));
          world.add((row, col));
          break;
        case "#":
          world.add((row, col));
          break;
        default:
      }
    }
  }
  _calcLoad() {
    return reflectors.fold(
      0,
      (load, reflector) => input.length - reflector.$1 + load,
    );
  }

  _move(
      {required int Function((int, int), (int, int)) sortCompare,
      required (int, int) Function((int, int)) getNextPos,
      required bool Function((int, int)) checkNext}) {
    reflectors.sort(sortCompare);
    int reflectorsToMove = reflectors.length;
    while (reflectorsToMove > 0) {
      (int, int) reflector = reflectors.removeAt(0);
      world.remove(reflector);
      while (true) {
        (int, int) nextPos = getNextPos(reflector);
        if (checkNext(nextPos) || world.contains(nextPos)) break;
        reflector = nextPos;
      }
      world.add(reflector);
      reflectors.add(reflector);
      reflectorsToMove--;
    }
  }

  _moveNorth() => _move(
        sortCompare: (a, b) => a.$1.compareTo(b.$1),
        getNextPos: (reflector) => (reflector.$1 - 1, reflector.$2),
        checkNext: (nextPos) => nextPos.$1 < 0,
      );

  _moveSouth() => _move(
        sortCompare: (a, b) => b.$1.compareTo(a.$1),
        getNextPos: (reflector) => (reflector.$1 + 1, reflector.$2),
        checkNext: (nextPos) => nextPos.$1 >= input.length,
      );

  _moveWest() => _move(
        sortCompare: (a, b) => a.$2.compareTo(b.$2),
        getNextPos: (reflector) => (reflector.$1, reflector.$2 - 1),
        checkNext: (nextPos) => nextPos.$2 < 0,
      );

  _moveEast() => _move(
        sortCompare: (a, b) => b.$2.compareTo(a.$2),
        getNextPos: (reflector) => (reflector.$1, reflector.$2 + 1),
        checkNext: (nextPos) => nextPos.$2 >= input.first.length,
      );

  _cycle() {
    _moveNorth();
    _moveWest();
    _moveSouth();
    _moveEast();
  }

  _equalList(List a, List b) {
    return a.every((e) => b.contains(e));
  }

  _listKeyHashCode(List l) =>
      l.fold(1, (hashCode, element) => hashCode + element.hashCode);

  HashMap<List<(int, int)>, int> reflectorsAfterCycle = HashMap(
    equals: _equalList,
    hashCode: _listKeyHashCode,
  );
  reflectorsAfterCycle[List.from(reflectors)] = 0;
  HashMap<List<(int, int)>, List<(int, int)>> statesMap = HashMap(
    equals: _equalList,
    hashCode: _listKeyHashCode,
  );

  const maxCycles = 1000000000;
  for (var cycle = 1; cycle < maxCycles; cycle++) {
    List<(int, int)> prev = List.from(reflectors);
    _cycle();

    if (statesMap.containsKey(reflectors)) {
      // state already in the map

      // we got into loop
      // count how big the loop is and use that to skip to maxCycles
      int loopStartCycle = reflectorsAfterCycle[reflectors]!;
      int loopLength = cycle - loopStartCycle;
      int remainingCycles = (maxCycles - loopStartCycle) % loopLength;
      while (remainingCycles > 0) {
        reflectors = statesMap[reflectors]!;
        remainingCycles--;
      }
      break;
    } else {
      // new state
      List<(int, int)> r = List.from(reflectors);
      statesMap[prev] = r;
      reflectorsAfterCycle[r] = cycle;
    }
  }
  int result = _calcLoad();

  print("Load after $maxCycles cycles: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(14, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 136)]);
  day.runPart(2, part2, [Pair("example_input.txt", 64)]);
}
