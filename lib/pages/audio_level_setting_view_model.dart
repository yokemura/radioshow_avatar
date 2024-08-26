import 'dart:math';

import 'package:radioshow_avatar/pages/audio_level_setting_view_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sample_statistics/sample_statistics.dart';

final audioLevelSettingViewModelProvider = StateNotifierProvider
    .autoDispose<AudioLevelSettingViewModel, AudioLevelSettingViewState>(
  (ref) => AudioLevelSettingViewModel(
    AudioLevelSettingViewState(
      process: AudioLevelSettingProcess.standby,
    ),
  ),
);

const _measuringDuration = Duration(seconds: 8);

class AudioLevelSettingViewModel
    extends StateNotifier<AudioLevelSettingViewState> {
  AudioLevelSettingViewModel(super.state);

  void onStartMeasuringLower(DateTime startTime) {
    state = state.copyWith(
      process: AudioLevelSettingProcess.measuringLowerLevel,
      recordedLevels: [],
      recordingFinishTime: startTime.add(_measuringDuration),
    );
  }

  void onFinishMeasuringLower(DateTime startTime) {
    final levels = state.recordedLevels;
    levels.removeOutliers(); // mutate list

    switch (state.process) {
      case AudioLevelSettingProcess.measuringLowerLevel:
        state = state.copyWith(
          process: AudioLevelSettingProcess.standby,
          lowerLevel: levels.reduce(max),
        );
      case AudioLevelSettingProcess.measuringUpperLevel:
        state = state.copyWith(
          process: AudioLevelSettingProcess.standby,
          upperLevel: levels.reduce(min),
        );
      default:
        break;
    }
  }

  void onStartMeasuringUpper(DateTime startTime) {
    state = state.copyWith(
      process: AudioLevelSettingProcess.measuringUpperLevel,
      recordingFinishTime: startTime.add(_measuringDuration),
      recordedLevels: [],
    );
  }

  void onFinishMeasuring() {
    List<double> levels = state.recordedLevels.map((e) => e).toList();
    levels.removeOutliers(); // mutate list

    switch (state.process) {
      case AudioLevelSettingProcess.measuringLowerLevel:
        state = state.copyWith(
          process: AudioLevelSettingProcess.standby,
          lowerLevel: levels.reduce(max),
        );
      case AudioLevelSettingProcess.measuringUpperLevel:
        state = state.copyWith(
          process: AudioLevelSettingProcess.standby,
          upperLevel: levels.reduce(min),
        );
      default:
        break;
    }
  }

  void onReceiveValue({
    required DateTime time,
    required double value,
  }) {
    state = state.copyWith(
      currentLevel: value,
    );

    final finishTime = state.recordingFinishTime;
    if (finishTime == null) {
      return; // Recording is not happening
    }

    state = state.copyWith(
      recordedLevels: state.recordedLevels + [value],
    );

    if (time.isAfter(finishTime)) {
      onFinishMeasuring();
    }
  }
}
