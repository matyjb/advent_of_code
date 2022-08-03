/*
 * https://adventofcode.com/2021/day/16
 */

import 'dart:io';
import '../../day.dart';
import 'packet.dart';

class Bits {
  Iterable<String> _bits;
  int bitsUsed = 0;
  Bits(this._bits);

  int get length => _bits.length;

  String readChunk(int count) {
    String result = _bits.take(count).join();
    _bits = _bits.skip(count);
    bitsUsed += count;
    return result;
  }
}

String hexToBin(String s) =>
    int.parse(s, radix: 16).toRadixString(2).padLeft(4, "0");
int binToInt(String s) => int.parse(s, radix: 2);

Iterable<String> hexToBits(String hex) sync* {
  for (var hexId = 0; hexId < hex.length; hexId++) {
    String bits = hexToBin(hex[hexId]);
    for (var i = 0; i < bits.length; i++) {
      yield bits[i];
    }
  }
}

Packet parsePacket(Bits bits) {
  int version = binToInt(bits.readChunk(3));
  int typeId = binToInt(bits.readChunk(3));

  if (typeId == 4) {
    String valuePrefix;
    StringBuffer valueBits = StringBuffer();
    do {
      valuePrefix = bits.readChunk(1);
      valueBits.write(bits.readChunk(4));
    } while (valuePrefix == "1");
    int value = binToInt(valueBits.toString());
    return LiteralPacket(
      version: version,
      number: value,
    );
  } else {
    String lengthTypeId = bits.readChunk(1);
    if (lengthTypeId == "0") {
      // If the length type ID is 0, then the next 15 bits are a number that
      // represents the total length in bits of the sub-packets contained by this packet.
      String bin = bits.readChunk(15);
      int length = binToInt(bin);

      List<Packet> packets = [];
      int bitsUsedBeforeRead = bits.bitsUsed;
      while (bits.bitsUsed - bitsUsedBeforeRead < length) {
        Packet packet = parsePacket(bits);
        packets.add(packet);
      }
      return OperatorPacket(
        version: version,
        typeId: typeId,
        lengthTypeId: lengthTypeId,
        subPackets: packets,
      );
    } else {
      // If the length type ID is 1, then the next 11 bits are a number that
      // represents the number of sub-packets immediately contained by this packet.
      String bin = bits.readChunk(11);
      int length = binToInt(bin);
      List<Packet> packets = [];
      for (var i = 0; i < length; i++) {
        Packet packet = parsePacket(bits);
        packets.add(packet);
      }
      return OperatorPacket(
        version: version,
        typeId: typeId,
        lengthTypeId: lengthTypeId,
        subPackets: packets,
      );
    }
  }
}

int countVersionNumbers(Packet packet) {
  if (packet is LiteralPacket) {
    return packet.version;
  } else if (packet is OperatorPacket) {
    return packet.version +
        packet.subPackets.fold(0, (sum, p) => sum + countVersionNumbers(p));
  } else
    return 0;
}

Packet parse(File file) =>
    parsePacket(Bits(hexToBits(file.readAsStringSync())));

void part1(Packet packet) {
  int ans = countVersionNumbers(packet);
  print("Sum of version numbers: ${answer(ans)}");
}

void part2(Packet packet) {
  int ans = packet.evaluate();
  print("Evaluated value: ${answer(ans)}");
}

void main(List<String> args) {
  Day day = Day<Packet>(16, "input.txt", parse);
  day.runPart<Packet>(1,part1);
  day.runPart<Packet>(2,part2);
}
