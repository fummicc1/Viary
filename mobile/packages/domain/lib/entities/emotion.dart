import 'dart:ui';

import 'package:domain/entities/viary.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

enum Emotion {
  anger,
  disgust,
  fear,
  joy,
  neutral,
  sadness,
  surprise,
  unknown,
}

extension EmotionEx on Emotion {
  Color get color {
    switch (this) {
      case Emotion.anger:
        return Colors.red;
      case Emotion.disgust:
        return Colors.brown;
      case Emotion.fear:
        return Colors.blueGrey;
      case Emotion.joy:
        return Colors.orange;
      case Emotion.neutral:
        return Colors.black;
      case Emotion.sadness:
        return Colors.blueGrey;
      case Emotion.surprise:
        return Colors.lightGreen;
      case Emotion.unknown:
        return Colors.black;
    }
  }

  String get message {
    switch (this) {

      case Emotion.anger:
        return "怒り";
      case Emotion.disgust:
        return "嫌悪";
      case Emotion.fear:
        return "恐怖";
      case Emotion.joy:
        return "楽しい";
      case Emotion.neutral:
        return "通常";
      case Emotion.sadness:
        return "悲しい";
      case Emotion.surprise:
        return "驚き";
      case Emotion.unknown:
        return "不明";
    }
  }
}

class EmotionJsonConverter implements JsonConverter<Emotion, String> {
  const EmotionJsonConverter();

  @override
  Emotion fromJson(String? value) {
    switch (value) {
      case "anger":
        return Emotion.anger;
      case "disgust":
        return Emotion.disgust;
      case "fear":
        return Emotion.fear;
      case "joy":
        return Emotion.joy;
      case "neutral":
        return Emotion.neutral;
      case "sadness":
        return Emotion.sadness;
      case "surprise":
        return Emotion.surprise;
      case "unknown":
        return Emotion.unknown;
    }
    return Emotion.unknown;
  }

  @override
  String toJson(Emotion emotion) {
    return emotion.name;
  }
}

class ViaryEmotionListJsonConverter
    implements JsonConverter<List<ViaryEmotion>, List<dynamic>> {
  const ViaryEmotionListJsonConverter();

  @override
  List<ViaryEmotion> fromJson(List<dynamic> _json) {
    final json = _json.cast<Map<String, dynamic>>();
    List<ViaryEmotion> list = [];
    for (final element in json) {
      list.add(ViaryEmotion.fromJson(element));
    }
    return list;
  }

  @override
  List<dynamic> toJson(List<ViaryEmotion> object) {
    return object.map((e) => e.toJson()).toList();
  }
}
