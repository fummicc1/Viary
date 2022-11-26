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
      _value = "http://18.177.88.113/";
    } else {
      _value = "http://18.177.88.113/";
    }
    return _value!;
  }
}