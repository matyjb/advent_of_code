/*
 * https://adventofcode.com/2021/day/22
 */

import 'dart:collection';
import 'dart:io';
import 'dart:math' as math;
import 'package:quiver/core.dart';
import '../../day.dart';

class Vec3 {
  int x, y, z;
  Vec3([this.x = 0, this.y = 0, this.z = 0]);

  bool operator ==(Object other) =>
      other is Vec3 && x == other.x && y == other.y && z == other.z;

  int get hashCode => hash3(x, y, z);
}

class Region {
  late final Vec3 min, max;
  bool state; // on,off
  Region(this.min, this.max, this.state);

  int get volume =>
      ((max.x - min.x).abs() + 1) *
      ((max.y - min.y).abs() + 1) *
      ((max.z - min.z).abs() + 1);
  bool checkRegion() {
    return min.x <= max.x && min.y <= max.y && min.z <= max.z;
  }

  Region? intersection(Region other) {
    Region intersection = Region(
      Vec3(
        math.max(min.x, other.min.x),
        math.max(min.y, other.min.y),
        math.max(min.z, other.min.z),
      ),
      Vec3(
        math.min(max.x, other.max.x),
        math.min(max.y, other.max.y),
        math.min(max.z, other.max.z),
      ),
      true, // does not matter
    );
    if (intersection.checkRegion()) {
      return intersection;
    }
  }
}

class PuzzleInput {
  List<Region> regions;
  PuzzleInput(this.regions);
}

PuzzleInput parse(File file) {
  RegExp xdim = RegExp(r'x=-?\d+..-?\d+');
  RegExp ydim = RegExp(r'y=-?\d+..-?\d+');
  RegExp zdim = RegExp(r'z=-?\d+..-?\d+');
  List<String> lines = file.readAsLinesSync();

  List<Region> regions = lines.map((String e) {
    bool state = e.contains("on");
    List<int> xRange = xdim
        .stringMatch(e)!
        .replaceAll("x=", "")
        .split("..")
        .map((n) => int.parse(n))
        .toList();
    List<int> yRange = ydim
        .stringMatch(e)!
        .replaceAll("y=", "")
        .split("..")
        .map((n) => int.parse(n))
        .toList();
    List<int> zRange = zdim
        .stringMatch(e)!
        .replaceAll("z=", "")
        .split("..")
        .map((n) => int.parse(n))
        .toList();
    Vec3 min = Vec3(xRange[0], yRange[0], zRange[0]);
    Vec3 max = Vec3(xRange[1], yRange[1], zRange[1]);
    return Region(min, max, state);
  }).toList();

  return PuzzleInput(regions);
}

void part1(PuzzleInput input) {
  Region maxRegion = Region(Vec3(-50, -50, -50), Vec3(50, 50, 50), true);
  HashSet<Vec3> cubesOn = HashSet();

  for (var region in input.regions) {
    for (var x = math.max(region.min.x, maxRegion.min.x);
        x <= math.min(region.max.x, maxRegion.max.x);
        x++) {
      for (var y = math.max(region.min.y, maxRegion.min.y);
          y <= math.min(region.max.y, maxRegion.max.y);
          y++) {
        for (var z = math.max(region.min.z, maxRegion.min.z);
            z <= math.min(region.max.z, maxRegion.max.z);
            z++) {
          if (region.state)
            cubesOn.add(Vec3(x, y, z));
          else
            cubesOn.remove(Vec3(x, y, z));
        }
      }
    }
  }

  print("The answer is: ${answer(cubesOn.length)}");
}

void part2(PuzzleInput input) {
  // region that is lit defined by lit or unlit regions merged together one by one
  // in the order of this list
  List<Region> litRegion = [];
  for (var instruction in input.regions) {
    // lets add instruction region to the litRegion
    // we have to check if instruction intersects with any litRegion
    // if it does we have to add the intersection to litRegion
    // the state (on/off) of added intersection is determined by
    // notice that litRegionInstruction is alredy in litRegion so we dont add it
    // [0] (lit litRegionInstruction) + (lit instruction) => add (lit instruction) and (unlit intersection)
    // [1] (lit litRegionInstruction) + (unlit instruction) => add (unlit intersection)
    // for corresponding lit region that intersect with some other lit region we created unlit region
    // (this is the (unlit litRegionInstruction) here) and here with another (lit instruction) we created extra
    // (unlit intersection) one litRegionInstruction before so we have to negate it with (lit intersection)
    // [2] (unlit litRegionInstruction) + (lit instruction) => add (lit instruction) and (lit intersection)
    // [3] (unlit litRegionInstruction) + (unlit instruction) => add (lit intersection)

    List<Region> intersections = [];
    for (var litRegionInstruction in litRegion) {
      Region? intersection = litRegionInstruction.intersection(instruction);
      if (intersection != null) {
        // [0] and [1] (where intersection is unlit) litRegionInstruction.state = true
        // [2] and [3] (where intersection is lit) litRegionInstruction.state = false
        intersection.state = !litRegionInstruction.state;
        intersections.add(intersection);
      }
    }
    // for [0] and [2]
    if (instruction.state) {
      litRegion.add(instruction);
    }
    litRegion.addAll(intersections);
  }

  int sumVolume = 0;
  for (var region in litRegion) {
    sumVolume += region.state ? region.volume : -region.volume;
  }
  // printTodo();
  print("The answer is: ${answer(sumVolume)}");
}

void main(List<String> args) {
  Day day = Day<PuzzleInput>(22, "input.txt", parse);
  day.runPart<PuzzleInput>(1, part1);
  day.runPart<PuzzleInput>(2, part2);
}
