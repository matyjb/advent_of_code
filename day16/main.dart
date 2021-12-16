/*
 * https://adventofcode.com/2021/day/16
 */

import 'dart:io';
import '../day.dart';
import 'packet.dart';

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

List parsePackets(Iterable<String> bits) {
  if (bits.length < 6) return [];

  int version = binToInt(bits.take(3).join());
  bits = bits.skip(3);
  int typeId = binToInt(bits.take(3).join());
  bits = bits.skip(3);

  int bitsUsed = 6;

  if (typeId == 4) {
    String valuePrefix;
    StringBuffer valueBits = StringBuffer();
    do {
      valuePrefix = bits.take(1).single;
      bits = bits.skip(1);
      valueBits.writeAll(bits.take(4));
      bits = bits.skip(4);
      bitsUsed += 5;
    } while (valuePrefix == "1");
    int value = binToInt(valueBits.toString());
    return [LiteralPacket(version: version, number: value), bitsUsed];
  } else {
    String lengthTypeId = bits.take(1).join();
    bits = bits.skip(1);
    bitsUsed += 1;
    if (lengthTypeId == "0") {
      // If the length type ID is 0, then the next 15 bits are a number that
      // represents the total length in bits of the sub-packets contained by this packet.
      String bin = bits.take(15).join();
      int length = binToInt(bin);
      bits = bits.skip(15);
      bitsUsed += 15;

      Iterable<String> subPacketsBits = bits.take(length);
      bits = bits.skip(length);
      bitsUsed += length;

      List<Packet> packets = [];
      while (length > 0) {
        List tmp = parsePackets(subPacketsBits);
        Packet packet = tmp[0] as Packet;
        int subBitsUsed = tmp[1] as int;
        length -= subBitsUsed;
        subPacketsBits = subPacketsBits.skip(subBitsUsed);
        packets.add(packet);
      }
      return [
        OperatorPacket(
            version: version,
            typeId: typeId,
            lengthTypeId: lengthTypeId,
            subPackets: packets),
        bitsUsed
      ];
    } else {
      // If the length type ID is 1, then the next 11 bits are a number that
      // represents the number of sub-packets immediately contained by this packet.
      String bin = bits.take(11).join();
      int length = binToInt(bin);
      bits = bits.skip(11);
      bitsUsed += 11;
      List<Packet> packets = [];
      for (var i = 0; i < length; i++) {
        List tmp = parsePackets(bits);
        Packet packet = tmp[0] as Packet;
        int subBitsUsed = tmp[1] as int;
        bits = bits.skip(subBitsUsed);
        bitsUsed += subBitsUsed;
        packets.add(packet);
      }
      return [
        OperatorPacket(
            version: version,
            typeId: typeId,
            lengthTypeId: lengthTypeId,
            subPackets: packets),
        bitsUsed
      ];
    }
  }
}

int countVersionNumbers(Packet packet) {
  if(packet is LiteralPacket){
    return packet.version;
  }else if(packet is OperatorPacket){
    return packet.version + packet.subPackets.fold(0, (sum, p) => sum + countVersionNumbers(p));
  }else return 0;
}

void part1(List<Packet> packets) {
  int sum = 0;
  for (var p in packets) {
    sum += countVersionNumbers(p);
  }
  print("Sum of version numbers: ${answer(sum)}");
}

void part2(List<Packet> packets) {
  int ans = packets.first.evaluate();
  print("Evaluated value: ${answer(ans)}");
}

void main(List<String> args) {
  String input = File("input.txt").readAsStringSync();
  List<Packet> packets = [parsePackets(hexToBits(input))[0] as Packet];

  Day day = Day(16);
  day.part1<List<Packet>>(packets, part1);
  day.part2<List<Packet>>(packets, part2);
}
