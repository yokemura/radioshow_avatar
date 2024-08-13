import 'package:audio_monitor/audio_monitor.dart';
import 'package:radioshow_avatar/pages/audio_device_select_page_state.dart';
import 'package:riverpod/riverpod.dart';

final audioDeviceSelectViewModelProvider = StateNotifierProvider.autoDispose<
        AudioDeviceSelectViewModel, AudioDeviceSelectViewState>(
    (ref) => AudioDeviceSelectViewModel(AudioDeviceSelectViewStateInitial()));

class AudioDeviceSelectViewModel
    extends StateNotifier<AudioDeviceSelectViewState> {
  AudioDeviceSelectViewModel(super.state);

  void getDevices() async {
    final devices = await AudioMonitor.getAudioDevices();
    state = AudioDeviceSelectViewStateListLoaded(
      devices: devices,
    );
  }

  void onDeviceSelected(InputDevice device) {
    AudioMonitor.startMonitoring(device.id);
    state = AudioDeviceSelectViewStateSelected(device: device);
  }
}
