import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

enum AvatarStatus {
  still,
  talking,
  over,
}

class Avatar extends SpriteAnimationComponent {
  Avatar({
    required this.stillAnimation,
    required this.talkAnimation,
    required this.overAnimation,
    required super.position,
  }) {
    super.animation = stillAnimation;
    super.size = Vector2(24, 40) * 7.5;
    super.anchor = Anchor.center;
  }

  final SpriteAnimation stillAnimation;
  final SpriteAnimation talkAnimation;
  final SpriteAnimation overAnimation;

  AvatarStatus status = AvatarStatus.still;

  static Future<Avatar> create(Vector2 position) async {
    final image = await Flame.images.load('spritesheet_yoke.png');

    final spriteSheet = SpriteSheet(
      image: image,
      srcSize: Vector2(24, 40),
    );

    final stillAnim = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData([
        spriteSheet.createFrameDataFromId(0, stepTime: 0.1),
      ]),
    );

    final talkAnim = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData([
        spriteSheet.createFrameDataFromId(3, stepTime: 0.08),
        spriteSheet.createFrameDataFromId(4, stepTime: 0.08),
        spriteSheet.createFrameDataFromId(3, stepTime: 0.08),
        spriteSheet.createFrameDataFromId(0, stepTime: 0.08),
      ]),
    );

    final overAnim = SpriteAnimation.fromFrameData(
      image,
      SpriteAnimationData([
        spriteSheet.createFrameDataFromId(5, stepTime: 0.06),
        spriteSheet.createFrameDataFromId(6, stepTime: 0.06),
        spriteSheet.createFrameDataFromId(5, stepTime: 0.06),
        spriteSheet.createFrameDataFromId(4, stepTime: 0.06),
      ]),
    );

    final avatar = Avatar(
        stillAnimation: stillAnim,
        talkAnimation: talkAnim,
        overAnimation: overAnim,
        position: position);

    return avatar;
  }

  void changeAnimation(AvatarStatus newStatus) {
    if (newStatus == status) {
      return;
    }
    status = newStatus;
    switch (status) {
      case AvatarStatus.still:
        animation = stillAnimation;
      case AvatarStatus.talking:
        animation = talkAnimation;
      case AvatarStatus.over:
        animation = overAnimation;
    }
  }
}
