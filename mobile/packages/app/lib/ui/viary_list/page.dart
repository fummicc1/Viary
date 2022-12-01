import 'package:domain/entities/viary.dart';
import 'package:domain/repositories/viary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viary/ui/root/notifier.dart';
import 'package:viary/ui/root/state.dart';
import 'package:domain/utils/datetime.dart';
import 'package:viary/ui/viary_detail/page.dart';
import 'package:viary/ui/viary_detail/state.dart';
import 'package:viary/ui/write_viary/page.dart';
import 'package:domain/entities/emotion.dart';

class ViaryListPage extends ConsumerWidget {
  const ViaryListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RootState rootState = ref.watch(rootProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("一覧"),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: rootState.viaries.length,
        itemBuilder: (context, index) {
          Viary viary = rootState.viaries[index];
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: [
                    ListTile(
                      title: Text(viary.title),
                      subtitle: Text(viary.message),
                      trailing: Text(viary.date.format()),
                      onTap: () {
                        final route = MaterialPageRoute(
                          builder: (context) => ViaryDetailPage(
                            viaryID: viary.id!,
                          ),
                          settings: const RouteSettings(name: "viary_detail/"),
                        );
                        Navigator.of(context).push(route);
                      },
                    ),
                    viary.emotions.isNotEmpty
                        ? Column(
                            children: viary.emotions
                                .toList()
                                .map(
                                  (viaryEmotion) => Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: LinearProgressIndicator(
                                          value: viaryEmotion.score / 100,
                                          color: viaryEmotion.emotion.color,
                                          backgroundColor: viaryEmotion
                                              .emotion.color
                                              .withOpacity(0.3),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          viaryEmotion.emotion.message,
                                          textAlign: TextAlign.end,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.apply(
                                                fontWeightDelta: 2,
                                                color:
                                                    viaryEmotion.emotion.color,
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
              ));
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const WriteViaryPage(),
              settings: const RouteSettings(name: "write_viary/"),
              fullscreenDialog: true,
            ),
          );
        },
        label: const Text("日記を書く"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
