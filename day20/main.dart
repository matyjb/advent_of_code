/*
 * https://adventofcode.com/2021/day/20
 */

import 'dart:io';
import 'dart:math';
import '../day.dart';

class Image {
  final Set<Point<int>> pixels;
  final bool flippedBackground;

  Image(this.pixels, this.flippedBackground);
}

class PuzzleInput {
  final String pixelMap;
  final Image image;

  PuzzleInput(this.pixelMap, this.image);
}

// order is important
const List<Point<int>> windowPoints = [
  Point<int>(-1, -1),
  Point<int>(0, -1),
  Point<int>(1, -1),
  Point<int>(-1, 0),
  Point<int>(0, 0),
  Point<int>(1, 0),
  Point<int>(-1, 1),
  Point<int>(0, 1),
  Point<int>(1, 1),
];

Point<int> findTopLeft(Set<Point<int>> pixels) =>
    pixels.reduce((p0, p1) => Point(min(p0.x, p1.x), min(p0.y, p1.y)));
Point<int> findBottomRight(Set<Point<int>> pixels) =>
    pixels.reduce((p0, p1) => Point(max(p0.x, p1.x), max(p0.y, p1.y)));

Image enchance(Image image, String pixelMap) {
  Set<Point<int>> result = Set();
  Point<int> topLeft = findTopLeft(image.pixels);
  Point<int> bottomRight = findBottomRight(image.pixels);

  for (var y = topLeft.y - 2; y <= bottomRight.y + 2; y++) {
    for (var x = topLeft.x - 2; x <= bottomRight.x + 2; x++) {
      StringBuffer valueBinary = StringBuffer();
      windowPoints.forEach((windowPoint) {
        Point p = windowPoint + Point(x, y);
        if (image.flippedBackground &&
            (p.x <= topLeft.x ||
                p.x >= bottomRight.x ||
                p.y <= topLeft.y ||
                p.y >= bottomRight.y)) {
          valueBinary.write("1");
        } else {
          valueBinary.write(image.pixels.contains(p) ? "1" : "0");
        }
      });
      int valueIndex = int.parse(valueBinary.toString(), radix: 2);
      if (pixelMap[valueIndex] == "#") result.add(Point<int>(x, y));
    }
  }
  return Image(
    result,
    image.flippedBackground ? pixelMap[0] != "#" : pixelMap[0] == "#",
  );
}

Image enchanceNTimes(Image image, String pixelMap, int n) {
  Image result = image;
  for (var i = 0; i < n; i++) {
    result = enchance(result, pixelMap);
  }
  return result;
}

void printImage(Image image) {
  Point<int> topLeft = findTopLeft(image.pixels);
  Point<int> bottomRight = findBottomRight(image.pixels);

  for (var y = topLeft.y; y <= bottomRight.y; y++) {
    for (var x = topLeft.x; x <= bottomRight.x; x++) {
      // stdout.write(image.pixels.contains(Point<int>(x, y)) ? "#" : ".");
      stdout.write(image.pixels.contains(Point<int>(x, y)) ? String.fromCharCode(0x2588) : " ");
    }
    stdout.write("\n");
  }
}

PuzzleInput parse(File file) {
  List<String> lines = file.readAsLinesSync();
  String pixelMap = lines[0];
  Set<Point<int>> pixels = Set();
  for (var y = 2; y < lines.length; y++) {
    for (var x = 0; x < lines[y].length; x++) {
      if (lines[y][x] == "#") pixels.add(Point<int>(x, y - 2));
    }
  }
  return PuzzleInput(pixelMap, Image(pixels, false));
}

void part1(PuzzleInput input) {
  var image = enchanceNTimes(input.image, input.pixelMap, 2);
  int litPixels = image.pixels.length;
  // printImage(image);
  print("Lit pixels in enchanced image twice: ${answer(litPixels)}");
}

void part2(PuzzleInput input) {
  var image = enchanceNTimes(input.image, input.pixelMap, 50);
  int litPixels = image.pixels.length;
  // printImage(image);
  print("Lit pixels in enchanced image 50 times: ${answer(litPixels)}");
}

void main(List<String> args) {
  Day day = Day<PuzzleInput>(20, "input.txt", parse);
  day.runPart<PuzzleInput>(1, part1);
  day.runPart<PuzzleInput>(2, part2);
}
