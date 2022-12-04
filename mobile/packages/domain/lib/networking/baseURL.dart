import 'dart:io';

import 'package:flutter/foundation.dart';

class BaseURL {
  static String get value {
    if (_value != null) {
      return _value!;
    }
    return _getURL();
  }
  static String? _value;

  static String _getURL() {
    if (kDebugMode) {
      _value = "https://voice-diary.net/";
    } else {
      _value = "https://voice-diary.net/";
    }
    return _value!;
  }
}