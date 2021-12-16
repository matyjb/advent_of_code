import 'dart:math';

class Packet {
  final int version;
  final int typeId;

  Packet(this.version, this.typeId);

  int evaluate()=>0;
}

class LiteralPacket extends Packet {
  int number;

  LiteralPacket({required int version, required this.number})
      : super(version, 4);

  @override
  int evaluate() => number;
}

class OperatorPacket extends Packet {
  String lengthTypeId;
  List<Packet> subPackets;

  OperatorPacket({
    required int version,
    required int typeId,
    required this.lengthTypeId,
    required this.subPackets,
  }) : super(version, typeId);

  @override
  int evaluate() {
    switch (typeId) {
      case 0:
        return subPackets.fold(0,(sum, p) => sum + p.evaluate());
      case 1:
        return subPackets.fold(1,(mul, p) => mul * p.evaluate());
      case 2:
        return subPackets.map((e) => e.evaluate()).reduce(min);
      case 3:
        return subPackets.map((e) => e.evaluate()).reduce(max);
      case 5:
        return subPackets[0].evaluate() > subPackets[1].evaluate() ? 1 : 0;
      case 6:
        return subPackets[0].evaluate() < subPackets[1].evaluate() ? 1 : 0;
      case 7:
        return subPackets[0].evaluate() == subPackets[1].evaluate() ? 1 : 0;
      default:
        return 0;
    }
  }
}
