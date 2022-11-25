// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'viary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Viary _$$_ViaryFromJson(Map<String, dynamic> json) => _$_Viary(
      id: json['id'] as String?,
      sender: json['sender'] as String?,
      title: json['title'] as String,
      message: json['message'] as String,
      date: DateTime.parse(json['date'] as String),
      emotions: json['emotions'] == null
          ? const []
          : const ViaryEmotionListJsonConverter()
              .fromJson(json['emotions'] as List),
    );

Map<String, dynamic> _$$_ViaryToJson(_$_Viary instance) => <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'title': instance.title,
      'message': instance.message,
      'date': instance.date.toIso8601String(),
      'emotions':
          const ViaryEmotionListJsonConverter().toJson(instance.emotions),
    };

_$_ViaryEmotion _$$_ViaryEmotionFromJson(Map<String, dynamic> json) =>
    _$_ViaryEmotion(
      sentence: json['sentence'] as String,
      score: json['score'] as int,
      emotion: json['emotion'] == null
          ? Emotion.unknown
          : const EmotionJsonConverter().fromJson(json['emotion'] as String),
    );

Map<String, dynamic> _$$_ViaryEmotionToJson(_$_ViaryEmotion instance) =>
    <String, dynamic>{
      'sentence': instance.sentence,
      'score': instance.score,
      'emotion': const EmotionJsonConverter().toJson(instance.emotion),
    };
