import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';
import 'components/world.dart';
import 'components/world_collidable.dart';
import 'helpers/direction.dart';

class RayWorldGame extends FlameGame
    with HasDraggables, HasTappables, HasCollisionDetection, KeyboardEvents {
  // final Player _player = Player();
  late Player _player;
  final World _world = World();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_world);

    // Create a basic joystick component on left.
    final joystick = JoystickComponent(
      anchor: Anchor.bottomLeft,
      position: Vector2(30, size.y - 30),
      // size: 100,
      background: CircleComponent(
        radius: 60,
        paint: Paint()..color = Colors.white.withOpacity(0.5),
      ),
      knob: CircleComponent(radius: 30),
    );
    add(joystick);

    _player = Player(
      joystick: joystick,
    );
    add(_player);
    addWorldCollision();

    _player.position = (_world.size / 2);

    camera.followComponent(
      _player,
      worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y),
    );
  }

  void addWorldCollision() async {
    add(
      WorldCollidable()
        ..position = Vector2(100, 100)
        ..width = 2080
        ..height = 2400,
    );

    // for (var rect in (await MapLoader.readRayWorldCollisionMap())) {
    //   print(rect.width);
    //   print(rect.height);
    //   print(rect.left);
    //   print(rect.top);
    //   print('ほげほえg');
    //
    //   add(WorldCollidable()
    //     ..position = Vector2(rect.left, rect.top)
    //     ..width = rect.width
    //     ..height = rect.height);
    // }
  }

  void onJoypadDirectionChanged(Direction direction) {
    _player.direction = direction;
  }

  WorldCollidable createWorldCollidable(Rect rect) {
    final collidable = WorldCollidable();
    collidable.position = Vector2(rect.left, rect.top);
    collidable.width = rect.width;
    collidable.height = rect.height;
    return collidable;
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;
    Direction? keyDirection;

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      keyDirection = Direction.left;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      keyDirection = Direction.right;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      keyDirection = Direction.up;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      keyDirection = Direction.down;
    }

    if (isKeyDown && keyDirection != null) {
      _player.direction = keyDirection;
    } else if (_player.direction == keyDirection) {
      _player.direction = Direction.none;
    }

    return super.onKeyEvent(event, keysPressed);
  }
}
