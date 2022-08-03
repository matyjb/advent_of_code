/*
 * https://adventofcode.com/2021/day/4
 */

import 'dart:io';
import '../../day.dart';

class Board {
  List<int> board = [];
  List<bool> boardStatus = [];

  bool winStatus = false;

  Board();

  factory Board.fromLines(List<String> lines) {
    Board result = Board();
    if (lines.length != 5) throw "Too few lines. Must be 5";

    lines.forEach((element) {
      List<int> numbers = element
          .split(RegExp(r'\s+'))
          .where((s) => !s.isEmpty)
          .map((e) => int.parse(e))
          .toList();
      result.board.addAll(numbers);
    });
    result.boardStatus = List.filled(25, false);
    return result;
  }

  bool checkWin() {
    if (!winStatus) {
      for (var row = 0; row < 5; row++) {
        if (boardStatus[row * 5] &&
            boardStatus[row * 5 + 1] &&
            boardStatus[row * 5 + 2] &&
            boardStatus[row * 5 + 3] &&
            boardStatus[row * 5 + 4]) {
          winStatus = true;
          return true;
        }
      }

      for (var col = 0; col < 5; col++) {
        if (boardStatus[col] &&
            boardStatus[col + 5 * 1] &&
            boardStatus[col + 5 * 2] &&
            boardStatus[col + 5 * 3] &&
            boardStatus[col + 5 * 4]) {
          winStatus = true;
          return true;
        }
      }
      return false;
    } else
      return true;
  }

  void markNumber(int number) {
    if (!winStatus) {
      int index = board.indexOf(number);
      if (index >= 0) boardStatus[index] = true;
    }
  }

  void reset() {
    for (var i = 0; i < boardStatus.length; i++) {
      boardStatus[i] = false;
    }
    winStatus = false;
  }

  int calcFinalScore(int lastWinningNumber) {
    int sum = 0;
    for (var i = 0; i < board.length; i++) {
      if (!boardStatus[i]) sum += board[i];
    }
    return sum * lastWinningNumber;
  }
}

class Input{
  List<Board> boards;
  List<int> winningNumbers;

  Input(this.boards, this.winningNumbers);
}

Input parse(File file) {
  List<String> lines = file.readAsLinesSync().toList();
  List<int> winningNumbers =
      lines.first.split(",").map((number) => int.parse(number)).toList();

  List<Board> boards = [];
  List<String> currentBoardLines = [];
  for (var l in lines.skip(2)) {
    if (l.length > 0) currentBoardLines.add(l);

    if (currentBoardLines.length == 5) {
      boards.add(Board.fromLines(currentBoardLines));
      currentBoardLines.clear();
    }
  }
  return Input(boards, winningNumbers);
}

void part1(Input input) {
  List<Board> boards = input.boards;
  List<int> winningNumbers = input.winningNumbers;
  for (var winningNumber in winningNumbers) {
    for (var b in boards) {
      b.markNumber(winningNumber);
      if (b.checkWin()) {
        print("First winning board score: ${answer(b.calcFinalScore(winningNumber))}");
        return;
      }
    }
  }
}

void part2(Input input) {
  List<Board> boards = input.boards;
  List<int> winningNumbers = input.winningNumbers;
  int lastWinningScore = 0;
  List<Board> stillNotWinningBoards = List.from(boards);
  for (var winningNumber in winningNumbers) {
    for (var b in stillNotWinningBoards) {
      b.markNumber(winningNumber);
      if (b.checkWin()) {
        lastWinningScore = b.calcFinalScore(winningNumber);
      }
    }
    stillNotWinningBoards.removeWhere((element) => element.winStatus);
  }
  print("Last winning board score: ${answer(lastWinningScore)}");
}

void main(List<String> args) {
  Day day = Day(4, "input.txt", parse);
  day.runPart<Input>(1, part1);
  day.runPart<Input>(2, part2);
}
