import 'package:flutter_test/flutter_test.dart';
import 'package:audio_monitor/audio_monitor.dart';
import 'package:audio_monitor/audio_monitor_platform_interface.dart';
import 'package:audio_monitor/audio_monitor_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAudioMonitorPlatform
    with MockPlatformInterfaceMixin
    implements AudioMonitorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AudioMonitorPlatform initialPlatform = AudioMonitorPlatform.instance;

  test('$MethodChannelAudioMonitor is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAudioMonitor>());
  });

  test('getPlatformVersion', () async {
    AudioMonitor audioMonitorPlugin = AudioMonitor();
    MockAudioMonitorPlatform fakePlatform = MockAudioMonitorPlatform();
    AudioMonitorPlatform.instance = fakePlatform;

    expect(await audioMonitorPlugin.getPlatformVersion(), '42');
  });
}
