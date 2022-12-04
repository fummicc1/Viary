import 'package:domain/entities/viary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:domain/utils/datetime.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:viary/ui/viary_detail/page.dart';
import 'package:viary/ui/viary_list/notifier.dart';
import 'package:viary/ui/viary_list/state.dart';
import 'package:viary/ui/write_viary/page.dart';
import 'package:domain/entities/emotion.dart';

class ViaryListPage extends ConsumerWidget {
  const ViaryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ViaryListState state = ref.watch(viaryListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("一覧"),
        actions: [
          IconButton(
            onPressed: () {
              moveToWriteDiaryPage(context);
            },
            icon: const Icon(Icons.create),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              locale: "ja_JP",
              focusedDay: state.selectedDate ?? DateTime.now(),
              firstDay: DateTime(1970),
              lastDay: DateTime.now(),
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(state.selectedDate, day);
              },
              calendarFormat: state.calendarFormat,
              eventLoader: (date) {
                return state.allViaries
                    .where(
                      (element) => isSameDay(element.date, date),
                    )
                    .toList();
              },
              onDaySelected: (date, _) {
                ref.read(viaryListProvider.notifier).onSelectedDate(date);
              },
              onFormatChanged: (format) {
                ref
                    .read(viaryListProvider.notifier)
                    .updateCalendarFormat(format);
              },
            ),
          ),
          Flexible(
            child: state.viaries.isEmpty
                ? Column(
                    children: [
                      const Spacer(),
                      Text(
                        "まだ日記がありません",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const Spacer(),
                    ],
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.viaries.length,
                    itemBuilder: (context, index) {
                      Viary viary = state.viaries[index];
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              final route = MaterialPageRoute(
                                builder: (context) => ViaryDetailPage(
                                  viaryID: viary.id!,
                                ),
                                settings:
                                    const RouteSettings(name: "viary_detail/"),
                              );
                              Navigator.of(context).push(route);
                            },
                            child: Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    subtitle: Text(viary.message),
                                    trailing: Text(viary.date.format()),
                                  ),
                                  viary.emotions.isNotEmpty
                                      ? Column(
                                          children: viary.emotions
                                              .toList()
                                              .where((element) =>
                                                  element.score >= 10)
                                              .map(
                                                (viaryEmotion) => Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.75,
                                                      child:
                                                          LinearProgressIndicator(
                                                        value:
                                                            viaryEmotion.score /
                                                                100,
                                                        color: viaryEmotion
                                                            .emotion.color,
                                                        backgroundColor:
                                                            viaryEmotion
                                                                .emotion.color
                                                                .withOpacity(
                                                                    0.3),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6.0),
                                                      child: Text(
                                                        viaryEmotion
                                                            .emotion.message,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall
                                                            ?.apply(
                                                              fontWeightDelta:
                                                                  2,
                                                              color:
                                                                  viaryEmotion
                                                                      .emotion
                                                                      .color,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              .toList(),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
          ),
        ],
      ),
    );
  }

  moveToWriteDiaryPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const WriteViaryPage(),
        settings: const RouteSettings(name: "write_viary/"),
        fullscreenDialog: true,
      ),
    );
  }
}
