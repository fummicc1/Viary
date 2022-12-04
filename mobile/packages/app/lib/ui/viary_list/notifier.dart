import 'package:domain/entities/viary.dart';
import 'package:domain/repositories/viary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:viary/ui/root/notifier.dart';
import 'package:viary/ui/root/state.dart';
import 'package:viary/ui/viary_list/state.dart';

class ViaryListStateNotifier extends StateNotifier<ViaryListState> {
  ViaryListStateNotifier(
    ViaryListState state,
    this._viaryRepository,
  ) : super(state);

  final ViaryRepository _viaryRepository;

  updateCalendarFormat(CalendarFormat calendarFormat) {
    state = state.copyWith(
      calendarFormat: calendarFormat,
    );
  }

  onSelectedDate(DateTime dateTime) {
    state = state.copyWith(
      selectedDate: isSameDay(dateTime, state.selectedDate) ? null : dateTime,
    );
    filterViariesByDate(state.selectedDate);
  }

  filterViariesByDate(DateTime? dateTime) async {
    final all = await _viaryRepository.fetchAll(withCache: true);
    if (dateTime == null) {
      state = state.copyWith(viaries: all);
      return;
    }
    final list = all
        .where(
          (element) => isSameDay(element.date, dateTime),
        )
        .toList();
    state = state.copyWith(
      viaries: list,
    );
  }
}

final viaryListProvider =
    StateNotifierProvider<ViaryListStateNotifier, ViaryListState>(
  (ref) {
    final repository = ref.watch(viaryRepositoryProvider);
    final viaries = ref.watch(rootProvider).viaries;
    final state = ViaryListState(
      viaries: viaries,
      allViaries: viaries,
    );
    return ViaryListStateNotifier(state, repository);
  },
);
