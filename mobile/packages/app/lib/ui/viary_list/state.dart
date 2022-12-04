import 'package:domain/entities/viary.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:table_calendar/table_calendar.dart';

part 'state.freezed.dart';

@freezed
class ViaryListState with _$ViaryListState {
  const factory ViaryListState({
    required List<Viary> viaries,
    required List<Viary> allViaries,
    DateTime? selectedDate,
    @Default(CalendarFormat.month) CalendarFormat calendarFormat,
  }) = _ViaryListState;
}
