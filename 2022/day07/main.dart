/*
 * https://adventofcode.com/2022/day/7
 */

import 'dart:io';
import '../../day.dart';

const diskSize = 70000000;
const reqUpdateSpace = 30000000;

void printNSpaces(int n) {
  for (var i = 0; i < n; i++) {
    stdout.write(" ");
  }
}

// pair of command and its result (for ls command)
typedef Input = Iterable<Pair<List<String>, List<String>>>;

class Fil {
  final String name;
  final int size;

  Fil(this.name, this.size);
  factory Fil.fromLine(String line) {
    List<String> values = line.split(" ");
    return Fil(values[1], int.parse(values[0]));
  }

  @override
  String toString() => "$name (file, size=$size)";
}

class Dir {
  final String name;
  final List<Fil> files = [];
  final List<Dir> directories = [];

  Dir(this.name);
  factory Dir.fromLine(String line) {
    List<String> values = line.split(" ");
    return Dir(values[1]);
  }

  int size() {
    return files.fold(0, (acc, element) => acc + element.size) +
        directories.fold(0, (acc, element) => acc + element.size());
  }

  String toString() => "$name (dir, size=${size()})";

  void printTree([int spaces = 0]) {
    printNSpaces(spaces);
    print("- $this");
    for (var dir in directories) {
      dir.printTree(spaces + 1);
    }
    for (var file in files) {
      printNSpaces(spaces + 1);
      print("- $file");
    }
  }
}

Input parse(File file) sync* {
  List<String> lines = file.readAsLinesSync();
  List<String>? cmd;
  List<String> cmdOutput = [];
  for (var i = 0; i < lines.length; i++) {
    String line = lines[i];
    if (line.startsWith("\$ ")) {
      if (cmd != null) {
        yield Pair(cmd, cmdOutput);
        cmdOutput = [];
      }
      // new command
      cmd = line.replaceFirst("\$ ", "").split(" ");
    } else {
      // ls output line
      cmdOutput.add(line);
    }
  }
  // return last cmd
  if (cmd != null) {
    yield Pair(cmd, cmdOutput);
    cmdOutput = [];
  }
}

Dir createFileHierarchy(Input commands) {
  List<Dir> pathStack = [];
  for (var cmd in commands) {
    if (cmd.v0.first == "cd") {
      String arg = cmd.v0[1];
      if (arg == "/") {
        if (pathStack.length > 0) {
          Dir home = pathStack.first;
          pathStack.clear();
          pathStack.add(home);
        } else {
          pathStack.add(Dir("/"));
        }
      } else if (arg == "..") {
        pathStack.removeLast();
      } else {
        pathStack.add(
          pathStack.last.directories
              .firstWhere((element) => element.name == arg),
        );
      }
    } else if (cmd.v0.first == "ls") {
      for (var element in cmd.v1) {
        if (element.startsWith("dir")) {
          pathStack.last.directories.add(Dir.fromLine(element));
        } else {
          pathStack.last.files.add(Fil.fromLine(element));
        }
      }
    }
  }
  return pathStack.first;
}

int sizeSumsBelow(Dir dir, [int value = 100000]) {
  int thisDirSize = dir.size();
  int thisDirValue = thisDirSize > value ? 0 : thisDirSize;
  return dir.directories.fold(
      thisDirValue, (acc, element) => acc + sizeSumsBelow(element, value));
}

int part1(Input input) {
  int below = 100000;
  Dir home = createFileHierarchy(input);
  int result = sizeSumsBelow(home, below);
  print("Sum of direcotries sizes below $below: ${answer(result)}");
  return result;
}

List<int> bigEnoughDirsSizes(Dir dir, int minSize) {
  List<int> candidates = [];
  int thisDirSize = dir.size();
  if (thisDirSize >= minSize) {
    candidates.add(thisDirSize);
  }
  for (var subDir in dir.directories) {
    candidates.addAll(bigEnoughDirsSizes(subDir, minSize));
  }
  return candidates;
}

int part2(Input input) {
  Dir home = createFileHierarchy(input);
  final int neededSpace = reqUpdateSpace - (diskSize - home.size());
  List<int> candidatesSizes = bigEnoughDirsSizes(home, neededSpace).toList();
  int result = candidatesSizes.first;
  for (var can in candidatesSizes) {
    if (result > can) result = can;
  }

  print("Smallest directory size with enough space: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(7, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 95437)]);
  day.runPart(2, part2, [Pair("example_input.txt", 24933642)]);
}
