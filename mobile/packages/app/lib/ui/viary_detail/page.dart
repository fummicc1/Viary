import 'package:domain/entities/emotion.dart';
import 'package:domain/entities/viary.dart';
import 'package:domain/utils/datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viary/ui/root/notifier.dart';
import 'package:viary/ui/viary_detail/notifier.dart';
import 'package:viary/ui/viary_detail/state.dart';

class ViaryDetailPage extends ConsumerWidget {
  const ViaryDetailPage({
    Key? key,
    required this.viaryID,
  }) : super(key: key);

  final String viaryID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(viaryDetailProvider);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(viaryDetailProvider.notifier).configureIfNeeded(viaryID);
    });
    final viary = state.viary;
    if (viary == null) {
      return const Scaffold(
        body: Center(
          child: Text("エラー"),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(viary.date.format()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SelectableText(
                  viary.message,
                  style: Theme.of(context).textTheme.subtitle1?.apply(
                        fontWeightDelta: 2,
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: viary.emotions.map((viaryEmotion) {
                      return Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Slider(
                              activeColor: viaryEmotion.emotion.color,
                              inactiveColor:
                                  viaryEmotion.emotion.color.withOpacity(0.3),
                              value: viaryEmotion.score / 100,
                              onChanged: (value) async {
                                await ref
                                    .read(viaryDetailProvider.notifier)
                                    .updateEmotionValue(
                                      emotion: viaryEmotion,
                                      value: value,
                                    );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              viaryEmotion.emotion.message,
                              textAlign: TextAlign.end,
                              style:
                                  Theme.of(context).textTheme.bodySmall?.apply(
                                        fontWeightDelta: 2,
                                        color: viaryEmotion.emotion.color,
                                      ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final ok = await ref.read(viaryDetailProvider.notifier).save();
          if (ok) {
            Navigator.of(context).pop();
            await ref.read(rootProvider.notifier).fetchStatus();
          }
        },
        label: const Text("保存"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
