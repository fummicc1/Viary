import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:viary/ui/root/notifier.dart';
import 'package:viary/ui/write_viary/notifier.dart';

class WriteViaryPage extends ConsumerWidget {
  const WriteViaryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(writeViaryProvider);
    if (state.showDetermineDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("スピーチ内容"),
                content: Text(state.temporaryWords),
                actions: [
                  TextButton(
                    onPressed: () {
                      ref
                          .read(writeViaryProvider.notifier)
                          .decideMessage(append: true);
                      Navigator.of(context).pop();
                    },
                    child: const Text("追加"),
                  ),
                  TextButton(
                    onPressed: () {
                      ref
                          .read(writeViaryProvider.notifier)
                          .decideMessage(append: false);
                      Navigator.of(context).pop();
                    },
                    child: const Text("上書き"),
                  ),
                  TextButton(
                      onPressed: () {
                        ref.read(writeViaryProvider.notifier).stopSpeech();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "キャンセル",
                        style: TextStyle(
                          color: Colors.redAccent,
                        ),
                      )),
                ],
              );
            });
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("新規作成"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.viary.message,
                        style: Theme.of(context).textTheme.titleLarge?.merge(
                          const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (state.isSpeeching)
                    Column(
                      children: [
                        const Center(
                          child: Icon(
                            Icons.add,
                            size: 32,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              state.temporaryWords,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            state.isSpeeching
                                ? await ref
                                .read(writeViaryProvider.notifier)
                                .stopSpeech()
                                : await ref
                                .read(writeViaryProvider.notifier)
                                .startSpeech();
                          },
                          icon: state.isSpeeching
                              ? const Icon(Icons.mic)
                              : const Icon(Icons.mic_off),
                          label: state.isSpeeching
                              ? const Text("マイク: ON")
                              : const Text("マイク: OFF"),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: state.availableLocales.map((locale) {
                          final bool isSelected = locale == state.currentLocale;
                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(writeViaryProvider.notifier)
                                  .updateLocale(locale);
                            },
                            child: Chip(
                              backgroundColor: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.transparent,
                              label: Container(
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                child: Text(locale.name),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            state.isLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : const SizedBox(),
          ],
        ),

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await ref.read(writeViaryProvider.notifier).save();
          Future(() async {
            await ref.read(rootProvider.notifier).fetchStatus();
          });
          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
        },
        label: const Text("保存"),
        icon: const Icon(Icons.save),
      ),
    );
  }
}
