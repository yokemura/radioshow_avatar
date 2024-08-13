import 'package:audio_monitor/audio_monitor.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class AudioDeviceSelectViewState {}

class AudioDeviceSelectViewStateInitial implements AudioDeviceSelectViewState {}

class AudioDeviceSelectViewStateListLoaded implements AudioDeviceSelectViewState {
  const AudioDeviceSelectViewStateListLoaded({
    required this.devices,
  });

  final List<InputDevice> devices;
}

class AudioDeviceSelectViewStateSelected implements AudioDeviceSelectViewState {
  const AudioDeviceSelectViewStateSelected({
    required this.device,
  });

  final InputDevice device;
}