/*
 * https://adventofcode.com/2022/day/6
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';
import 'main.dart';

class AnimFrameInfo {
  final String input;
  final int bufferStart;
  final int bufferEnd;
  final String? repeatedChar;
  AnimFrameInfo(
      this.input, this.bufferStart, this.bufferEnd, this.repeatedChar);
}

Iterable<AnimFrameInfo> searchForUniqueSubstringChars(
  String input,
  int bufferLen, [
  bool withSkipping = false,
]) sync* {
  for (var end = bufferLen; end <= input.length; end++) {
    int start = end - bufferLen;
    int repeatedCharIndex = isSubstringCharsUnique(input, start, end);
    yield AnimFrameInfo(
      input,
      start,
      end,
      repeatedCharIndex != -1 ? input[repeatedCharIndex] : null,
    );
    if (repeatedCharIndex == -1) break;
    if (withSkipping) end += repeatedCharIndex - start;
  }
}

int animate(Input input, int bufferSize, [bool withSkipping = false]) {
  int result = 0;
  final int blackSize = 10;
  print("\x1B[2J\x1b[?25l"); // hide cursor
  stdin.readLineSync();
  for (var frame
      in searchForUniqueSubstringChars(input, bufferSize, withSkipping)) {
    result = frame.bufferEnd;
    print("\x1B[0;0H"); //move carret to 0,0
    int leftSideOriginalLen =
        frame.bufferStart - max(0, frame.bufferStart - blackSize);
    int rightSideOriginalLen =
        min(frame.input.length, frame.bufferEnd + blackSize) - frame.bufferEnd;

    String leftSide = frame.bufferStart >= 1
        ? frame.input.substring(
            max(
              0,
              frame.bufferStart -
                  blackSize -
                  (rightSideOriginalLen - blackSize),
            ),
            frame.bufferStart,
          )
        : "";
    String buffer = frame.input.substring(frame.bufferStart, frame.bufferEnd);
    String rightSide = frame.bufferEnd <= input.length
        ? frame.input.substring(
            frame.bufferEnd,
            min(
              frame.input.length,
              frame.bufferEnd + blackSize + (blackSize - leftSideOriginalLen),
            ),
          )
        : "";

    int bufferEndColumn = leftSide.length + buffer.length;

    if (frame.repeatedChar != null)
      buffer = buffer.replaceAll(
        frame.repeatedChar!,
        "\x1B[31m${frame.repeatedChar}\x1B[33m",
      );
    print("\x1B[30m${leftSide}\x1B[33m${buffer}\x1B[30m${rightSide}\x1B[0m");
    for (var i = 0; i < bufferEndColumn; i++) {
      stdout.write(" ");
    }
    print("\x1B[33m^${frame.bufferEnd}\x1B[0m");

    sleep(Duration(milliseconds: 50));
    // stdin.readLineSync();
  }
  print("\x1b[?25h"); // show cursor
  return result;
}

int part1(Input input) {
  int result = animate(input, 4, true);
  print("First start-of-packet marker after character: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = animate(input, 14, true);
  print("First start-of-message marker after character: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(6, "input.txt", parse);
  // day.runPart(1, part1);
  day.runPart(2, part2);
}
