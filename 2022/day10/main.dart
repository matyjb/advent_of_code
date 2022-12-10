/*
 * https://adventofcode.com/2022/day/10
 */

import 'dart:io';
import '../../day.dart';

enum OpCode { noop, addx }

class Instruction {
  final OpCode opCode;
  final int? arg;
  Instruction(this.opCode, this.arg);
  factory Instruction.fromLine(String line) {
    if (line == "noop") return Instruction(OpCode.noop, null);
    String arg = line.split(" ").last;
    return Instruction(OpCode.addx, int.parse(arg));
  }
}

typedef Input = Iterable<Instruction>;

Input parse(File file) {
  return file.readAsLinesSync().map(Instruction.fromLine);
}

int part1(Input input) {
  int regx = 1;
  int cycle = 1;
  List<int> desiredCycles = [20, 60, 100, 140, 180, 220];
  int result = 0;

  for (var instruction in input) {
    if (desiredCycles.length > 0)
      switch (instruction.opCode) {
        case OpCode.noop:
          cycle++;
          break;
        case OpCode.addx:
          if (cycle + 2 > desiredCycles.first) {
            result += desiredCycles.first * regx;
            desiredCycles.removeAt(0);
          }
          regx += instruction.arg!;
          cycle += 2;
          break;
        default:
      }
  }
  print("Sum of signal strengths: ${answer(result)}");
  return result;
}

Iterable<Instruction> instructionEveryCycle(Input input) sync* {
  Instruction noopInstruction = Instruction(OpCode.noop, null);
  for (var ins in input) {
    switch (ins.opCode) {
      case OpCode.noop:
        yield ins;
        break;
      case OpCode.addx:
        yield noopInstruction;
        yield ins;
        break;
      default:
    }
  }
}

String part2(Input input) {
  const String lit = "#";
  const String unlit = ".";
  // 6 height, 40 wide
  List<StringBuffer> crt = List.generate(6, (_) => StringBuffer());
  int regx = 1; // spritePosition (from 0 to 3)
  int cycle = 0;

  for (var instruction in instructionEveryCycle(input)) {
    int row = cycle ~/ 40;
    int col = cycle - 40 * row;

    crt[row].write(col < regx - 1 || col > regx + 1 ? unlit : lit);
    switch (instruction.opCode) {
      case OpCode.noop:
        break;
      case OpCode.addx:
        regx += instruction.arg!;
        break;
      default:
    }
    cycle++;
  }

  String result = crt.join("\n");
  print("CRT screen state:\n${answer(result)}");
  return "\n$result";
}

void main(List<String> args) {
  Day day = Day(10, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 13140)]);
  day.runPart(2, part2, [
    Pair(
      "example_input.txt",
      "\n##..##..##..##..##..##..##..##..##..##..\n###...###...###...###...###...###...###.\n####....####....####....####....####....\n#####.....#####.....#####.....#####.....\n######......######......######......####\n#######.......#######.......#######.....",
    )
  ]);
}
