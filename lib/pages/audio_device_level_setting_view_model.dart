import 'dart:math';

import 'package:radioshow_avatar/pages/audio_level_setting_view_state.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sample_statistics/sample_statistics.dart';

final audioDeviceLevelSettingViewModelProvider = StateNotifierProvider
    .autoDispose<AudioDeviceLevelSettingViewModel, AudioLevelSettingViewState>(
  (ref) => AudioDeviceLevelSettingViewModel(
    AudioLevelSettingViewState(
      process: AudioLevelSettingProcess.measuringLowerLevel,
    ),
  ),
);

const _measuringDuration = Duration(seconds: 8);

class AudioDeviceLevelSettingViewModel
    extends StateNotifier<AudioLevelSettingViewState> {
  AudioDeviceLevelSettingViewModel(super.state);

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
          process: AudioLevelSettingProcess.waitingForUpperLevel,
          lowerLevel: levels.reduce(max),
        );
      case AudioLevelSettingProcess.measuringUpperLevel:
        state = state.copyWith(
          process: AudioLevelSettingProcess.finished,
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
    final levels = state.recordedLevels;
    levels.removeOutliers(); // mutate list

    switch (state.process) {
      case AudioLevelSettingProcess.measuringLowerLevel:
        state = state.copyWith(
          process: AudioLevelSettingProcess.waitingForUpperLevel,
          lowerLevel: levels.reduce(max),
        );
      case AudioLevelSettingProcess.measuringUpperLevel:
        state = state.copyWith(
          process: AudioLevelSettingProcess.finished,
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
    final finishTime = state.recordingFinishTime;
    if (finishTime == null) {
      return; // Recording is not happening
    }
    AudioLevelSettingProcess process = state.process;
    if (time.isAfter(finishTime)) {
      process = switch (process) {
        AudioLevelSettingProcess.measuringLowerLevel =>
          AudioLevelSettingProcess.waitingForUpperLevel,
        AudioLevelSettingProcess.measuringUpperLevel =>
          AudioLevelSettingProcess.finished,
        _ => process,
      };
    }

    state = state.copyWith(
      process: process,
      recordedLevels: state.recordedLevels + [value],
    );
  }
}
