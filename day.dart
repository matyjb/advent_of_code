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

// Greatest Common Divisor
int gcd(int a, int b) {
  while (a != b) {
    if (a > b)
      a -= b;
    else
      b -= a;
  }
  return a;
}

// Least Common Multiple
int lcm(int a, int b) {
  return (a * b) ~/ gcd(a, b);
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

  int manhattanDistance(Point2D other) {
    return (v0 - other.v0).abs() + (v1 - other.v1).abs();
  }

  Point2D operator +(Point2D other) {
    return Point2D(v0 + other.v0, v1 + other.v1);
  }

  Point2D operator -(Point2D other) {
    return Point2D(v0 - other.v0, v1 - other.v1);
  }

  Point2D operator ~/(int other) {
    return Point2D(v0 ~/ other, v1 ~/ other);
  }

  // returns topLeft and bottomRight points of the bounding rectangle
  static Pair<Point2D, Point2D> boundingRect(List<Point2D> points) {
    int minV0 = points.first.v0, maxV0 = points.first.v0;
    int minV1 = points.first.v1, maxV1 = points.first.v1;
    for (Point2D p in points.skip(1)) {
      minV0 = min(minV0, p.v0);
      maxV0 = max(maxV0, p.v0);
      minV1 = min(minV1, p.v1);
      maxV1 = max(maxV1, p.v1);
    }
    return Pair(Point2D(minV0, minV1), Point2D(maxV0, maxV1));
  }

  @override
  Point2D copy() => Point2D(v0, v1);
}

class Point3D {
  final int x, y, z;
  Point3D([this.x = 0, this.y = 0, this.z = 0]);

  int manhattanDistance(Point3D other) {
    return (x - other.x).abs() + (y - other.y).abs() + (z - other.z).abs();
  }

  Point3D operator +(Point3D other) {
    return Point3D(x + other.x, y + other.y, z + other.z);
  }

  Point3D operator -(Point3D other) {
    return Point3D(x - other.x, y - other.y, z - other.z);
  }

  Point3D operator ~/(int other) {
    return Point3D(x ~/ other, y ~/ other, z ~/ other);
  }

  Point3D copy() => Point3D(x, y, z);

  @override
  String toString() => "(${x},${y},${z})";

  @override
  bool operator ==(other) {
    return other is Point3D && x == other.x && y == other.y && z == other.z;
  }

  @override
  int get hashCode => this.toString().hashCode;
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

extension NumIterableExtensions on Iterable<num> {
  sum() => fold<num>(0, (s, value) => s + value);
  multiply() => fold<num>(1, (s, value) => s * value);
}

extension ListExtension on List {
  bool startsWith(List other, [int? end]) {
    end ??= other.length;
    if (other.length > length) return false;

    for (var i = 0; i < end; i++) {
      if (other[i] != this[i]) return false;
    }

    return true;
  }

  bool isEqualTo(List other) {
    return other.length == length && startsWith(other);
  }
}

extension MapExtension on Map {
  String toBetterString() =>
      "{\n${entries.map((e) => "${e.key}: ${e.value}").join("\n")}\n}";
}

String answer(Object s) => "\x1B[33m$s\x1B[0m";
void printTodo() => print("\x1B[35m>>>TODO<<<\x1B[0m", true);
