import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_test/helpers/knows_game_size.dart';
import 'package:flame_test/ray_world_game.dart';

class WorldCollidable extends PositionComponent
    with HasGameRef<RayWorldGame>, KnowsGameSize, CollisionCallbacks {
  WorldCollidable() {
    // addHitbox(HitboxRectangle());
    add(RectangleHitbox());
  }
}
