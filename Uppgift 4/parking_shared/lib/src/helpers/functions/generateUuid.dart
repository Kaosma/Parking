import 'dart:math';

String generateUuid() {
  final random = Random();

  String fourRandomHexDigits() {
    return random.nextInt(0x10000).toRadixString(16).padLeft(4, '0');
  }

  return '${fourRandomHexDigits()}${fourRandomHexDigits()}-${fourRandomHexDigits()}${fourRandomHexDigits()}';
}
