/*
 * https://adventofcode.com/2025/day/5
 */

import 'dart:io';
import '../../day.dart';

typedef InventoryDb = ({List<(int, int)> freshRanges, List<int> items});

InventoryDb parse(File file) {
  final rangesRx = RegExp(r'^(\d+)-(\d+)$');
  final items = RegExp(r'^\d+$');

  final freshRanges = <(int, int)>[];
  final itemList = <int>[];

  for (final line in file.readAsLinesSync()) {
    final rangeMatch = rangesRx.firstMatch(line);
    if (rangeMatch != null) {
      freshRanges.add((
        int.parse(rangeMatch.group(1)!),
        int.parse(rangeMatch.group(2)!),
      ));
      continue;
    }

    final itemMatch = items.firstMatch(line);
    if (itemMatch != null) {
      itemList.add(int.parse(itemMatch.group(0)!));
      continue;
    }
  }

  return (freshRanges: freshRanges, items: itemList);
}

List<(int, int)> mergeRanges(List<(int, int)> ranges) {
  if (ranges.isEmpty) return [];

  ranges.sort((a, b) => a.$1.compareTo(b.$1));
  final merged = <(int, int)>[];
  var current = ranges.first;

  for (var i = 1; i < ranges.length; i++) {
    final next = ranges[i];
    if (current.$2 >= next.$1 - 1) {
      current = (current.$1, current.$2 > next.$2 ? current.$2 : next.$2);
    } else {
      merged.add(current);
      current = next;
    }
  }
  merged.add(current);
  return merged;
}

int part1(InventoryDb input) {
  final mergedRanges = mergeRanges(input.freshRanges);

  int countItemsInRanges(List<(int, int)> ranges, List<int> items) {
    int count = 0;
    for (final item in items) {
      for (final range in ranges) {
        if (item >= range.$1 && item <= range.$2) {
          count++;
          break;
        }
      }
    }
    return count;
  }

  final result = countItemsInRanges(mergedRanges, input.items);

  print("Items that are fresh: ${answer(result)}");
  return result;
}

int part2(InventoryDb input) {
  final mergedRanges = mergeRanges(input.freshRanges);

  final result = mergedRanges.fold<int>(
    0,
    (previousValue, range) => previousValue + (range.$2 - range.$1 + 1),
  );

  print("Total fresh items: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(5, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 3)]);
  day.runPart(2, part2, [Pair("example_input.txt", 14)]);
}
