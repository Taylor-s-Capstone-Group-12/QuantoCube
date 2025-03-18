import 'package:flutter/foundation.dart';

void reviewMap(Map<dynamic, dynamic> map) {
  if (kDebugMode) {
    print('=' * 10 + 'Review Map' '=' * 10);
    map.forEach((key, value) {
      print('$key: $value');
    });
    print('=' * 10 + 'Review Map' '=' * 10);
  }
}

void kPrint(String message) {
  if (kDebugMode) {
    print(message);
  }
}
