/*
 * https://adventofcode.com/2022/day/17
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

typedef Input = Iterable<PushType>;

enum PushType { left, right }

Input parse(File file) sync* {
  const ops = {
    "<": PushType.left,
    ">": PushType.right,
  };
  String pattern = file.readAsLinesSync().first;
  for (var i = 0; i < pattern.length; i++) {
    String char = pattern[i];
    if (ops.containsKey(char)) {
      yield ops[char]!;
    }
  }
}

abstract class Block {
  late Point2D origin;
  Block(this.origin);
  // if block is static there should be added its collistion points
  List<Point2D> occupiedPointsCache = [];
  List<Point2D> get occupiedPoints;
}

class IBlock extends Block {
  /**
   * #
   * #
   * #
   * #
   */
  IBlock(Point2D origin) : super(origin);
  List<Point2D> get occupiedPoints {
    return [
      origin,
      origin + Point2D(0, -1),
      origin + Point2D(0, -2),
      origin + Point2D(0, -3),
    ];
  }
}

class PlusBlock extends Block {
  /**
   * .#.
   * ###
   * .#.
   */
  PlusBlock(Point2D origin) : super(origin);
  List<Point2D> get occupiedPoints {
    return [
      origin + Point2D(1, 0),
      origin + Point2D(0, -1),
      origin + Point2D(1, -1),
      origin + Point2D(2, -1),
      origin + Point2D(1, -2),
    ];
  }
}

class LBlock extends Block {
  /**
   * ..#
   * ..#
   * ###
   */
  LBlock(Point2D origin) : super(origin);
  List<Point2D> get occupiedPoints {
    return [
      origin + Point2D(2, 0),
      origin + Point2D(2, -1),
      origin + Point2D(2, -2),
      origin + Point2D(1, -2),
      origin + Point2D(0, -2),
    ];
  }
}

class FloorBlock extends Block {
  /**
   * ####
   */
  FloorBlock(Point2D origin) : super(origin);
  List<Point2D> get occupiedPoints {
    return [
      origin,
      origin + Point2D(1, 0),
      origin + Point2D(2, 0),
      origin + Point2D(3, 0),
    ];
  }
}

class SquareBlock extends Block {
  /**
   * ##
   * ##
   */
  SquareBlock(Point2D origin) : super(origin);
  List<Point2D> get occupiedPoints {
    return [
      origin,
      origin + Point2D(1, 0),
      origin + Point2D(0, -1),
      origin + Point2D(1, -1),
    ];
  }
}

Block genNextBlock(int blockIndex, int currentMaxHeight) {
  int modulo = blockIndex % 5;
  // two units away from the left wall
  // and its bottom edge is three units above the highest rock in the room
  // so
  // block Y = 3 + block height
  switch (modulo) {
    case 0:
      return FloorBlock(Point2D(2, currentMaxHeight + 4));
    case 1:
      return PlusBlock(Point2D(2, currentMaxHeight + 6));
    case 2:
      return LBlock(Point2D(2, currentMaxHeight + 6));
    case 3:
      return IBlock(Point2D(2, currentMaxHeight + 7));
    case 4:
      return SquareBlock(Point2D(2, currentMaxHeight + 5));
    default:
      throw "Hell froze if this happens";
  }
}

bool hasCollision(List<Point2D> v0, List<Point2D> v1) => v0.any(v1.contains);

bool hasCollisionWithStatics(
    Map<int, List<Block>> staticBlocks, List<Point2D> points, Point2D origin) {
  bool isCollision = staticBlocks.entries
      .where((blockList) =>
          blockList.key < origin.v1 + 4 && blockList.key > origin.v1 - 4)
      .map((e) => e.value)
      .any((blockList) => blockList
          .any((block) => hasCollision(block.occupiedPointsCache, points)));
  return isCollision;
}

