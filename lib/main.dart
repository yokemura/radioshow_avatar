import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

/// This example simply adds a rotating white square on the screen.
/// If you press on a square, it will be removed.
/// If you press anywhere else, another square will be added.
void main() {
  runApp(
    GameWidget(
      game: FlameGame(world: MyWorld()),
    ),
  );
}

class MyWorld extends World with TapCallbacks {
  @override
  Future<void> onLoad() async {
    add(Square(Vector2.zero()));
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    if (!event.handled) {
      final touchPoint = event.localPosition;
      _makeSprite(touchPoint);
    }
  }

  void _makeSprite(Vector2 position) async {
    final image = await Flame.images.load('spritesheet_yoke.png');

    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(24, 40),
    );
    final animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1);

    add(SpriteAnimationComponent(
      animation: animation,
      position: position,
      size: Vector2(24, 40) * 8,
    ));
  }
}

class Square extends RectangleComponent with TapCallbacks {
  static const speed = 3;
  static const squareSize = 128.0;
  static const indicatorSize = 26.0;

  static final Paint red = BasicPalette.red.paint();
  static final Paint blue = BasicPalette.blue.paint();

  Square(Vector2 position)
      : super(
          position: position,
          size: Vector2.all(squareSize),
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(
      RectangleComponent(
        size: Vector2.all(indicatorSize),
        paint: blue,
        anchor: Anchor.center,
      ),
    );
    add(
      RectangleComponent(
        position: size / 2,
        size: Vector2.all(indicatorSize),
        anchor: Anchor.center,
        paint: red,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    angle += speed * dt;
    angle %= 2 * math.pi;
  }

  @override
  void onTapDown(TapDownEvent event) {
    removeFromParent();
    event.handled = true;
  }
}
