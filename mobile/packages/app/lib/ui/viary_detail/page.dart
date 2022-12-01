import 'package:domain/entities/viary.dart';
import 'package:domain/utils/datetime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viary/ui/viary_detail/notifier.dart';

class ViaryDetailPage extends ConsumerWidget {
  ViaryDetailPage({
    Key? key,
    required this.viary,
  }) : super(key: key);

  final Viary viary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(viaryDetailProvider(this.viary));
    final viary = state.viary;
    return Scaffold(
      appBar: AppBar(
        title: Text(viary.date.format()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                viary.message,
                style: Theme.of(context).textTheme.subtitle1?.apply(
                      fontWeightDelta: 2,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
