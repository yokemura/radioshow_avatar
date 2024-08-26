import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_level_setting_view_state.freezed.dart';

enum AudioLevelSettingProcess {
  standby,
  measuringLowerLevel,
  measuringUpperLevel,
}

@freezed
class AudioLevelSettingViewState with _$AudioLevelSettingViewState {
  factory AudioLevelSettingViewState({
    required AudioLevelSettingProcess process,
    @Default([]) List<double> recordedLevels,
    @Default(0) double currentLevel,
    DateTime? recordingFinishTime,
    double? lowerLevel,
    double? upperLevel,
  }) = _AudioLevelSettingViewState;
}

extension IsReady on AudioLevelSettingViewState {
  bool get isReady => lowerLevel != null && upperLevel != null;
}
