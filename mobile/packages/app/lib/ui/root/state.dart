import 'package:domain/entities/viary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

@freezed
class RootState with _$RootState {
  const factory RootState({
    @Default(false) isSignedIn,
    @Default([]) List<Viary> viaries,
  }) = _RootState;
}