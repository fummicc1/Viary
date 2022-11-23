import 'package:domain/entities/emotion.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'viary.freezed.dart';

part 'viary.g.dart';

@freezed
class Viary with _$Viary {
  static const collectionName = kDebugMode ? "viaries-dev" : "viaries";

  const factory Viary({
    String? id,
    String? sender,
    required String title,
    required String message,
    required DateTime date,
    @Default([]) List<ViaryEmotion> emotions,
  }) = _Viary;

  factory Viary.fromJson(Map<String, dynamic> json) => _$ViaryFromJson(json);
}

@freezed
class ViaryEmotion with _$ViaryEmotion {
  const factory ViaryEmotion({
    required String sentence,
    @EmotionJsonConverter() @Default(Emotion.unknown) Emotion emotion,
  }) = _ViaryEmotion;

  factory ViaryEmotion.fromJson(Map<String, dynamic> json) => _$ViaryEmotionFromJson(json);
}
