/*
 * https://adventofcode.com/2021/day/23
 */

import 'dart:collection';
import 'dart:io';
import 'dart:math';
import '../../day.dart';

// from the diagram state is lenght=7
// #############
// #01.2.3.4.56# <- hallway
// ###D#D#C#B###
//   #B#A#A#C#
//   #########
class Hallway {
  List<String> state = [];

  Hallway(this.state);

  // valid move from hallway position 'position' to room id
  // map of room id: cost of moving to the entrance cell infront of room
  Iterable<MapEntry<int, int>> validMovesThroughHallwayToRooms(
      int position) sync* {
    switch (position) {
      case 0:
        if (state[1] == " ") {
          yield MapEntry(0, 2);
          if (state[2] == " ") {
            yield MapEntry(1, 4);
            if (state[3] == " ") {
              yield MapEntry(2, 6);
              if (state[4] == " ") {
                yield MapEntry(3, 8);
              }
            }
          }
        }

        break;
      case 1:
        yield MapEntry(0, 1);
        if (state[2] == " ") {
          yield MapEntry(1, 3);
          if (state[3] == " ") {
            yield MapEntry(2, 5);
            if (state[4] == " ") {
              yield MapEntry(3, 7);
            }
          }
        }
        break;

      case 2:
        yield MapEntry(0, 1);
        yield MapEntry(1, 1);
        if (state[3] == " ") {
          yield MapEntry(2, 3);
          if (state[4] == " ") {
            yield MapEntry(3, 5);
          }
        }
        break;

      case 3:
        yield MapEntry(1, 1);
        yield MapEntry(2, 1);
        if (state[2] == " ") {
          yield MapEntry(0, 3);
        }
        if (state[4] == " ") {
          yield MapEntry(3, 3);
        }
        break;
      case 4:
        yield MapEntry(3, 1);
        yield MapEntry(2, 1);
        if (state[3] == " ") {
          yield MapEntry(1, 3);
          if (state[2] == " ") {
            yield MapEntry(3, 5);
          }
        }
        break;

      case 5:
        yield MapEntry(3, 1);
        if (state[4] == " ") {
          yield MapEntry(2, 3);
          if (state[3] == " ") {
            yield MapEntry(1, 5);
            if (state[2] == " ") {
              yield MapEntry(0, 7);
            }
          }
        }
        break;
      case 6:
        if (state[5] == " ") {
          yield MapEntry(3, 2);
          if (state[4] == " ") {
            yield MapEntry(2, 4);
            if (state[3] == " ") {
              yield MapEntry(1, 6);
              if (state[2] == " ") {
                yield MapEntry(0, 8);
              }
            }
          }
        }
        break;
      default:
    }
  }

  Iterable<MapEntry<int, int>> validMovesFromRoomsToHallway(int roomId) sync* {
    switch (roomId) {
      case 0:
        yield MapEntry(1, 1);
        yield MapEntry(2, 1);
        if (state[1] == " ") {
          yield MapEntry(0, 2);
        }
        if (state[2] == " ") {
          yield MapEntry(3, 3);
          if (state[3] == " ") {
            yield MapEntry(4, 5);
            if (state[4] == " ") {
              yield MapEntry(5, 7);
              if (state[5] == " ") {
                yield MapEntry(6, 8);
              }
            }
          }
        }
        break;
      case 1:
        yield MapEntry(2, 1);
        yield MapEntry(3, 1);
        if (state[2] == " ") {
          yield MapEntry(1, 3);
          if (state[1] == " ") {
            yield MapEntry(0, 4);
          }
        }
        if (state[3] == " ") {
          yield MapEntry(4, 3);
          if (state[4] == " ") {
            yield MapEntry(5, 5);
            if (state[5] == " ") {
              yield MapEntry(6, 6);
            }
          }
        }
        break;
      case 2:
        yield MapEntry(3, 1);
        yield MapEntry(4, 1);
        if (state[3] == " ") {
          yield MapEntry(2, 3);
          if (state[2] == " ") {
            yield MapEntry(1, 5);
            if (state[1] == " ") {
              yield MapEntry(0, 6);
            }
          }
        }
        if (state[4] == " ") {
          yield MapEntry(5, 3);
          if (state[5] == " ") {
            yield MapEntry(6, 4);
          }
        }
        break;
      case 3:
        yield MapEntry(4, 1);
        yield MapEntry(5, 1);
        if (state[5] == " ") {
          yield MapEntry(6, 2);
        }
        if (state[4] == " ") {
          yield MapEntry(3, 3);
          if (state[3] == " ") {
            yield MapEntry(2, 5);
            if (state[2] == " ") {
              yield MapEntry(1, 7);
              if (state[1] == " ") {
                yield MapEntry(0, 8);
              }
            }
          }
        }
        break;
      default:
    }
  }

