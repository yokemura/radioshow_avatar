import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'audio_monitor_platform_interface.dart';

/// An implementation of [AudioMonitorPlatform] that uses method channels.
class MethodChannelAudioMonitor extends AudioMonitorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('audio_monitor');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
