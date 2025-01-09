//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import audio_monitor
import permission_handler_apple
import screen_retriever
import shared_preferences_foundation
import window_manager

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AudioMonitorPlugin.register(with: registry.registrar(forPlugin: "AudioMonitorPlugin"))
  PermissionHandlerPlugin.register(with: registry.registrar(forPlugin: "PermissionHandlerPlugin"))
  ScreenRetrieverPlugin.register(with: registry.registrar(forPlugin: "ScreenRetrieverPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  WindowManagerPlugin.register(with: registry.registrar(forPlugin: "WindowManagerPlugin"))
}
