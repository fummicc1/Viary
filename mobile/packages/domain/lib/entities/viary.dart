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
    @ViaryEmotionListJsonConverter() @Default([]) List<ViaryEmotion> emotions,
  }) = _Viary;

  const Viary._();

  factory Viary.fromJson(Map<String, dynamic> json) => _$ViaryFromJson(json);

  ViaryEmotion? get bestEmotion {
    // To make emotions modifiable, wrap it with `List.from`.
    List<ViaryEmotion> emotions = List.from(this.emotions);
    emotions.sort((a, b) => b.score.compareTo(a.score));
    if (emotions.isEmpty) {
      return null;
    }
    return emotions[0];
  }
}

@freezed
class ViaryEmotion with _$ViaryEmotion {
  const factory ViaryEmotion({
    required String sentence,
    required int score,
    @EmotionJsonConverter() @Default(Emotion.unknown) Emotion emotion,
  }) = _ViaryEmotion;

  factory ViaryEmotion.fromJson(Map<String, dynamic> json) => _$ViaryEmotionFromJson(json);
}
