import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:mic_stream/mic_stream.dart';

import 'avatar.dart';

class MyWorld extends World with TapCallbacks, KeyboardHandler {
  late final StreamSubscription<List<int>> audioListener;

  // マイク検知関係
  double sum = 0;
  int count = 0;
  static const int countMax = 300;
  static const double threshold = 10000;

  // キー関係
  var isPressingKeys = false;

  // キャラ
  late final Avatar avatar;

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

    final bgImage = await Flame.images.load('mainBG-v2.png');
    final bgSprite = Sprite(bgImage);
    add(SpriteComponent(
      sprite: bgSprite,
      size: Vector2(640, 360),
      position: Vector2.zero(),
      anchor: Anchor.center,
    ));

    //
    // Make avatar
    //
    avatar = await Avatar.create(Vector2(0, 112));
    add(avatar);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    isPressingKeys = keysPressed.isNotEmpty;

    if (keysPressed.contains(LogicalKeyboardKey.keyZ)) {
      avatar.changeAnimation(AvatarStatus.talking);
    } else {
      avatar.changeAnimation(AvatarStatus.still);
    }
    return false;
  }

  void _onListen(dynamic values) {
    final converted = values as (int, int);
    final toAdd = (converted.$1 * converted.$1).toDouble();
    sum = sum + toAdd;
    count++;
    if (count >= countMax) {
      final average = sqrt(sum / countMax.toDouble());
      _onAverageYielded(average);
      // print(average);
      count = 0;
      sum = 0;
    }
  }

  void _onAverageYielded(double average) {
    if (isPressingKeys) {
      return; // キー押下中はマイクは無視
    }
    if (average > threshold) {
      avatar.changeAnimation(AvatarStatus.talking);
    } else {
      avatar.changeAnimation(AvatarStatus.still);
    }
  }
}
