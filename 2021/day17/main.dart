/*
 * https://adventofcode.com/2021/day/17
 */

import 'dart:io';
import 'dart:math';
import '../../day.dart';

class Target {
  Point<int> min, max;

  Target(this.min, this.max);

  @override
  String toString() {
    return "Target range: x=${min.x}..${max.x}, y=${min.y}..${max.y}";
  }
}

class Probe {
  Point<int> position = Point(0, 0);
  Point<int> velocity;

  Probe(this.velocity);

  void calcStep() {
    position += velocity;
    if (velocity.x > 0)
      velocity -= Point(1, 1);
    else if (velocity.x < 0)
      velocity -= Point(-1, 1);
    else
      velocity -= Point(0, 1);
  }
}

Target parse(File file) {
  RegExp rx = RegExp(r'x=[-]?\d+..[-]?\d+');
  RegExp ry = RegExp(r'y=[-]?\d+..[-]?\d+');

  String coords = file.readAsStringSync();

  List<int> rangeX = rx
      .stringMatch(coords)!
      .replaceAll("x=", "")
      .split("..")
      .map((e) => int.parse(e))
      .toList();
  List<int> rangeY = ry
      .stringMatch(coords)!
      .replaceAll("y=", "")
      .split("..")
      .map((e) => int.parse(e))
      .toList();

  return Target(Point(rangeX[0], rangeY[0]), Point(rangeX[1], rangeY[1]));
}

bool inBounds(Probe probe, Target target) {
  return probe.position.x >= target.min.x &&
      probe.position.y >= target.min.y &&
      probe.position.x <= target.max.x &&
      probe.position.y <= target.max.y;
}

void part1(Target target) {
  int candidateMaxY = 0;
  for (var x = 0; x <= 100; x++) {
    for (var y = 0; y < 100; y++) {
      stdout.write("${x * 100 + y}/${10000}\r");
      Probe probe = Probe(Point(x, y));
      bool probeHitTarget = false;
      int maxY = 0;
      while (probe.position.y >= target.min.y) {
        probe.calcStep();
        if (maxY < probe.position.y) {
          maxY = probe.position.y;
        }
        if (inBounds(probe, target)) {
          probeHitTarget = true;
        }
      }
      if (probeHitTarget && candidateMaxY < maxY) candidateMaxY = maxY;
    }
  }

  print("Maximum height of probe: ${answer(candidateMaxY)}");
}

void part2(Target target) {
  Set<Point<int>> result = {};
  for (var x = 0; x <= target.max.x; x++) {
    for (var y = target.min.y; y <= 1000; y++) {
      // stdout.write("${x * target.max.x + y-target.min.y}/${target.max.x*(1000-target.min.y)}\r");
      Probe probe = Probe(Point(x, y));
      bool probeHitTarget = false;
      while (probe.position.y >= target.min.y) {
        probe.calcStep();
        if (inBounds(probe, target)) {
          probeHitTarget = true;
        }
      }
      if (probeHitTarget){
        result.add(Point(x,y));
      }
    }
  }

  print("Possible distinct initial velocities: ${answer(result.length)}");
}

void main(List<String> args) {
  Day day = Day<Target>(17, "input.txt", parse);
  day.runPart<Target>(1,part1);
  day.runPart<Target>(2,part2);
}
