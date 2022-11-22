import 'dart:async';

import 'package:domain/entities/user.dart';
import 'package:domain/repositories/user.dart';
import 'package:domain/repositories/viary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viary/ui/root/state.dart';

class RootStateNotifier extends StateNotifier<RootState> {
  RootStateNotifier(
    RootState state, {
    required final UserRepository userRepository,
    required final ViaryRepository viaryRepository,
  })  : _userRepository = userRepository,
        _viaryRepository = viaryRepository,
        super(state);

  Future setup() async {
    User? me = await _userRepository.fetchMe();
    if (me == null) {
      await _userRepository.createMe();
      me = await _userRepository.fetchMe();
    }
    state = state.copyWith(
      isSignedIn: me != null,
    );
    final ref = _viaryRepository.collectionReference;
    final query = ref.where("sender", isEqualTo: me!.id);
    final viaries = await _viaryRepository.fetchQuery(query: query);
    state = state.copyWith(
      viaries: viaries,
    );
  }

  StreamSubscription? _subscription;
  final ViaryRepository _viaryRepository;
  final UserRepository _userRepository;

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}

final rootProvider = StateNotifierProvider<RootStateNotifier, RootState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  final viaryRepository = ref.watch(viaryRepositoryProvider);
  const initialState = RootState();
  return RootStateNotifier(
    initialState,
    userRepository: userRepository,
    viaryRepository: viaryRepository,
  );
});
