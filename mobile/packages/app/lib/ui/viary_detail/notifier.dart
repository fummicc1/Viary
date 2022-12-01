import 'package:domain/entities/viary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viary/ui/viary_detail/state.dart';

class ViaryDetailNotifier extends StateNotifier<ViaryDetailState> {
  ViaryDetailNotifier(ViaryDetailState state) : super(state);
}

final viaryDetailProvider = AutoDisposeStateNotifierProviderFamily<
    ViaryDetailNotifier, ViaryDetailState, Viary>(
  (ref, viary) {
    final state = ViaryDetailState(viary: viary);
    return ViaryDetailNotifier(state);
  },
);
