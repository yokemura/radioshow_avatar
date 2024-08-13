import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_level_setting_view_state.freezed.dart';

enum AudioLevelSettingProcess {
  waitingForLowerLevel,
  measuringLowerLevel,
  waitingForUpperLevel,
  measuringUpperLevel,
  finished,
}

@freezed
class AudioLevelSettingViewState with _$AudioLevelSettingViewState {
  factory AudioLevelSettingViewState({
    required AudioLevelSettingProcess process,
    @Default([]) List<double> recordedLevels,
    DateTime? recordingFinishTime,
    double? lowerLevel,
    double? upperLevel,
  }) = _AudioLevelSettingViewState;
}