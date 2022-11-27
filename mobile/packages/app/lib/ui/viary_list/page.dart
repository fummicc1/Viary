import 'package:domain/entities/viary.dart';
import 'package:domain/repositories/viary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viary/ui/root/notifier.dart';
import 'package:viary/ui/root/state.dart';
import 'package:domain/utils/datetime.dart';
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
                          showDialog(
                              context: context,
                              builder: (context) {
                                final TextEditingController
                                    textEditingController =
                                    TextEditingController(text: viary.message);
                                textEditingController.addListener(() {
                                  viary = viary.copyWith(
                                    message: textEditingController.text,
                                  );
                                });
                                return AlertDialog(
                                  content: TextField(
                                    controller: textEditingController,
                                    maxLines: null,
                                    scrollPhysics:
                                        const NeverScrollableScrollPhysics(),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("キャンセル"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(viaryRepositoryProvider)
                                            .update(
                                                id: viary.id ?? "",
                                                viary: viary);
                                        await ref.read(rootProvider.notifier).fetchStatus();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("保存"),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
                      viary.bestEmotion != null
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    "${viary.bestEmotion!.emotion.message}の感情",
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.apply(
                                          fontWeightDelta: 2,
                                          color:
                                              viary.bestEmotion!.emotion.color,
                                        ),
                                  ),
                                ),
                                LinearProgressIndicator(
                                  value: viary.bestEmotion!.score / 100,
                                  color: viary.bestEmotion!.emotion.color,
                                  backgroundColor: viary
                                      .bestEmotion!.emotion.color
                                      .withOpacity(0.3),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ));
          }),
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
