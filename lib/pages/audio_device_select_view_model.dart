import 'package:audio_monitor/audio_monitor.dart';
import 'package:radioshow_avatar/pages/audio_device_select_page_state.dart';
import 'package:riverpod/riverpod.dart';

final audioDeviceSelectViewModelProvider = StateNotifierProvider.autoDispose<
    AudioDeviceSelectViewModel, AudioDeviceSelectViewState>(
  (ref) => AudioDeviceSelectViewModel(
    const AudioDeviceSelectViewState(devices: []),
  ),
);

class AudioDeviceSelectViewModel
    extends StateNotifier<AudioDeviceSelectViewState> {
  AudioDeviceSelectViewModel(super.state);

  void getDevices() async {
    final devices = await AudioMonitor.getAudioDevices();
    state = AudioDeviceSelectViewState(
      devices: devices,
    );
  }

  void onDeviceSelected(InputDevice device) {
    AudioMonitor.startMonitoring(device.id);
    state = AudioDeviceSelectViewState(
      devices: state.devices,
      isSelected: true,
    );
  }
}
