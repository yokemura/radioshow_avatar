import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

class Flower extends SpriteAnimationComponent {
  Flower({
    required super.animation,
  }) {
    super.size = Vector2(694, 338);
    super.anchor = Anchor.center;
    super.position = Vector2(0, 0);
  }

  static Future<Flower> create() async {
    final image = await Flame.images.load('spritesheet_hana.png');

    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(694, 338),
    );
    final anim = spriteSheet.createAnimation(row: 0, stepTime: 0.3);

    final flower = Flower(animation: anim);

    return flower;
  }
}
