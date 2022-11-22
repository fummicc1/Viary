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
  }) = _Viary;

  factory Viary.fromJson(Map<String, dynamic> json) => _$ViaryFromJson(json);
}
