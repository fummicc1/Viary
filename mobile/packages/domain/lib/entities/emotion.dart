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