import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame_test/components/player.dart';
import 'package:flame_test/helpers/knows_game_size.dart';
import 'package:flame_test/ray_world_game.dart';
import 'package:flutter/material.dart';

class Enemy extends PositionComponent
    with
        KnowsGameSize,
        CollisionCallbacks,
        HasGameRef<RayWorldGame>,
        KeyboardHandler {
  Enemy({
    this.length = 50,
    Color? color,
  })  : color = color ?? Colors.greenAccent,
        super(
          anchor: Anchor.center,
          size: Vector2.all(length),
        );
  late double length;
  late Color color;

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(
      1200,
      1000,
    );

    // clearEffects();
    // addEffect(MoveEffect(
    //   path: [
    //     Vector2(-200.0, 0.0),
    //     Vector2(400.0, 0.0),
    //     Vector2(-200.0, 0.0),
    //   ],
    //   duration: 5.0,
    //   curve: Curves.linear,
    //   isInfinite: true,
    //   isAlternating: true,
    //   isRelative: true,
    // ));
  }

  @override
  void onMount() {
    super.onMount();
    // オブジェクトのサイズと同じ衝突判定
    final shape = RectangleHitbox(
      size: Vector2(size.x + 30, size.y + 30),
      anchor: Anchor.center,
      position: size / 2,
    );
    add(shape);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, length, length),
      Paint()..color = color,
    );
  }

  /// 接触したときの処理
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Player) {
      color = Colors.red;
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    color = Colors.greenAccent;
  }
}
