import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseURL {
  static String get value {
    if (_value != null) {
      return _value!;
    }
    return getURL();
  }
  static String? _value;

  static String getURL() {
    if (kDebugMode) {
      _value = "localhost";
    } else {
      _value = dotenv.get("API_BASE_URL");
    }
    return _value!;
  }
}