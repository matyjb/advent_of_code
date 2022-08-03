/*
 * https://adventofcode.com/2021/day/3
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

List<String> parse(File file) {
  return file.readAsLinesSync().toList();
}

void part1(List<String> numbers) {
  int numbersLenght = numbers.first.length;
  List<int> numbersDiffs = List.filled(numbersLenght, 0);

  // count which bit is more common in each position
  for (var number in numbers) {
    for (var i = 0; i < numbersLenght; i++) {
      numbersDiffs[i] += int.parse(number[i]) * 2 - 1;
    }
  }

  // convert numbersDiffs to binary number
  String gammaRateBinary = numbersDiffs.fold(
    "",
    (previousValue, element) => previousValue + (element < 0 ? "0" : "1"),
  );
  int gammaRate = int.parse(gammaRateBinary, radix: 2);
  int epsilonRate = pow(2, numbersLenght).toInt() - 1 - gammaRate;

  int consumption = gammaRate * epsilonRate;

  print("Power consumption: ${answer(consumption)}");
}

void part2(List<String> numbers) {
  // its weird
  // if on bitIndex there are more 1 than 0, keep only that with 1
  // if on bitIndex there are more 0 than 1, keep only that with 0
  // inverse is the same but more -> fewer
  void filterWithCommonBitOnPosition(
    List<String> list,
    int bitIndex, [
    bool inverse = false,
  ]) {
    int countDiff = 0;
    for (var number in list) {
      countDiff += int.parse(number[bitIndex]) * 2 - 1;
    }
    if (!inverse)
      list.retainWhere(
        (numberBin) => numberBin[bitIndex] == (countDiff >= 0 ? "1" : "0"),
      );
    else
      list.retainWhere(
        (numberBin) => numberBin[bitIndex] == (countDiff >= 0 ? "0" : "1"),
      );
  }

  List<String> oxygenGeneratorRatingCandidates = List.from(numbers);
  List<String> co2ScrubberRatingCandidates = List.from(numbers);

  for (var i = 0; i < numbers.length; i++) {
    if (oxygenGeneratorRatingCandidates.length > 1)
      filterWithCommonBitOnPosition(oxygenGeneratorRatingCandidates, i);
    if (co2ScrubberRatingCandidates.length > 1)
      filterWithCommonBitOnPosition(co2ScrubberRatingCandidates, i, true);
  }

  int oxygenGeneratorRating =
      int.parse(oxygenGeneratorRatingCandidates.first, radix: 2);
  int co2ScrubberRating =
      int.parse(co2ScrubberRatingCandidates.first, radix: 2);

  int lifeSupportRating = oxygenGeneratorRating * co2ScrubberRating;
  print("Life support rating: ${answer(lifeSupportRating)}");
}

void main(List<String> args) {
  Day day = Day(3, "input.txt", parse);
  day.runPart<List<String>>(1, part1);
  day.runPart<List<String>>(2, part2);
}
