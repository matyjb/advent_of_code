import 'dart:io';

class Day<T> {
  final int day;
  final String inputFilePath;
  final T Function(File) parseFunction;
  Stopwatch _stopwatch = Stopwatch();

  Day(this.day, this.inputFilePath, this.parseFunction);

  void part1<T>(Function(T) solveFunction) {
    print("\x1B[32m## Day $day - part 1 ##\x1B[0m");
    T input = parseFunction(File(inputFilePath)) as T;
    print("\x1B[35mParsed input as: $input\x1B[0m");
    _stopwatch.reset();
    _stopwatch.start();
    solveFunction(input);
    _stopwatch.stop();
    print("⏱ \x1B[36m${_stopwatch.elapsedMilliseconds}\x1B[0m ms");
  }

  void part2<T>(Function(T) solveFunction) {
    print("\x1B[32m## Day $day - part 2 ##\x1B[0m");
    T input = parseFunction(File(inputFilePath)) as T;
    print("\x1B[35mParsed input as: $input\x1B[0m");
    _stopwatch.reset();
    _stopwatch.start();
    solveFunction(input);
    _stopwatch.stop();
    print("⏱ \x1B[36m${_stopwatch.elapsedMilliseconds}\x1B[0m ms");
  }

}
String answer(Object s) => "\x1B[33m$s\x1B[0m";
