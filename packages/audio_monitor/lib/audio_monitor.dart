
import 'audio_monitor_platform_interface.dart';

class AudioMonitor {
  Future<String?> getPlatformVersion() {
    return AudioMonitorPlatform.instance.getPlatformVersion();
  }
}
