import 'dart:io';
import 'dart:core' as core;
import 'dart:core';

bool isPrintOn = true;
void print(Object? object, [bool? forcePrint]) {
  forcePrint ??= false;
  if (forcePrint || isPrintOn) {
    core.print(object);
  }
}

class Pair<T, V> {
  final T v0;
  final V v1;
  Pair(this.v0, this.v1);
  @override
  String toString() => "(${v0},${v1})";
}

class Day<T> {
  final int day;
  final String inputFilePath;
  final T Function(File) parseFunction;
  Stopwatch _stopwatch = Stopwatch();

  Day(this.day, this.inputFilePath, this.parseFunction);

  dynamic _runTest<T>(
    String inputFilePath,
    Function(T) solveFunction,
    dynamic expectedValue,
  ) {
    T input = parseFunction(File(inputFilePath)) as T;
    dynamic result;
    isPrintOn = false;
    try {
      result = solveFunction(input);
      isPrintOn = true;
    } catch (e) {
      isPrintOn = true;
      throw e;
    }

    if (result == expectedValue)
      return result;
    else
      throw "❌ Expected ${expectedValue}, got ${result}";
  }

  bool _runTests<T>(
    Function(T) solveFunction,
    List<Pair<String, dynamic>> tests,
  ) {
    if (tests.isEmpty) return true;

    List<String> failedTestsMsgs = [];
    for (var test in tests) {
      try {
        _runTest(test.v0, solveFunction, test.v1);
      } catch (error) {
        failedTestsMsgs.add(error.toString());
      }
    }
    bool isOk = failedTestsMsgs.isEmpty;
    // print results
    int passedTests = tests.length - failedTestsMsgs.length;
    print(">Tests: ${passedTests}/${tests.length} ${isOk ? "✅" : "❌"}");
    for (var failedTestMsg in failedTestsMsgs) {
      print(failedTestMsg);
    }
    return isOk;
  }

  void runPart<T>(
    int i,
    Function(T) solveFunction, [
    List<Pair<String, dynamic>>? tests,
  ]) {
    tests ??= List.empty();
    print("\x1B[32m## Day $day - part $i ##\x1B[0m");
    if (!_runTests(solveFunction, tests)) return;

    T input = parseFunction(File(inputFilePath)) as T;
    // print("\x1B[35mParsed input as: \n${input.runtimeType}\x1B[0m");
    _stopwatch.reset();
    _stopwatch.start();
    solveFunction(input);
    _stopwatch.stop();
    print("⏱ \x1B[36m${_stopwatch.elapsedMilliseconds}\x1B[0m ms");
  }
}

String answer(Object s) => "\x1B[33m$s\x1B[0m";
void printTodo() => print("\x1B[35m>>>TODO<<<\x1B[0m", true);
