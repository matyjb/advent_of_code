/*
 * https://adventofcode.com/2021/day/2
 */

import 'dart:io';

void main(List<String> args) {
  List<String> numbers = File("input.txt").readAsLinesSync().toList();
  print("## Part 1 ##");
  int numbersLenght = numbers.first.length;
  List<int> numbersDiffs = List.filled(numbersLenght, 0);

  // count which bit is more common in each position
  for (var number in numbers) {
    for (var i = 0; i < numbersLenght; i++) {
      numbersDiffs[i] += int.parse(number[i]) * 2 - 1;
    }
  }

  // convert numbersDiffs to binary number
  String gammaRateBinary = numbersDiffs.fold("",
      (previousValue, element) => previousValue + (element < 0 ? "0" : "1"));
  String epsilonRateBinary = [
    for (var i = 0; i < gammaRateBinary.length; i++)
      gammaRateBinary[i] == "1" ? "0" : "1",
  ].join();
  int gammaRate = int.parse(gammaRateBinary, radix: 2);
  int epsilonRate = int.parse(epsilonRateBinary, radix: 2);

  int consumption = gammaRate * epsilonRate;

  print("Power consumption: $consumption");
  print("## Part 2 ##");

  // its weird
  // if on bitIndex there are more 1 than 0, keep only that with 1
  // if on bitIndex there are more 0 than 1, keep only that with 0
  // inverse is the same but more -> fewer
  void filterWithCommonBitOnPosition(List<String> list, int bitIndex,
      [bool inverse = false]) {
    int countDiff = 0;
    for (var number in list) {
      countDiff += int.parse(number[bitIndex]) * 2 - 1;
    }
    if (!inverse)
      list.retainWhere(
          (element) => element[bitIndex] == (countDiff >= 0 ? "1" : "0"));
    else
      list.retainWhere(
          (element) => element[bitIndex] == (countDiff >= 0 ? "0" : "1"));
  }

  List<String> oxygenGeneratorRatingCandidates = List.from(numbers);
  List<String> co2ScrubberRatingCandidates = List.from(numbers);

  for (var i = 0; i < numbersLenght; i++) {
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
  print("Life support rating: $lifeSupportRating");
}