  Hallway copy() {
    return Hallway(List.from(state));
  }

  @override
  int get hashCode => state.join("").hashCode;
}

class Room {
  String id = "A";
  List<String> state = [];
  int maxState = 2;

  operator [](int i) {
    if (i < state.length)
      return state[i];
    else
      return " ";
  }

  Room(this.id, this.state, this.maxState);

  // returns cost of entry,
  // if entry is not valid then returns null (occupied or wrong room)
  int? enterRoom(String amphipod) {
    if (state.length == maxState) return null; //full
    if (amphipod != id) return null; // not correct room
    // and only can enter if others are the same type or empty
    if (!state.any((otherInRoom) => otherInRoom != amphipod)) {
      state.add(amphipod);
      return maxState - state.length + 1;
    }
    return null;
  }

  // returns what amphipod type left and what the cost of leaving was
  MapEntry<String, int>? leaveRoom() {
    if (state.length == 0) return null;

    String amphipod = state.removeLast();
    return MapEntry(amphipod, maxState - state.length);
  }

  Room copy() {
    List<String> copyList = List.from(state);
    return Room(id, copyList, maxState);
  }

  @override
  int get hashCode => (state.join() + id).hashCode;
}

Map<String, int> costMap = {
  "A": 1,
  "B": 10,
  "C": 100,
  "D": 1000,
};

class State {
  List<Room> rooms;
  Hallway hallway;

  State(this.rooms, this.hallway);

  State copy() {
    return State(rooms.map((e) => e.copy()).toList(), hallway.copy());
  }

  // return next state: cost of getting to this state
  Iterable<MapEntry<State, int>> genNextStates() sync* {
    // from rooms to hallway
    for (var i = 0; i < rooms.length; i++) {
      State newCandidate = copy();
      var leavingAmphipod = newCandidate.rooms[i].leaveRoom();
      if (leavingAmphipod != null) {
        for (var item in newCandidate.hallway.validMovesFromRoomsToHallway(i)) {
          if (hallway.state[item.key] == " ") {
            // can make a move there
            State newnewCandidate = newCandidate.copy();
            newnewCandidate.hallway.state[item.key] = leavingAmphipod.key;
            int cost = (leavingAmphipod.value + item.value) *
                (costMap[leavingAmphipod.key] ?? 0);
            yield MapEntry(newnewCandidate, cost);
          }
        }
      }
    }

    // from hallway to rooms
    for (var i = 0; i < hallway.state.length; i++) {
      if (hallway.state[i] == " ") continue;

      for (var roomEntry in hallway.validMovesThroughHallwayToRooms(i)) {
        State newCandidate = copy();
        int? entryCost =
            newCandidate.rooms[roomEntry.key].enterRoom(hallway.state[i]);
        if (entryCost != null) {
          newCandidate.hallway.state[i] = " ";
          int cost = (entryCost + roomEntry.value) *
              (costMap[costMap.keys.toList()[roomEntry.key]]!);
          yield MapEntry(newCandidate, cost);
        }
      }
    }
  }

  bool operator ==(Object other) =>
      other is State &&
      rooms[0].hashCode == other.rooms[0].hashCode &&
      rooms[1].hashCode == other.rooms[1].hashCode &&
      rooms[2].hashCode == other.rooms[2].hashCode &&
      rooms[3].hashCode == other.rooms[3].hashCode &&
      hallway.hashCode == other.hallway.hashCode;

  @override
  int get hashCode => [
        for (var i = 0; i < 4; i++) rooms[i].state.join().padLeft(2, " "),
        hallway.state.join(),
      ].join().hashCode;

  @override
  String toString() {
    StringBuffer s = StringBuffer();
    s.write("#############\n");
    s.write(
        "#\x1B[36m${hallway.state[0]}${hallway.state[1]} ${hallway.state[2]} ${hallway.state[3]} ${hallway.state[4]} ${hallway.state[5]}${hallway.state[6]}\x1B[0m#\n");
    for (var i = rooms.fold<int>(
                0,
                (previousValue, element) =>
                    max(previousValue, element.maxState)) -
            1;
        i >= 0;
        i--) {
      s.write(
          "###\x1B[36m${rooms[0][i]}\x1B[0m#\x1B[36m${rooms[1][i]}\x1B[0m#\x1B[36m${rooms[2][i]}\x1B[0m#\x1B[36m${rooms[3][i]}\x1B[0m###\n");
    }
    s.write("  #########  \n");
    return s.toString();
  }
}

