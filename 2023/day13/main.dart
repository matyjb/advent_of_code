/*
 * https://adventofcode.com/2023/day/13
 */

import 'dart:io';
import '../../day.dart';

typedef Input = List<List<String>>;

Input parse(File file) {
  Iterable<List<String>> getMaps(Iterable<String> lines) sync* {
    List<String> map = [];
    for (var line in lines) {
      if (line.isNotEmpty) {
        map.add(line);
      } else {
        if (map.isNotEmpty) yield map;
        map = [];
      }
    }
    if (map.isNotEmpty) yield map;
  }

  return getMaps(file.readAsLinesSync()).toList();
}

Map<String, List<int>> getRowsIndexes(List<String> map) {
  Map<String, List<int>> rowsIndexes = {};
  for (var i = 0; i < map.length; i++) {
    rowsIndexes.update(
      map[i],
      (value) => value..add(i),
      ifAbsent: () => [i],
    );
  }
  return rowsIndexes;
}

List<String> transposeMap(List<String> map) {
  List<String> tMap = [];
  StringBuffer rowTBuffer = StringBuffer();
  for (var col = 0; col < map.first.length; col++) {
    for (var row = 0; row < map.length; row++) {
      rowTBuffer.write(map[row][col]);
    }
    tMap.add(rowTBuffer.toString());
    rowTBuffer.clear();
  }
  return tMap;
}

int? getReflectionHorizontal(List<String> map) {
  Map<String, List<int>> rowsIndexes = getRowsIndexes(map);

  bool _checkIfMatch(int start, int end) {
    while (start < end) {
      final line = map[start];
      if (!rowsIndexes[line]!.contains(end)) {
        return false;
      }
      start++;
      end--;
    }
    return true;
  }

  // first case - the first line might be in the reflection
  final firstLineCopies = rowsIndexes[map.first]!;
  if (firstLineCopies.length > 1) {
    bool hasReflection = false;
    // checking if lines in between match for each pairing
    final start = firstLineCopies.first;
    for (var endIdx = 1; endIdx < firstLineCopies.length; endIdx++) {
      final end = firstLineCopies[endIdx];
      hasReflection = _checkIfMatch(start, end);
      if (hasReflection) return (start + 1 + end) ~/ 2;
    }
  }

  // second case - the last might be in the reflection
  final lastLineCopies = rowsIndexes[map.last]!;
  if (lastLineCopies.length > 1) {
    bool hasReflection = false;
    // checking if lines in between match for each pairing
    final end = lastLineCopies.last;
    for (var startIdx = 0; startIdx < lastLineCopies.length - 1; startIdx++) {
      final start = lastLineCopies[startIdx];
      hasReflection = _checkIfMatch(start, end);
      if (hasReflection) return (start + 1 + end) ~/ 2;
    }
  }

  return null;
}

int? getReflectionVertical(List<String> map) {
  List<String> tMap = transposeMap(map);
  return getReflectionHorizontal(tMap);
}

int part1(Input input) {
  int result = 0;
  for (var map in input) {
    final reflectionHor = getReflectionHorizontal(map);
    final reflectionVer = getReflectionVertical(map);
    result += (reflectionHor ?? 0) * 100 + (reflectionVer ?? 0);
  }

  print("Answer: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;

  (int?, int?) _calcWithSmudges(int? refHor, int? refVer, List<String> map) {
    for (var row = 0; row < map.length; row++) {
      for (var col = 0; col < map.first.length; col++) {
        List<String> unsmugdedMap = List.from(map);
        unsmugdedMap[row] = unsmugdedMap[row].replaceRange(
            col,
            col + 1,
            switch (unsmugdedMap[row][col]) {
              "#" => ".",
              "." => "#",
              _ => throw "panic!",
            });
        // if (refHor == null) {
        //   final newVer = getReflectionVertical(unsmugdedMap);
        //   if (newVer != null && newVer != refVer) return (refHor, newVer);
        // } else {
        //   final newHor = getReflectionHorizontal(unsmugdedMap);
        //   if (newHor != null && newHor != refHor) return (newHor, refVer);
        // }
        final newHor = getReflectionHorizontal(unsmugdedMap);
        final newVer = getReflectionVertical(unsmugdedMap);
        // if(newHor != refHor || newVer != refVer) return (newHor, newVer);
        if (newHor != refHor) {
          return (newHor, null);
        }
        if (newVer != refVer) {
          return (null, newVer);
        }
        // if (newHor == refHor) {
        //   if (newVer == refVer) {
        //     // nothing changed
        //     continue;
        //   }
        //   return (refHor, newVer);
        // }
        // // changed
        // return (newHor, refVer);
      }
    }
    throw "panic!";
  }

  for (var map in input) {
    // lmao lets brute force it
    final reflectionHor = getReflectionHorizontal(map);
    final reflectionVer = getReflectionVertical(map);
    // check all the smudges, if reflection changed => stop
    final ref = _calcWithSmudges(reflectionHor, reflectionVer, map);
    result += (ref.$1 ?? 0) * 100 + (ref.$2 ?? 0);
  }

  print("Answer: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(13, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 405)]);
  day.runPart(2, part2, [Pair("example_input.txt", 400)]);
}
