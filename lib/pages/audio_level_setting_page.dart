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

    final audioSubscription = useOnStreamChange(
      AudioMonitor.audioLevelStream,
      onData: (value) {
        viewModel.onReceiveValue(time: DateTime.now(), value: value);
      },
    );

    final levelText = state.currentLevel.toStringAsFixed(2);

    return Scaffold(
      body: Column(
        children: [
          Text(
            'Current level: $levelText',
            style: normalTextStyle,
          ),
          _LevelView(
            levelAlreadySet: state.lowerLevel,
            myProcess: AudioLevelSettingProcess.measuringLowerLevel,
            currentProcess: state.process,
            onStartPressed: () async {
              viewModel.onStartMeasuringLower(DateTime.now());
              await Future.delayed(const Duration(seconds: 5));
              viewModel.onFinishMeasuring();
            },
          ),
          _LevelView(
            levelAlreadySet: state.upperLevel,
            myProcess: AudioLevelSettingProcess.measuringUpperLevel,
            currentProcess: state.process,
            onStartPressed: () async {
              viewModel.onStartMeasuringUpper(DateTime.now());
              await Future.delayed(const Duration(seconds: 5));
              viewModel.onFinishMeasuring();
            },
          ),
          ElevatedButton(
            onPressed: state.isReady
                ? () => Navigator.pushNamed(context, 'main')
                : null,
            child: const Text('Finish'),
          )
        ],
      ),
    );
  }
}

class _LevelView extends StatelessWidget {
  const _LevelView({
    required this.levelAlreadySet,
    required this.myProcess,
    required this.currentProcess,
    required this.onStartPressed,
  });

  final double? levelAlreadySet;
  final AudioLevelSettingProcess myProcess;
  final AudioLevelSettingProcess currentProcess;
  final VoidCallback onStartPressed;

  @override
  Widget build(BuildContext context) {
    final labelText = switch (myProcess) {
      AudioLevelSettingProcess.measuringLowerLevel => 'Background level',
      AudioLevelSettingProcess.measuringUpperLevel => 'Signal level',
      _ => '',
    };

    final isMeasuring = myProcess == currentProcess;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(labelText),
          Text(_dataText),
          ElevatedButton(
            onPressed: isMeasuring ? null : onStartPressed,
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }

  String get _dataText {
    if (currentProcess == myProcess) {
      return 'measuring...';
    }
    final level = levelAlreadySet;
    if (level == null) {
      return 'not measured';
    }
    final db = level.toStringAsFixed(2);
    return '$db dB';
  }
}
