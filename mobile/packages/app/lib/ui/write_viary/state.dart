import 'package:domain/entities/viary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'state.freezed.dart';

@freezed
class WriteViaryState with _$WriteViaryState {
  const factory WriteViaryState({
    required Viary viary,
    @Default(false) bool isSpeeching,
    @Default(false) bool isLoading,
    @Default("") String temporaryWords,
    @Default(false) bool showDetermineDialog,
    @Default("ja-JP") String currentLocaleId,
    @Default([]) List<LocaleName> availableLocales,
  }) = _WriteViaryState;
}
