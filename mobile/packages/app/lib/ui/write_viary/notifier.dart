import 'package:domain/repositories/viary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:viary/ui/write_viary/state.dart';

class WriteViaryNotifier extends StateNotifier<WriteViaryState> {
  WriteViaryNotifier(
    WriteViaryState state, {
    required ViaryRepository viaryRepository,
  })  : _viaryRepository = viaryRepository,
        super(state) {
    Future(() async {
      await _setupSpeech();
    });
  }

  final ViaryRepository _viaryRepository;
  final SpeechToText _speechToText = SpeechToText();

  Future save() async {
    if (state.isLoading) {
      return;
    }
    try {
      String lang = "ja";
      if ((state.currentLocale?.localeId.contains("en") ?? false)) {
        lang = "en";
      }
      state = state.copyWith(
        isLoading: true,
      );
      final emotionViary = await _viaryRepository.refreshEmotions(
        viary: state.viary,
        language: lang,
      );
      state = state.copyWith(
        viary: emotionViary,
      );
      await _viaryRepository.create(state.viary);
    } catch (e) {
      print(e);
      state = state.copyWith(
        isLoading: false,
      );
    }
    _clearState();
  }

  void _clearState() {
    state = state.copyWith(
      isSpeeching: false,
      isLoading: false,
      temporaryWords: "",
      showDetermineDialog: false,
    );
  }

  void updateLocale(LocaleName localeName) {
    state = state.copyWith(
      currentLocale: localeName,
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(
        viary: state.viary.copyWith(
      title: title,
    ));
  }

  void updateDate(DateTime dateTime) {
    state = state.copyWith(
        viary: state.viary.copyWith(
      date: dateTime,
    ));
  }

  void directlyEditMessage(String message) {
    state = state.copyWith(
      viary: state.viary.copyWith(
        message: message,
      ),
    );
  }

  void decideMessage({required bool append}) {
    state = state.copyWith(
      viary: state.viary.copyWith(
        message:
            "${append ? state.viary.message + state.temporaryWords : state.temporaryWords}\n",
      ),
    );
    Future(() async {
      await stopSpeech();
    });
  }

  Future _setupSpeech() async {
    await _speechToText.initialize(onError: (error) {
      debugPrint(error.errorMsg);
    }, onStatus: (status) {
      debugPrint("Recognition Status: $status");
    });
    List<LocaleName> avaiables;
    try {
      avaiables = await _speechToText.locales();
      avaiables = List<LocaleName>.from(avaiables)
          .where(
            (element) =>
                element.localeId.contains("en") ||
                element.localeId.contains("ja"),
          )
          .toList()
          .reversed
          .toList();
    } catch (e) {
      debugPrint(e.toString());
      avaiables = [];
    }
    final LocaleName? current = await _speechToText.systemLocale();
    state = state.copyWith(
      currentLocale: current,
      availableLocales: avaiables,
    );
  }

  Future startSpeech() async {
    if (!_speechToText.isAvailable) {
      await _setupSpeech();
    }
    state = state.copyWith(
      isSpeeching: true,
    );
    await _speechToText.listen(
        localeId: state.currentLocale?.localeId ?? "ja_JP",
        pauseFor: const Duration(seconds: 3),
        listenMode: ListenMode.dictation,
        onResult: (SpeechRecognitionResult result) {
          final message = result.recognizedWords;
          state = state.copyWith(temporaryWords: message);
          if (result.finalResult) {
            String suffix = ".";
            if (state.currentLocale?.localeId == "ja-JP") {
              suffix = "。";
            }
            state = state.copyWith(
              temporaryWords: message + suffix,
            );
            state = state.copyWith(
              showDetermineDialog: true,
            );
          }
        });
  }

  Future stopSpeech() async {
    await _speechToText.stop();
    state = state.copyWith(
      temporaryWords: "",
      isSpeeching: false,
      showDetermineDialog: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    stopSpeech();
  }
}

final writeViaryProvider =
    StateNotifierProvider<WriteViaryNotifier, WriteViaryState>((ref) {
  final ViaryRepository viaryRepository = ref.watch(viaryRepositoryProvider);
  final viary = viaryRepository.generateNewViary();
  return WriteViaryNotifier(
    WriteViaryState(viary: viary),
    viaryRepository: viaryRepository,
  );
});
