import 'package:domain/entities/viary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class ViaryDetailState with _$ViaryDetailState {
  const factory ViaryDetailState({
    required Viary viary,
  }) = _ViaryDetailState;
}
