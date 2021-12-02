/*
 * https://adventofcode.com/2021/day/1
 */

import 'dart:io';

enum CommandType {up, down, forward}

class Submarine {
  int horizontalPos, depth, aim;

  Submarine([this.horizontalPos = 0, this.depth = 0, this.aim = 0]);

  @override
  String toString() {
    return "Submarine($horizontalPos, $depth, $aim)";
  }

  applyCommandPart1(Command command) {
    switch (command.type) {
      case CommandType.up:
        depth -= command.arg;
        break;
      case CommandType.down:
        depth += command.arg;
        break;
      case CommandType.forward:
        horizontalPos += command.arg;
        break;
    }
  }

  applyCommandPart2(Command command) {
    switch (command.type) {
      case CommandType.up:
        aim -= command.arg;
        break;
      case CommandType.down:
        aim += command.arg;
        break;
      case CommandType.forward:
        horizontalPos += command.arg;
        depth += aim * command.arg;
        break;
    }
  }
}

class Command {
  CommandType type;
  int arg;

  Command(this.type, this.arg);

  factory Command.fromLine(String line) {
    List<String> lineSplit = line.split(" ");
    return Command(CommandType.values.firstWhere((e) => e.toString() == 'CommandType.' + lineSplit[0]),int.parse(lineSplit[1]));
  }
}

void main(List<String> args) {
  List<Command> commands = File("input.txt").readAsLinesSync().map((line)=>Command.fromLine(line)).toList();

  print("## Part 1 ##");
  Submarine sub = Submarine();
  for (var com in commands) {
    sub.applyCommandPart1(com);
  }
  print("Final submarine state:  $sub");
  print("horizontalPos * depth = ${sub.horizontalPos * sub.depth}");

  print("## Part 2 ##");
  sub = Submarine();
  for (var com in commands) {
    sub.applyCommandPart2(com);
  }
  print("Final submarine state:  $sub");
  print("horizontalPos * depth = ${sub.horizontalPos * sub.depth}");
}