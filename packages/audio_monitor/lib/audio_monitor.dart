
import 'package:flutter/services.dart';

import 'audio_monitor_platform_interface.dart';

class AudioMonitor {
  Future<String?> getPlatformVersion() {
    return AudioMonitorPlatform.instance.getPlatformVersion();
  }

  static const MethodChannel _channel = MethodChannel('audio_monitor');

  static Future<List<String>> getAudioDevices() async {
    final List<dynamic> devices = await _channel.invokeMethod('getAudioDevices');
    return devices.cast<String>();
  }

  static Future<String> startMonitoring() async {
    final String result = await _channel.invokeMethod('startMonitoring');
    return result;
  }

  static Future<String> stopMonitoring() async {
    final String result = await _channel.invokeMethod('stopMonitoring');
    return result;
  }
}
