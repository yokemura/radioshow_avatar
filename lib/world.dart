import 'dart:async';
import 'dart:math';

import 'package:audio_monitor/audio_monitor.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flutter/services.dart';
import 'package:mic_stream/mic_stream.dart';

import 'flame_components/play_button.dart';
import 'flame_components/avatar.dart';
import 'const.dart';
import 'flame_components/flower.dart';

class MyWorld extends World with TapCallbacks, KeyboardHandler {
  late final StreamSubscription<List<int>> audioListener;

  // マイク検知関係
  double sum = 0;
  int count = 0;
  static const int countMax = 300;
  static const double threshold = 10000;
  StreamSubscription<double>? _audioLevelSubscription;

  // 動作モード
  var isPressingKeys = false;
  var isListeningMode = false; // 曲聴き中

  // キャラ
  late final Avatar avatar;
  late final Flower flower;
  late final PlayButton playButton;
  late final SpriteComponent bgSpriteComponent;

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

    final devices = await AudioMonitor.getAudioDevices();

    _audioLevelSubscription = AudioMonitor.audioLevelStream.listen((event) {
      print(event);
    });

    final device = devices.firstWhere((element) => element.name.contains('AG'));
    AudioMonitor.startMonitoring(device.id);
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
    if (isPressingKeys || isListeningMode) {
      return; // キー押下中・曲聴き中はマイクは無視
    }
    if (average > threshold) {
      avatar.changeAnimation(AvatarStatus.talking);
    } else {
      avatar.changeAnimation(AvatarStatus.still);
    }
  }
}
