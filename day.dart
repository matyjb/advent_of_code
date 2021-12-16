class Day {
  final int day;
  Stopwatch _stopwatch = Stopwatch();

  Day(this.day);

  void part1<T>(T input, Function(T) solveFunction) {
    print("\x1B[32m## Day $day - part 1 ##\x1B[0m");
    _stopwatch.reset();
    _stopwatch.start();
    solveFunction(input);
    _stopwatch.stop();
    print("⏱ \x1B[36m${_stopwatch.elapsedMilliseconds}\x1B[0m ms");
  }

  void part2<T>(T input, Function(T) solveFunction) {
    print("\x1B[32m## Day $day - part 2 ##\x1B[0m");
    _stopwatch.reset();
    _stopwatch.start();
    solveFunction(input);
    _stopwatch.stop();
    print("⏱ \x1B[36m${_stopwatch.elapsedMilliseconds}\x1B[0m ms");
  }

}
String answer(Object s) => "\x1B[33m$s\x1B[0m";
