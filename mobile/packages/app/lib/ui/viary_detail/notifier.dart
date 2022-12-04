import 'package:domain/entities/viary.dart';
import 'package:domain/repositories/viary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viary/ui/viary_detail/state.dart';

class ViaryDetailNotifier extends StateNotifier<ViaryDetailState> {
  ViaryDetailNotifier(
    ViaryDetailState state, {
    required this.viaryRepository,
  }) : super(state) {
    Future(() async {
      final viary = await getViary();
      state = state.copyWith(
        viary: viary,
      );
    });
  }

  final ViaryRepository viaryRepository;

  Future<Viary> getViary() async {
    if (state.viary != null) {
      return state.viary!;
    }
    return viaryRepository.fetch(id: state.viaryID);
  }

  updateEmotionValue({
    required ViaryEmotion emotion,
    required double value,
  }) async {
    Viary viary = await getViary();
    final emotions = List<ViaryEmotion>.from(viary.emotions);
    final i = emotions.indexWhere(
      (element) => element.emotion.index == emotion.emotion.index,
    );
    emotions[i] = emotions[i].copyWith(
      score: (value * 100).toInt(),
    );
    viary = viary.copyWith(
      emotions: emotions,
    );
    state = state.copyWith(
      viary: viary,
    );
  }

  Future<bool> save() async {
    final viary = state.viary;
    if (viary == null) {
      return false;
    }
    await viaryRepository.update(id: state.viaryID, viary: viary);
    return true;
  }

  configureIfNeeded(String viaryID) {
    if ( state.viaryID.isEmpty || state.viary == null) {
      state = state.copyWith(
        viaryID: viaryID,
      );
      Future(() async {
        final viary = await getViary();
        state = state.copyWith(
          viary: viary,
        );
      });
    }
  }
}

final viaryDetailProvider = StateNotifierProvider.autoDispose<
    ViaryDetailNotifier, ViaryDetailState>(
  (ref) {
    const state = ViaryDetailState(viaryID: "");
    final repo = ref.watch(viaryRepositoryProvider);
    return ViaryDetailNotifier(
      state,
      viaryRepository: repo,
    );
  },
);
