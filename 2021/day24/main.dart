/*
 * https://adventofcode.com/2021/day/24
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef PuzzleInput = List<Operation>;

class Operation {
  String opcode;
  List<String> operrands;

  Operation(this.opcode, this.operrands);

  @override
  String toString() {
    return "$opcode ${operrands.join(" ")}";
  }
}

class Registers {
  int w = 0, x = 0, y = 0, z = 0, sp = 0;
  String stack;

  Registers(this.stack);
  operator []=(String regName, int value) {
    switch (regName) {
      case "w":
        w = value;
        break;
      case "x":
        x = value;
        break;
      case "y":
        y = value;
        break;
      case "z":
        z = value;
        break;
    }
  }

  int operator [](String regName) {
    switch (regName) {
      case "w":
        return w;
      case "x":
        return x;
      case "y":
        return y;
      case "z":
        return z;
      default:
        return 0;
    }
  }

  int readStack() {
    var result = int.parse(stack[sp]);
    sp++;
    return result;
  }
}

Registers compute(List<Operation> operations, String input) {
  // registers
  Registers registers = Registers(input);

  // pc - program counter
  for (var pc = 0; pc < operations.length; pc++) {
    Operation op = operations[pc];
    switch (op.opcode) {
      case "inp":
        registers[op.operrands[0]] = registers.readStack();
        break;
      case "add":
        int? secondsArg = int.tryParse(op.operrands[1]);
        if (secondsArg != null) {
          registers[op.operrands[0]] += secondsArg;
        } else {
          registers[op.operrands[0]] += registers[op.operrands[1]];
        }
        break;
      case "mul":
        int? secondsArg = int.tryParse(op.operrands[1]);
        if (secondsArg != null) {
          registers[op.operrands[0]] *= secondsArg;
        } else {
          registers[op.operrands[0]] *= registers[op.operrands[1]];
        }
        break;
      case "div":
        int? secondsArg = int.tryParse(op.operrands[1]);
        if (secondsArg != null) {
          registers[op.operrands[0]] ~/= secondsArg;
        } else {
          registers[op.operrands[0]] ~/= registers[op.operrands[1]];
        }
        break;
      case "mod":
        int? secondsArg = int.tryParse(op.operrands[1]);
        if (secondsArg != null) {
          registers[op.operrands[0]] %= secondsArg;
        } else {
          registers[op.operrands[0]] %= registers[op.operrands[1]];
        }
        break;
      case "eql":
        int? secondsArg = int.tryParse(op.operrands[1]);
        if (secondsArg != null) {
          registers[op.operrands[0]] =
              registers[op.operrands[0]] == secondsArg ? 1 : 0;
        } else {
          registers[op.operrands[0]] =
              registers[op.operrands[0]] == registers[op.operrands[1]] ? 1 : 0;
        }
        break;
      default:
    }
  }
  return registers;
}

PuzzleInput parse(File file) {
  List<Operation> operations = file.readAsLinesSync().map((e) {
    var tmp = e.split(" ");
    return Operation(tmp[0], tmp.sublist(1));
  }).toList();

  return operations;
}

void part1(PuzzleInput operations) {
  // the idea is some operations in input are like div by 1 or mul by 0 or add 0
  // or some other useless stuff

  Registers currentRegisters = Registers("");
  Map<String, Map<int, Operation>> regOperationsMap = {
    "w": Map<int, Operation>(),
    "x": Map<int, Operation>(),
    "y": Map<int, Operation>(),
    "z": Map<int, Operation>(),
  };
  for (var pc = 0; pc < operations.length; pc++) {
    String opcode = operations[pc].opcode;
    String firstOperrand = operations[pc].operrands[0];

    if (opcode == "inp") {
      regOperationsMap[firstOperrand]!.putIfAbsent(pc, () => operations[pc]);
      continue;
    }
    String secondOperrand = operations[pc].operrands[1];

    int? firstOperrandValue = int.tryParse(firstOperrand);
    // else must be a register (register value must be known tho)
    if (firstOperrandValue == null && regOperationsMap[firstOperrand]!.length == 0) {
      // no pending operations on this register = value is known
      firstOperrandValue = currentRegisters[firstOperrand];
    }
    int? secondOperrandValue = int.tryParse(secondOperrand);
    // else must be a register (register value must be known tho)
    if (secondOperrandValue == null && regOperationsMap[secondOperrand]!.length == 0) {
      // no pending operations on this register = value is known
      secondOperrandValue = currentRegisters[secondOperrand];
    }

    // all optimizations:
    // we can compute stuff like:
    // mul <known> <known>
    // div <known> <known>
    // add <known> <known>
    // mod <known> <known>
    // eql <known> <known>
    // eql <reg = 0> w - sets reg to 0 bc w is never 0 (gets set only by inp but input cant contain any zeroes)

    // mul <unknown> <known = 0> - sets value of <unknown> to 0 !PRUNES!
    // div <unknown> 1 - just ignore, does nothing
    // add <unknown> 0 - just ignore, does nothing
    // mod <unknown> 1 - sets <unknown> to 0 !PRUNES!

    // div <unknown> <unknown> - sets <unknown> to 1 if both are the same

    if (firstOperrandValue != null && secondOperrandValue != null) {
      switch (opcode) {
        case "mul":
          currentRegisters[firstOperrand] *= secondOperrandValue;
          break;
        case "div":
          currentRegisters[firstOperrand] ~/= secondOperrandValue;
          break;
        case "add":
          currentRegisters[firstOperrand] += secondOperrandValue;
          break;
        case "mod":
          currentRegisters[firstOperrand] %= secondOperrandValue;
          break;
        case "eql":
          currentRegisters[firstOperrand] =
              firstOperrandValue == secondOperrandValue ? 1 : 0;
          break;
        default:
      }
      continue;
    }

    if (opcode == "mul" &&
        firstOperrandValue == null &&
        secondOperrandValue == 0) {
      currentRegisters[firstOperrand] = 0;
      regOperationsMap[firstOperrand]!.clear();
      continue;
    }

    if (opcode == "eql" && firstOperrandValue == 0 && secondOperrand == "w") {
      currentRegisters[firstOperrand] = 0;
      continue;
    }

    if (opcode == "div" &&
        firstOperrandValue == null &&
        secondOperrandValue == 1) {
      continue;
    }

    if (opcode == "add" &&
        firstOperrandValue == null &&
        secondOperrandValue == 0) {
      continue;
    }

    if (opcode == "mod" &&
        firstOperrandValue == null &&
        secondOperrandValue == 1) {
      currentRegisters[firstOperrand] = 0;
      regOperationsMap[firstOperrand]!.clear();
      continue;
    }

    // cant optimize, add operation to map
    regOperationsMap[firstOperrand]!.putIfAbsent(pc, () => operations[pc]);
  }

  // now can print full pruned program of all useless operations
  List<MapEntry<int, Operation>> leftOperations = [];
  regOperationsMap.values.forEach((element) {
    leftOperations.addAll(element.entries);
  });
  leftOperations.sort((a, b) => a.key.compareTo(b.key));
  leftOperations.forEach((element) {
    print("${element.key.toString().padLeft(3, " ")}: ${element.value}"); 
  });
  print("${leftOperations.length} operations");
  print(regOperationsMap["z"]!.length);
  regOperationsMap["z"]!.forEach((key, value) {print("$key:  $value");});
  // print("The answer is: ${answer(".")}");
}

void part2(PuzzleInput operations) {
  printTodo();
  print("The answer is: ${answer("todo")}");
}

void main(List<String> args) {
  Day day = Day<PuzzleInput>(24, "input.txt", parse);
  day.runPart<PuzzleInput>(1, part1);
  day.runPart<PuzzleInput>(2, part2);
}