void printStatics(Map<int, List<Block>> statics) {
  int h = statics.keys.reduce(max) + 1;
  stdout.writeln("h = $h");
  List<Point2D> points = [];
  for (var blocksList in statics.values) {
    for (var block in blocksList) {
      points.addAll(block.occupiedPointsCache);
    }
  }
  for (var c = h; c >= 0; c--) {
    stdout.write("|");
    for (var r = 0; r < 7; r++) {
      if (points.contains(Point2D(r, c))) {
        stdout.write("#");
      } else {
        stdout.write(".");
      }
    }
    stdout.writeln("|");
  }
  stdout.writeln("+-------+");
}

Iterable<Map<int, List<Block>>> simulateTetris(
    Input input, int maxBlocks) sync* {
  // STATE
  int spawnedBlocks = 0;
  // where key = height of origin of value = list of blocks with that origin
  Map<int, List<Block>> staticBlocks = {};
  Block currentSpawnedBlock = genNextBlock(spawnedBlocks, -1);
  currentSpawnedBlock.occupiedPointsCache = currentSpawnedBlock.occupiedPoints;
  // end STATE

  // STATE events functions
  void spawnNextBlock() {
    spawnedBlocks++;
    int maxHeight = staticBlocks.keys.reduce(max);
    currentSpawnedBlock = genNextBlock(spawnedBlocks, maxHeight);
  }

  void makeBlockStatic() {
    staticBlocks.update(
      currentSpawnedBlock.origin.v1,
      (value) => value..add(currentSpawnedBlock),
      ifAbsent: () => [currentSpawnedBlock],
    );
  }
  // end STATE events functions

  List<PushType> pushPattern = input.toList();
  var currentPushTypeIndex = 0;
  while (spawnedBlocks < maxBlocks) {
    // push with wind
    currentPushTypeIndex %= input.length;
    PushType currentPush = pushPattern[currentPushTypeIndex];
    currentPushTypeIndex++;

    Point2D pushedBy =
        currentPush == PushType.left ? Point2D(-1, 0) : Point2D(1, 0);
    currentSpawnedBlock.origin += pushedBy;
    // check collision
    List<Point2D> newCollisionPoints = currentSpawnedBlock.occupiedPoints;

    if (newCollisionPoints.any((p) => p.v0 < 0 || p.v0 >= 7) ||
        hasCollisionWithStatics(
          staticBlocks,
          newCollisionPoints,
          currentSpawnedBlock.origin,
        )) {
      // yes with block/wall => ignore origin change (move back one left/right)
      currentSpawnedBlock.origin -= pushedBy;
    } else {
      // no => memoize collisionPoints
      currentSpawnedBlock.occupiedPointsCache = newCollisionPoints;
    }

    // push down
    Point2D fallenBy = Point2D(0, 1);
    currentSpawnedBlock.origin -= fallenBy;
    // check collision
    newCollisionPoints = currentSpawnedBlock.occupiedPoints;

    if (newCollisionPoints.any((p) => p.v1 < 0) ||
        hasCollisionWithStatics(
          staticBlocks,
          newCollisionPoints,
          currentSpawnedBlock.origin,
        )) {
      // yes with block/floor => ignore origin change (move back one up) + make it static + spawn next block
      currentSpawnedBlock.origin += fallenBy;
      makeBlockStatic();
      yield staticBlocks;
      // printStatics(staticBlocks);
      spawnNextBlock();
    } else {
      // no => memoize collisionPoints
      currentSpawnedBlock.occupiedPointsCache = newCollisionPoints;
    }
  }
}

int part1(Input input) {
  Map<int, List<Block>> staticBlocks = {};
  for (var state in simulateTetris(input, 2022)) {
    staticBlocks = state;
  }
  int result = staticBlocks.keys.reduce(max) + 1;
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

int part2(Input input) {
  int result = 0;

  printTodo();
  print("<WHAT IS THE ANSWER>: ${answer(result)}");
  return result;
}

void main(List<String> args) {
  Day day = Day(17, "input.txt", parse);
  day.runPart(1, part1, [Pair("example_input.txt", 3068)]);
  day.runPart(2, part2, [Pair("example_input.txt", 1514285714288)]);
}
