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
    );

Map<String, dynamic> _$$_ViaryToJson(_$_Viary instance) => <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'title': instance.title,
      'message': instance.message,
      'date': instance.date.toIso8601String(),
    };
