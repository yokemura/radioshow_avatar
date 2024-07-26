//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audio_monitor
import mic_stream
import screen_retriever
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioMonitorPlugin.register(with: registry.registrar(forPlugin: "AudioMonitorPlugin"))
  MicStreamPlugin.register(with: registry.registrar(forPlugin: "MicStreamPlugin"))
  ScreenRetrieverPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
