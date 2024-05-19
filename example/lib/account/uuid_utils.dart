import 'dart:typed_data';

class Uuid {
  final int mostSigBits;
  final int leastSigBits;

  Uuid.fromBytes(List<int> bytes)
      : assert(bytes.length == 16),
        mostSigBits = _bytesToInt(Uint8List.fromList(bytes), 0),
        leastSigBits = _bytesToInt(Uint8List.fromList(bytes), 8);

  static int _bytesToInt(Uint8List bytes, int offset) {
    int value = 0;
    for (int i = offset; i < offset + 8; i++) {
      value = (value << 8) | (bytes[i] & 0xff);
    }

    return value;
  }

  factory Uuid.nameUUIDFromBytes(Int8List name) {
    name[6] = name[6] & 0x0f;
    name[6] = name[6] | 0x30;
    name[8] = name[8] & 0x3f;
    name[8] = name[8] | 0x80;

    return Uuid.fromBytes(name);
  }

  @override
  int get hashCode {
    var hilo = mostSigBits ^ leastSigBits;
    int idk = (hilo >> 32) ^ hilo;

    return idk.toSigned(32);
  }

  String toString() {
    return '${digits((mostSigBits >> 32), 8)}-${digits((mostSigBits >> 16), 4)}-${digits(mostSigBits, 4)}-${digits((leastSigBits >> 48), 4)}-${digits(leastSigBits, 12)}';
  }

  String digits(int val, int digits) {
    int hi = 1 << (digits * 4);

    return (hi | (val & (hi - 1))).toRadixString(16).substring(1);
  }
}
