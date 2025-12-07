/*
 * https://adventofcode.com/2025/day/7
 */

import 'dart:collection';
import 'dart:io';
import '../../day.dart';

enum TachyonManifoldCell { start, split }

typedef TachyonManifold = ({
  HashSet<(int, int)> splits,
  (int, int) startPosition,
  int width,
  int height,
});

TachyonManifold parse(File file) {
  final lines = file.readAsLinesSync();
  final int height = lines.length;
  final int width = lines[0].length;
  final HashSet<(int, int)> splits = HashSet();
  (int, int)? startPosition;
  for (int y = 0; y < height; y++) {
    final line = lines[y];
    for (int x = 0; x < width; x++) {
      final char = line[x];
      if (char == 'S') {
        startPosition = (x, y);
      } else if (char == '^') {
        splits.add((x, y));
      }
    }
  }

  final manifold = (
    splits: splits,
    startPosition: startPosition!,
    width: width,
    height: height,
  );

  return manifold;
}

int part1(TachyonManifold input) {
  int splitsCount = 0;
  final Set<(int, int)> beams = HashSet()..add(input.startPosition);

  do {
    final Set<(int, int)> nextLayerBeams = {};
    while (beams.isNotEmpty) {
      final beam = beams.first;
      beams.remove(beam);
      final (x, y) = beam;
      if (x >= input.width || x < 0 || y >= input.height) {
        // beam is out of range
        continue;
      }

      if (input.splits.contains((x, y + 1))) {
        splitsCount += 1;
        nextLayerBeams.add((x - 1, y + 1));
        nextLayerBeams.add((x + 1, y + 1));
      } else {
        nextLayerBeams.add((x, y + 1));
      }
    }
    beams.addAll(nextLayerBeams);
    nextLayerBeams.clear();
  } while (beams.isNotEmpty);
  print("The amount of times the beam has been split: ${answer(splitsCount)}");
  return splitsCount;
}

int part2(TachyonManifold input) {
  int result = 0;
  final HashMap<(int, int), int> beams = HashMap()..[input.startPosition] = 1;

  do {
    final HashMap<(int, int), int> nextLayerBeams = HashMap();
    while (beams.isNotEmpty) {
      final beamEntry = beams.entries.first;
      final beam = beamEntry.key;
      final beamCount = beamEntry.value;
      beams.remove(beam);
      final (x, y) = beam;
      if (x >= input.width || x < 0 || y >= input.height) {
        // beam is out of range
        result += beamCount;
        continue;
      }

      if (input.splits.contains((x, y + 1))) {
        nextLayerBeams[(x - 1, y + 1)] =
            beamCount + (nextLayerBeams[(x - 1, y + 1)] ?? 0);
        nextLayerBeams[(x + 1, y + 1)] =
            beamCount + (nextLayerBeams[(x + 1, y + 1)] ?? 0);
      } else {
        nextLayerBeams[(x, y + 1)] =
            beamCount + (nextLayerBeams[(x, y + 1)] ?? 0);
      }
    }
    beams.addAll(nextLayerBeams);
    nextLayerBeams.clear();
  } while (beams.isNotEmpty);

  print("Amount of paths the particle can take: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(7, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 21)]);
  day.runPart(2, part2, [Pair("example_input.txt", 40)]);
}
