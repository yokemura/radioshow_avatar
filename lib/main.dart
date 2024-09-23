import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radioshow_avatar/pages/audio_device_select_page.dart';
import 'package:radioshow_avatar/pages/audio_level_setting_page.dart';
import 'package:radioshow_avatar/world.dart';
import 'package:window_manager/window_manager.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  const windowSize = Size(640, 360);
  WindowOptions windowOptions = const WindowOptions(
    size: windowSize,
    minimumSize: windowSize,
    maximumSize: windowSize,
    backgroundColor: Colors.white,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    ProviderScope(
      child: MaterialApp(
        home: const AudioDeviceSelectPage(),
        routes: <String, WidgetBuilder> {
          'deviceSelect': (BuildContext context) => const AudioDeviceSelectPage(),
          'audioLevelSetting': (BuildContext context) => const AudioLevelSettingPage(),
          'main': (BuildContext context) {

            return GameWidget(
            game: MyGame(),
          );
          },
        },
      ),
    ),
  );
}

class MyGame extends FlameGame with HasKeyboardHandlerComponents {
  MyGame() : super(world: MyWorld());

  @override
  Color backgroundColor() {
    return const Color(0xFF00FF00);
  }
}
