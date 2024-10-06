import 'dart:async';

import 'package:audio_monitor/audio_monitor.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:radioshow_avatar/model/shared_preference_manager.dart';

import 'flame_components/play_button.dart';
import 'flame_components/avatar.dart';
import 'const.dart';
import 'flame_components/flower.dart';

class MyWorld extends World with TapCallbacks, KeyboardHandler {
  late final StreamSubscription<List<int>> audioListener;

  StreamSubscription<double>? _audioLevelSubscription;

  // 動作モード
  var isPressingKeys = false;
  var isListeningMode = false; // 曲聴き中

  // キャラ
  late final Avatar avatar;
  late final Flower flower;
  late final PlayButton playButton;
  late final SpriteComponent bgSpriteComponent;

  late final double _audioThreshold;

  @override
  Future<void> onLoad() async {
    //
    // Make background image
    //
    final bgImage = await Flame.images.load('mainBG-v2.png');
    final bgSprite = Sprite(bgImage);
    bgSpriteComponent = SpriteComponent(
      sprite: bgSprite,
      size: Vector2(640, 360),
      position: Vector2.zero(),
      anchor: Anchor.center,
      priority: ZPosition.bg,
    );
    add(bgSpriteComponent);

    //
    // Make avatar
    //
    avatar = await Avatar.create(Vector2(0, 112));
    add(avatar);

    flower = await Flower.create();
    playButton = await PlayButton.create();

    //
    // init audio listener
    //
    final levels = await SharedPreferenceManager().getAudioLevels();
    _audioThreshold = (levels!.$1 + levels.$2) / 2;

    _audioLevelSubscription =
        AudioMonitor.audioLevelStream.listen(_onListenAudio);
  }

  @override
  void onRemove() {
    _audioLevelSubscription?.cancel();
    super.onRemove();
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    isPressingKeys = keysPressed.isNotEmpty;

    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyP:
          isListeningMode = true;
          avatar.tapTempo();
          if (!contains(playButton)) {
            add(playButton);
          }
        case LogicalKeyboardKey.keyO:
          isListeningMode = false;
          if (contains(playButton)) {
            remove(playButton);
          }
        case LogicalKeyboardKey.keyT:
          if (contains(bgSpriteComponent)) {
            remove(bgSpriteComponent);
          } else {
            add(bgSpriteComponent);
          }
      }
    }

    final defaultStatus =
        isListeningMode ? AvatarStatus.listening : AvatarStatus.still;

    if (keysPressed.contains(LogicalKeyboardKey.keyX)) {
      avatar.changeAnimation(AvatarStatus.over);
    } else if (keysPressed.contains(LogicalKeyboardKey.keyZ)) {
      avatar.changeAnimation(AvatarStatus.talking);
    } else {
      avatar.changeAnimation(defaultStatus);
    }

    if (keysPressed.contains(LogicalKeyboardKey.keyQ)) {
      if (!contains(flower)) {
        add(flower);
      }
    } else {
      if (contains(flower)) {
        remove(flower);
      }
    }
    return false;
  }

  void _onListenAudio(double level) {
    if (isPressingKeys || isListeningMode) {
      return; // キー押下中・曲聴き中はマイクは無視
    }
    if (level > _audioThreshold) {
      avatar.changeAnimation(AvatarStatus.talking);
    } else {
      avatar.changeAnimation(AvatarStatus.still);
    }
  }
}
