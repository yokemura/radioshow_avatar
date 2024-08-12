import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/rendering.dart';
import 'package:flame/sprite.dart';
import 'package:radioshow_avatar/const.dart';
import 'package:radioshow_avatar/tempo_calculator.dart';

enum AvatarStatus {
  still,
  talking,
  over,
  listening,
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
    super.priority = ZPosition.avatar;
  }

  final SpriteAnimation stillAnimation;
  final SpriteAnimation talkAnimation;
  final SpriteAnimation overAnimation;

  AvatarStatus status = AvatarStatus.still;
  double listeningMovementCount = 0;

  late Transform2DDecorator transDeco;
  DateTime tickEndTime = DateTime.fromMicrosecondsSinceEpoch(0);
  DateTime nextCycleStartTime = DateTime.fromMicrosecondsSinceEpoch(0);
  Duration listeningMovementCycle = Duration.zero;
  static const Duration tickDuration = Duration(milliseconds: 100);
  final calculator = TempoCalculator();

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
      case AvatarStatus.listening:
        animation = stillAnimation;
    }
  }

  void tapTempo() {
    final now = DateTime.now();
    tickEndTime = now.add(tickDuration);

    final newDur = calculator.addTap(now);
    nextCycleStartTime = now.add(newDur);
    listeningMovementCycle = newDur;
  }

  @override
  void onMount() {
    super.onMount();

    final trans = Transform2D()..position = Vector2.zero();
    transDeco = Transform2DDecorator(trans);

    decorator.addLast(transDeco);
  }

  @override
  void update(double dt) {
    super.update(dt);

    var amount = Vector2.zero();

    switch (status) {
      case AvatarStatus.listening:
        final now = DateTime.now();
        if (now.isBefore(tickEndTime)) {
          amount = Vector2(0, -7);
        } else if (now.isBefore(nextCycleStartTime)) {
          amount = Vector2.zero();
        } else {
          tickEndTime = nextCycleStartTime.add(tickDuration);
          nextCycleStartTime = nextCycleStartTime.add(listeningMovementCycle);
          amount = Vector2(0, -7);
        }
      default:
        amount = Vector2.zero();
    }
    transDeco.transform2d.position = amount;
  }
}
