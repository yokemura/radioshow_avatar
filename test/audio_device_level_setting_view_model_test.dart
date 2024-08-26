import 'package:flutter_test/flutter_test.dart';
import 'package:radioshow_avatar/pages/audio_level_setting_view_model.dart';
import 'package:radioshow_avatar/pages/audio_level_setting_view_state.dart';

void main() {
  test('', () {
    final viewModel = AudioLevelSettingViewModel(
      AudioLevelSettingViewState(
          process: AudioLevelSettingProcess.standby),
    );

    final date1 = DateTime(2024, 12, 31, 23, 59, 0);

    // Received level value will be ignored unless measuring is not started
    viewModel.onReceiveValue(time: date1, value: 1);
    expect(viewModel.state.recordedLevels, []);

    // Start measuring lower
    viewModel.onStartMeasuringLower(date1);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringLowerLevel);
    expect(viewModel.state.recordedLevels, []);
    expect(viewModel.state.recordingFinishTime,
        date1.add(const Duration(seconds: 8)));

    DateTime now = date1.add(const Duration(seconds: 1));
    viewModel.onReceiveValue(time: now, value: 1);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringLowerLevel);

    now = date1.add(const Duration(seconds: 2));
    viewModel.onReceiveValue(time: now, value: 2);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringLowerLevel);

    now = date1.add(const Duration(seconds: 3));
    viewModel.onReceiveValue(time: now, value: 1);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringLowerLevel);

    now = date1.add(const Duration(seconds: 4));
    viewModel.onReceiveValue(time: now, value: 2);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringLowerLevel);

    now = date1.add(const Duration(seconds: 5));
    viewModel.onReceiveValue(time: now, value: 1);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringLowerLevel);

    now = date1.add(const Duration(seconds: 6));
    viewModel.onReceiveValue(time: now, value: 20); // Outlier
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringLowerLevel);

    // End measuring lower
    now = date1.add(const Duration(seconds: 9));
    viewModel.onReceiveValue(time: now, value: 2);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.standby);
    expect(viewModel.state.lowerLevel, 2); // maximum value excluding outliers

    // Start measuring upper
    viewModel.onStartMeasuringUpper(date1);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringUpperLevel);
    expect(viewModel.state.recordedLevels, []);
    expect(viewModel.state.recordingFinishTime,
        date1.add(const Duration(seconds: 8)));

    now = date1.add(const Duration(seconds: 1));
    viewModel.onReceiveValue(time: now, value: 20);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringUpperLevel);

    now = date1.add(const Duration(seconds: 2));
    viewModel.onReceiveValue(time: now, value: 21);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringUpperLevel);

    now = date1.add(const Duration(seconds: 3));
    viewModel.onReceiveValue(time: now, value: 20);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringUpperLevel);

    now = date1.add(const Duration(seconds: 4));
    viewModel.onReceiveValue(time: now, value: 21);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringUpperLevel);

    now = date1.add(const Duration(seconds: 5));
    viewModel.onReceiveValue(time: now, value: 20);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringUpperLevel);

    now = date1.add(const Duration(seconds: 6));
    viewModel.onReceiveValue(time: now, value: 0); // Outlier
    expect(
        viewModel.state.process, AudioLevelSettingProcess.measuringUpperLevel);

    // End measuring lower
    now = date1.add(const Duration(seconds: 9));
    viewModel.onReceiveValue(time: now, value: 21);
    expect(
        viewModel.state.process, AudioLevelSettingProcess.standby);
    expect(viewModel.state.lowerLevel, 2);
    expect(viewModel.state.upperLevel, 20); // minimum value excluding outliers
  });
}
