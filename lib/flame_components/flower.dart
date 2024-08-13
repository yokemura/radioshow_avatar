import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:radioshow_avatar/const.dart';

class Flower extends SpriteAnimationComponent {
  Flower({
    required super.animation,
  }) {
    super.size = Vector2(694, 338);
    super.anchor = Anchor.center;
    super.position = Vector2(0, -100);
    super.priority = ZPosition.flower;
  }

  static Future<Flower> create() async {
    final image = await Flame.images.load('spritesheet_hana.png');

    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(694, 338),
    );

    final frames = List<int>.generate(12, (i) => i)
        .map((i) => spriteSheet.createFrameDataFromId(i, stepTime: 0.12))
        .toList();

    final data = SpriteAnimationData(frames);
    final anim = SpriteAnimation.fromFrameData(image, data);
    final flower = Flower(animation: anim);

    return flower;
  }
}
