import 'dart:async';

import 'package:domain/entities/user.dart';
import 'package:domain/entities/viary.dart';
import 'package:domain/repositories/user.dart';
import 'package:domain/repositories/viary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viary/ui/root/state.dart';
import 'package:viary/ui/viary_list/page.dart';
import 'package:viary/ui/write_viary/page.dart';

import 'notifier.dart';

class RootPage extends ConsumerWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(rootProvider.notifier).setup();
    });
    final RootState rootState = ref.watch(rootProvider);
    if (rootState.viaries.isEmpty) {
      return const WriteViaryPage();
    } else {
      return const ViaryListPage();
    }
  }
}
