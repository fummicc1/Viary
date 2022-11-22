import 'package:domain/entities/viary.dart';
import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'state.freezed.dart';

@freezed
class WriteViaryState with _$WriteViaryState {
  const factory WriteViaryState({
    required Viary viary,
    @Default(false) bool isSpeeching,
    @Default("") String temporaryWords,
    @Default(false) bool showDetermineDialog,
    LocaleName? currentLocale,
    @Default([]) List<LocaleName> availableLocales,
  }) = _WriteViaryState;
}