State parse(File file) {
  List<String> lines = file.readAsLinesSync().sublist(2, 4);
  Map<int, String> amphipodsIds = {
    0: "A",
    1: "B",
    2: "C",
    3: "D",
  };
  List<Room> rooms = List.generate(
    4,
    (index) => Room(
      amphipodsIds[index] ?? "",
      [lines[1][3 + index * 2], lines[0][3 + index * 2]],
      2,
    ),
  );

  return State(rooms, Hallway([" ", " ", " ", " ", " ", " ", " "]));
}

class CostAndBefore {
  int cost;
  State? stateBefore;

  CostAndBefore(this.cost, this.stateBefore);

  void printPath(HashMap<State, CostAndBefore> statesMap, State? last) {
    if (stateBefore == null) {
      print(last);
      print(cost);
    } else {
      CostAndBefore cab = statesMap[last]!;
      cab.printPath(statesMap, cab.stateBefore);
      print(last);
      print(cost);
    }
  }
}

HashMap<State, CostAndBefore> organize(State input) {
  // map of current valid state to its score (only the lowest score will be kept)
  HashMap<State, CostAndBefore> statesScores = HashMap<State, CostAndBefore>()
    ..putIfAbsent(input, () => CostAndBefore(0, null));
  bool didLowerScore = true;
  while (didLowerScore) {
    didLowerScore = false;
    // update each state according to the rules (generate all possible moves/states)
    for (var state in statesScores.entries.toList()) {
      for (var nextState in state.key.genNextStates().toList()) {
        // print(nextState.key);
        // print(nextState.value);
        // print(state.value);
        statesScores.update(
          nextState.key,
          (value) {
            if (value.cost <= state.value.cost + nextState.value) {
              return value;
            } else {
              // statesScores.keys.firstWhere((element) => element == nextState.key).stateBefore = state.key;
              didLowerScore = true;
              return CostAndBefore(
                  state.value.cost + nextState.value, state.key);
            }
          },
          ifAbsent: () {
            // nextState.key.stateBefore = state.key;
            didLowerScore = true;
            return CostAndBefore(state.value.cost + nextState.value, state.key);
          },
        );
      }
    }
  }
  return statesScores;
}

void anim(HashMap<State, CostAndBefore> statesScores, State finalState) {
  State? stateBefore = statesScores[finalState]!.stateBefore;
  if (stateBefore == null) {
    print("\x1B[2J\x1B[0;0H");//clear console
    print(finalState);
    print("Press anything to start animation!");
    stdin.readByteSync();
    print("\x1B[0;0H");//move carret to 0,0
    sleep(Duration(milliseconds: 300));
  } else {
    anim(statesScores, stateBefore);
    print("\x1B[0;0H");//move carret to 0,0
    print(finalState);
    sleep(Duration(milliseconds: 300));
  }
}

void part1(State input) {
  HashMap<State, CostAndBefore> statesScores = organize(input);
  State finalState = State([
    Room("A", ["A", "A"], 2),
    Room("B", ["B", "B"], 2),
    Room("C", ["C", "C"], 2),
    Room("D", ["D", "D"], 2)
  ], Hallway([" ", " ", " ", " ", " ", " ", " "]));
  // CostAndBefore finalS = statesScores[finalState]!;
  // finalS.printPath(statesScores, finalState);
  int minScore = statesScores[finalState]!.cost;

  print("Minimal cost of energy used: ${answer(minScore)}");
  // anim(statesScores, finalState);
}

void part2(State input) {
  // extra stuff to insert
  // #D#C#B#A#
  // #D#B#A#C#
  input.rooms[0].state.insertAll(1, ["D", "D"]);
  input.rooms[1].state.insertAll(1, ["B", "C"]);
  input.rooms[2].state.insertAll(1, ["A", "B"]);
  input.rooms[3].state.insertAll(1, ["C", "A"]);
  input.rooms[0].maxState = 4;
  input.rooms[1].maxState = 4;
  input.rooms[2].maxState = 4;
  input.rooms[3].maxState = 4;

  HashMap<State, CostAndBefore> statesScores = organize(input);
  State finalState = State([
    Room("A", ["A", "A", "A", "A"], 4),
    Room("B", ["B", "B", "B", "B"], 4),
    Room("C", ["C", "C", "C", "C"], 4),
    Room("D", ["D", "D", "D", "D"], 4)
  ], Hallway([" ", " ", " ", " ", " ", " ", " "]));
  // CostAndBefore finalS = statesScores[finalState]!;
  // finalS.printPath(statesScores, finalState);
  int minScore = statesScores[finalState]!.cost;

  print("Minimal cost of energy used: ${answer(minScore)}");
  // anim(statesScores, finalState);
}

void main(List<String> args) {
  Day day = Day<State>(23, "input.txt", parse);
  day.runPart<State>(1, part1);
  day.runPart<State>(2, part2);
}
