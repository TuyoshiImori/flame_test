import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
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
    required this.length,
    Color? color,
  })  : color = color ?? Colors.greenAccent,
        super(
          anchor: Anchor.center,
          size: Vector2.all(length),
        );
  late double length;
  late Color color;

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

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    List<Vector2> points = [
      Vector2(0, 0),
      Vector2(50, 0),
      Vector2(50, 50),
      Vector2(0, 50)
    ];
    final shapes = PolygonHitbox(points);
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shapes);
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

    //
  }
}
