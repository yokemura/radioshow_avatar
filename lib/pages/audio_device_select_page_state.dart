import 'package:audio_monitor/audio_monitor.dart';
import 'package:flutter/foundation.dart';

@immutable
class AudioDeviceSelectViewState {
  const AudioDeviceSelectViewState({
    required this.devices,
    this.isSelected = false,
  });

  final List<InputDevice> devices;
  final bool isSelected;
}