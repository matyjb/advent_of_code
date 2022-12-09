import 'dart:io';
import 'dart:core' as core;
import 'dart:core';
import 'dart:math';

bool isPrintOn = true;
void print(Object? object, [bool? forcePrint]) {
  forcePrint ??= false;
  if (forcePrint || isPrintOn) {
    core.print(object);
  }
}

int hash2(Object o0, Object o1) {
  // quiver code for combining two hashcode
  int hash0 = o0.hashCode;
  int hash1 = o1.hashCode;
  hash0 = 0x1fffffff & (hash0 + hash1);
  hash0 = 0x1fffffff & (hash0 + ((0x0007ffff & hash0) << 10));
  return hash0 ^ (hash0 >> 6);
}

class Pair<T extends Object, V extends Object> {
  final T v0;
  final V v1;
  Pair(this.v0, this.v1);

  Pair<T, V> copy() => Pair(v0, v1);

  @override
  String toString() => "(${v0},${v1})";

  @override
  bool operator ==(other) {
    return other is Pair && v0 == other.v0 && v1 == other.v1;
  }

  @override
  int get hashCode => hash2(v0, v1);
}

class Point2D extends Pair<int, int> {
  Point2D([int v0 = 0, int v1 = 0]) : super(v0, v1);

  int planckLength(Point2D other) {
    return max((v0 - other.v0).abs(), (v1 - other.v1).abs());
  }

  Point2D operator +(Point2D other) {
    return Point2D(v0 + other.v0, v1 + other.v1);
  }

  @override
  Point2D copy() => Point2D(v0, v1);
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
