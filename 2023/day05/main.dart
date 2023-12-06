/*
 * https://adventofcode.com/2023/day/5
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

class SourceDest {
  final int source;
  final int destination;
  final int len;

  SourceDest(this.destination, this.source, this.len);

  bool isWithin(int value) => value >= source && value < source + len;

  int map(int value) => isWithin(value) ? destination + value - source : value;

  @override
  String toString() => "($source->$destination;$len)";
}

typedef SeedRange = ({int start, int len});

class Input {
  final List<int> seeds;
  final List<List<SourceDest>> steps;

  Input(this.seeds, this.steps);
}

Input parse(File file) {
  final numbersRe = RegExp(r'\d+');
  final sourceDestRe =
      RegExp(r'(?<destination>\d+) (?<source>\d+) (?<len>\d+)');

  final lines = file.readAsLinesSync();
  final seeds = numbersRe
      .allMatches(lines.first)
      .map((e) => int.parse(e.group(0)!))
      .toList();

  List<List<SourceDest>> maps = [];
  for (var line in lines.skip(1)) {
    final sourceDestMatch = sourceDestRe.firstMatch(line);

    if (line.isNotEmpty && sourceDestMatch == null) {
      maps.add([]);
    } else if (sourceDestMatch != null) {
      maps.last.add(SourceDest(
        int.parse(sourceDestMatch.namedGroup("destination")!),
        int.parse(sourceDestMatch.namedGroup("source")!),
        int.parse(sourceDestMatch.namedGroup("len")!),
      ));
    }
  }

  return Input(seeds, maps);
}

int part1(Input input) {
  int? result;
  for (var seed in input.seeds) {
    int value = seed;
    for (var step in input.steps) {
      for (var sourceDest in step) {
        final newValue = sourceDest.map(value);
        if (newValue != value) {
          value = newValue;
          break;
        }
      }
    }
    result = result == null ? value : min(value, result);
  }

  print("Lowest seed position: ${answer(result!)}");
  return result;
}

int part2(Input input) {
  Iterable<SeedRange> _takeRanges(List<int> values) sync* {
    for (var i = 0; i < values.length - values.length % 2; i += 2) {
      yield (start: values[i], len: values[i + 1]);
    }
  }

  ({List<SeedRange> notMapped, SeedRange? mapped}) _mapRangeToDestination(
    SeedRange seeds,
    SourceDest map,
  ) {
    if (map.source > seeds.start + seeds.len ||
        map.source + map.len <= seeds.start) {
      return (notMapped: [seeds], mapped: null);
    }

    List<int> pointers = [
      seeds.start,
      seeds.start + seeds.len,
      map.source,
      map.source + map.len,
    ].toSet().toList()
      ..sort();

    List<SeedRange> notMapped = [];
    SeedRange? mapped;
    for (var i = 0; i < pointers.length - 1; i++) {
      final p = pointers[i];
      final pLen = pointers[i + 1] - p;
      // this subrange is not the range to be mapped
      if (p + pLen < seeds.start || p >= seeds.start + seeds.len) continue;

      final mappedP = map.map(p);
      if (mappedP == p) {
        notMapped.add((start: p, len: pLen));
      } else {
        mapped = (start: mappedP, len: pLen);
      }
    }
    return (mapped: mapped, notMapped: notMapped);
  }

  List<SeedRange> toMapInNextStep = _takeRanges(input.seeds).toList();
  for (var step in input.steps) {
    final toMapWithNextMap = [...toMapInNextStep];
    toMapInNextStep.clear();
    for (var map in step) {
      final toMapWithThisMap = [...toMapWithNextMap];
      toMapWithNextMap.clear();
      while (toMapWithThisMap.isNotEmpty) {
        final x = _mapRangeToDestination(toMapWithThisMap.removeAt(0), map);
        toMapWithNextMap.addAll(x.notMapped);
        if (x.mapped != null) {
          toMapInNextStep.add(x.mapped!);
        }
      }
    }
    toMapInNextStep.addAll(toMapWithNextMap);
  }

  int result = toMapInNextStep.fold(
      toMapInNextStep.first.start, (m, range) => min(range.start, m));
  print("Lowest seed position: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(5, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 35)]);
  day.runPart(2, part2, [Pair("example_input.txt", 46)]);
}
