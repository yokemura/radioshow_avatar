import 'package:audio_monitor/audio_monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radioshow_avatar/pages/audio_level_setting_view_model.dart';
import 'package:radioshow_avatar/pages/audio_level_setting_view_state.dart';
import 'package:radioshow_avatar/styles.dart';

class AudioLevelSettingPage extends HookConsumerWidget {
  const AudioLevelSettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(audioLevelSettingViewModelProvider.notifier);
    final state = ref.watch(audioLevelSettingViewModelProvider);
    ref.listen(audioLevelSettingViewModelProvider.select((s) => s.process),
        (_, next) {
      if (next == AudioLevelSettingProcess.finished) {
        Navigator.pushNamed(context, 'main');
      }
    });

    final audioSubscription = useOnStreamChange(
      AudioMonitor.audioLevelStream,
      onData: (value) {
        viewModel.onReceiveValue(time: DateTime.now(), value: value);
      },
    );

    return Scaffold(
      body: Column(
        children: [
          Text(
            'Current level: ${state.currentLevel}',
            style: normalTextStyle,
          ),
        ],
      ),
    );
  }
}
