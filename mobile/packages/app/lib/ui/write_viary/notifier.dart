import 'package:domain/entities/emotion.dart';
import 'package:domain/entities/viary.dart';
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
    if (state.message.isEmpty) {
      return;
    }
    try {
      String lang = "ja";
      if ((state.currentLocaleId.contains("en"))) {
        lang = "en";
      }
      state = state.copyWith(
        isLoading: true,
      );
      Viary viary = state.viary;
      viary = viary.copyWith(
        message: state.message,
      );
      final emotionViary = await _viaryRepository.refreshEmotions(
        viary: viary,
        language: lang,
      );
      state = state.copyWith(
        viary: emotionViary,
      );
      await _viaryRepository.create(viary);
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
      message: "",
      showDetermineDialog: false,
    );
  }

  void updateLocale(LocaleName localeName) {
    state = state.copyWith(
      currentLocaleId: localeName.localeId,
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(
        viary: state.viary.copyWith(
      title: title,
    ));
  }

  void addPeriodToTemporaryWords() {
    state = state.copyWith(
      temporaryWords: state.temporaryWords +
          (state.currentLocaleId.contains("ja") ? "。" : "."),
    );
  }

  void updateDate(DateTime dateTime) {
    state = state.copyWith(
        viary: state.viary.copyWith(
      date: dateTime,
    ));
  }

  void cancelTemporaryMessage() {
    state = state.copyWith(
      temporaryWords: "",
      showDetermineDialog: false,
    );
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
      message:
          "${append ? state.message + state.temporaryWords : state.temporaryWords}. ",
      temporaryWords: "",
      isSpeeching: false,
      showDetermineDialog: false,
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
                element.localeId.contains("en-US") ||
                element.localeId.contains("ja-JP"),
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
      currentLocaleId: current?.localeId ?? "ja-JP",
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
    int cnt = 0;
    await _speechToText.listen(
        localeId: state.currentLocaleId,
        listenMode: ListenMode.dictation,
        partialResults: true,
        onResult: (SpeechRecognitionResult result) {
          if (result.finalResult) {
            state = state.copyWith(
              showDetermineDialog: true,
            );
          } else {
            final message = result.recognizedWords.characters.toList();
            message.fillRange(0, cnt, "");
            cnt = result.recognizedWords.characters.toList().length;
            state = state.copyWith(
              temporaryWords: state.temporaryWords + message.join(),
            );
          }
        });
  }

  Future stopSpeech({bool clearTemporaryWords = false}) async {
    await _speechToText.stop();
    state = state.copyWith(
      isSpeeching: false,
    );
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }
}

final writeViaryProvider =
    StateNotifierProvider.autoDispose<WriteViaryNotifier, WriteViaryState>(
        (ref) {
  final ViaryRepository viaryRepository = ref.watch(viaryRepositoryProvider);
  final viary = viaryRepository.generateNewViary();
  return WriteViaryNotifier(
    WriteViaryState(viary: viary),
    viaryRepository: viaryRepository,
  );
});
