import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../const.dart';

class PlayButton extends SpriteComponent {
  PlayButton(Sprite sprite) {
    super.sprite = sprite;
    super.size = Vector2(33, 20) * 3;
    super.anchor = Anchor.center;
    super.position = Vector2(-210, 60);
    super.priority = ZPosition.flower;
  }

  static Future<PlayButton> create() async {
    final image = await Flame.images.load('playButton.png');
    final sprite = Sprite(image);

    return PlayButton(sprite);
  }
}