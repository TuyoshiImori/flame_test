import 'package:flame/components.dart';
import 'package:flame_test/ray_world_game.dart';
import 'package:flutter/material.dart';

class DialogueTextComponent extends TextBoxComponent
    with HasGameRef<RayWorldGame> {
  DialogueTextComponent()
      : super(
            size: Vector2(800, 160),
            boxConfig: TextBoxConfig(maxWidth: 800, timePerChar: 0.05));

  @override
  void render(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, width, height);
    c.drawRect(rect, Paint()..color = const Color.fromARGB(180, 63, 63, 63));
    super.render(c);
  }

  @override
  void update(double dt) {
    text = '';
    super.update(dt);
  }
}
