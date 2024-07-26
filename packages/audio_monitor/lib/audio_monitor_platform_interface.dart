import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'audio_monitor_method_channel.dart';

abstract class AudioMonitorPlatform extends PlatformInterface {
  /// Constructs a AudioMonitorPlatform.
  AudioMonitorPlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioMonitorPlatform _instance = MethodChannelAudioMonitor();

  /// The default instance of [AudioMonitorPlatform] to use.
  ///
  /// Defaults to [MethodChannelAudioMonitor].
  static AudioMonitorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AudioMonitorPlatform] when
  /// they register themselves.
  static set instance(AudioMonitorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
