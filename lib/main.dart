import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:mic_stream/mic_stream.dart';

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
    skipTaskbar: true,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: false,
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

enum CharStatus {
  still,
  talking,
}

class MyWorld extends World with TapCallbacks {
  late final SpriteAnimation stillAnimation;
  late final SpriteAnimation talkAnimation;
  late final SpriteAnimation overAnimation;
  late final SpriteAnimationComponent avatar;

  late final StreamSubscription<List<int>> audioListener;

  CharStatus charStatus = CharStatus.still;

  double sum = 0;
  int count = 0;
  static const int countMax = 30;
  static const double threshold = 10000;

  @override
  Future<void> onLoad() async {
    // Init a new Stream
    Stream<Uint8List> stream = MicStream.microphone(
      sampleRate: 48000,
      audioFormat: AudioFormat.ENCODING_PCM_16BIT,
      channelConfig: ChannelConfig.CHANNEL_IN_MONO,
    );

// Start listening to the stream
    // Transform the stream and print each sample individually
    stream.transform(MicStream.toSampleStream).listen(_onListen);
//    audioListener = stream.listen((samples) => print(samples));

    final bgImage = await Flame.images.load('mainBG-v2.png');
    final bgSprite = Sprite(bgImage);
    add(SpriteComponent(
      sprite: bgSprite,
      size: Vector2(640, 360),
      position: Vector2.zero(),
      anchor: Anchor.center,
    ));

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

  void _onListen(dynamic values) {
    final converted = values as (int, int);
    final toAdd = (converted.$1 * converted.$1).toDouble();
    sum = sum + toAdd;
    count++;
    if (count >= countMax) {
      final average = sqrt(sum / countMax.toDouble());
      _onAverageYielded(average);
      print(average);
      count = 0;
      sum = 0;
    }
  }

  void _onAverageYielded(double average) {
    switch (charStatus) {
      case CharStatus.still:
        if (average > threshold) {
          avatar.animation = talkAnimation;
          charStatus = CharStatus.talking;
        }
      case CharStatus.talking:
        if (average < threshold) {
          avatar.animation = stillAnimation;
          charStatus = CharStatus.still;
        }
    }
  }
}
