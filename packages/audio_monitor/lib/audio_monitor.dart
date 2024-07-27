
import 'package:flutter/services.dart';

import 'audio_monitor_platform_interface.dart';

class InputDevice {
  final int id;
  final String name;

  InputDevice(this.id, this.name);
}

class AudioMonitor {
  Future<String?> getPlatformVersion() {
    return AudioMonitorPlatform.instance.getPlatformVersion();
  }

  static const MethodChannel _channel = MethodChannel('audio_monitor');
  static const EventChannel _eventChannel = EventChannel('audio_monitor_level');

  static Future<List<InputDevice>> getAudioDevices() async {
    final List<dynamic> devices = await _channel.invokeMethod('getAudioDevices');
    final ret = devices.map((e) {
      final dic = e.cast<String, dynamic>();
      final id = dic['id'] as int;
      final name = dic['name'] as String;
      return InputDevice(id, name);
    });
    return ret.toList();
  }

  static Future<String> startMonitoring(int deviceId) async {
    final String result = await _channel.invokeMethod('startMonitoring', {'deviceId': deviceId});
    return result;
  }

  static Future<String> stopMonitoring() async {
    final String result = await _channel.invokeMethod('stopMonitoring');
    return result;
  }

  static Stream<double> get audioLevelStream {
    return _eventChannel.receiveBroadcastStream().map((event) => event as double);
  }
}
