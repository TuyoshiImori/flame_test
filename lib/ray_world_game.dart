import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_test/components/enemy.dart';
import 'package:flame_test/helpers/map_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'components/player.dart';
import 'components/world.dart';
import 'components/world_collidable.dart';
import 'helpers/direction.dart';

class RayWorldGame extends FlameGame
    with HasDraggables, HasTappables, HasCollisionDetection, KeyboardEvents {
  final Player _player = Player();
  final World _world = World();
  final Enemy _enemy = Enemy();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await add(_world);
    await add(_enemy);
    await add(_player);

    // ワールドに衝突判定を追加
    addWorldCollision();
    _player.position = (_world.size / 2);

    camera.followComponent(
      _player,
      // プレイヤーの表示位置を画面のちょうど真ん中になるように比率を修正
      relativeOffset: Anchor(
        ((size.x - 50) / 2) / size.x,
        ((size.y - 50) / 2) / size.y,
      ),
      worldBounds: Rect.fromLTRB(0, 0, _world.size.x, _world.size.y),
    );

    print(_player.position.x - ((size.x - 50) / 2));
    final textBox = TextBoxComponent(
      text: 'Hellow world',
      position: Vector2(
        _player.position.x - ((size.x - 50) / 2),
        _player.position.y + ((size.y - 50) / 2) - 50,
      ),
      size: Vector2(size.x, 50),
    );
    add(textBox);
  }

  void addWorldCollision() async {
    for (var rect in (await MapLoader.readRayWorldCollisionMap())) {
      add(
        WorldCollidable()
          ..position = Vector2(rect.left, rect.top)
          ..width = rect.width
          ..height = rect.height,
      );
    }

    // enemyの不通過衝突判定
    add(
      WorldCollidable()
        ..position = Vector2(1175, 975)
        ..width = 50
        ..height = 50,
    );
  }

  // _playerとjoyStickの操作を繋げる
  void onJoypadDirectionChanged(Direction direction) {
    _player.direction = direction;
  }

  // joyStickのonTap
  void onJoypadOnTap() {
    _player.joystickAction();
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
