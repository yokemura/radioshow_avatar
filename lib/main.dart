import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Must add this line.
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(640, 360),
    backgroundColor: Colors.white,
    skipTaskbar: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(
    GameWidget(
      game: FlameGame(world: MyWorld()),
    ),
  );
}

class MyWorld extends World with TapCallbacks {
  late final SpriteAnimation stillAnimation;
  late final SpriteAnimation talkAnimation;
  late final SpriteAnimation overAnimation;
  late final SpriteAnimationComponent avatar;

  @override
  Future<void> onLoad() async {
    _makeSprite(Vector2(0, 80));
//    add(Square(Vector2.zero()));
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      // final touchPoint = event.localPosition;
      avatar.animation = talkAnimation;
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    if (!event.handled) {
      avatar.animation = stillAnimation;
    }
  }

  void _makeSprite(Vector2 position) async {
    final image = await Flame.images.load('spritesheet_yoke.png');

    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(24, 40),
    );

    stillAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData([
        spriteSheet.createFrameDataFromId(0, stepTime: 0.1),
      ]),
    );

    talkAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData([
        spriteSheet.createFrameDataFromId(3, stepTime: 0.08),
        spriteSheet.createFrameDataFromId(4, stepTime: 0.08),
        spriteSheet.createFrameDataFromId(3, stepTime: 0.08),
        spriteSheet.createFrameDataFromId(0, stepTime: 0.08),
      ]),
    );

    overAnimation = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData([
        spriteSheet.createFrameDataFromId(5, stepTime: 0.06),
        spriteSheet.createFrameDataFromId(6, stepTime: 0.06),
        spriteSheet.createFrameDataFromId(5, stepTime: 0.06),
        spriteSheet.createFrameDataFromId(0, stepTime: 0.06),
      ]),
    );

    avatar = SpriteAnimationComponent(
      animation: stillAnimation,
      position: position,
      size: Vector2(24, 40) * 8,
      anchor: Anchor.center,
    );

    add(avatar);
  }
}
