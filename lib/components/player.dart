import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flame_test/components/enemy.dart';
import 'package:flame_test/components/world_collidable.dart';
import 'package:flame_test/helpers/knows_game_size.dart';
import 'package:flame_test/ray_world_game.dart';

import '../helpers/direction.dart';

class Player extends SpriteAnimationComponent
    with
        //HasGameRef,
        KnowsGameSize,
        CollisionCallbacks,
        HasGameRef<RayWorldGame>,
        KeyboardHandler {
  final double _playerSpeed = 300.0;
  final double _animationSpeed = 0.15;

  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;
  late final SpriteAnimation _standingAnimation;

  late final SpriteSheet spriteSheet;

  // Player joystick
  JoystickComponent joystick;
  Direction direction = Direction.none;
  Direction _collisionDirection = Direction.none;
  int spriteSheetRow = 0;
  bool _hasCollided = false;

  Player({required this.joystick})
      : super(
          size: Vector2.all(50.0),
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    spriteSheet = SpriteSheet(
      image: await gameRef.images.load('player_spritesheet.png'),
      srcSize: Vector2(29.0, 32.0),
    );
    _loadAnimations().then((_) => {animation = _standingAnimation});
    // add(
    //   RectangleHitbox(
    //     size: Vector2(
    //       width.floorToDouble(),
    //       height.floorToDouble(),
    //     ),
    //     position: Vector2(0, 0),
    //   ),
    // );
  }

  @override
  void onMount() {
    super.onMount();

    // Adding a circular hitbox with radius as 0.8 times
    // the smallest dimension of this components size.
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);

    //_playerData = Provider.of<PlayerData>(gameRef.buildContext!, listen: false);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      var knobAngle = joystick.delta.screenAngle();
      knobAngle = knobAngle < 0 ? 2 * pi + knobAngle : knobAngle;
      const eightOfPi = pi / 8;
      if (knobAngle > 0 && knobAngle <= eightOfPi * 2) {
        direction = Direction.up;
      } else if (knobAngle > eightOfPi * 2 && knobAngle <= eightOfPi * 6) {
        direction = Direction.right;
      } else if (knobAngle > eightOfPi * 6 && knobAngle <= eightOfPi * 10) {
        direction = Direction.down;
      } else if (knobAngle > eightOfPi * 10 && knobAngle <= eightOfPi * 14) {
        direction = Direction.left;
      } else if (knobAngle > eightOfPi * 14) {
        direction = Direction.up;
      }
    } else {
      direction = Direction.none;
    }
    movePlayer(dt);
  }

  void joystickAction() {
    print('ボタン');
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is WorldCollidable || other is Enemy) {
      if (!_hasCollided) {
        _hasCollided = true;
        _collisionDirection = direction;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    _hasCollided = false;
  }

  Future<void> _loadAnimations() async {
    _runDownAnimation = spriteSheet.createAnimation(
      row: 0,
      stepTime: _animationSpeed,
      to: 4,
    );

    _runLeftAnimation = spriteSheet.createAnimation(
      row: 1,
      stepTime: _animationSpeed,
      to: 4,
    );

    _runUpAnimation = spriteSheet.createAnimation(
      row: 2,
      stepTime: _animationSpeed,
      to: 4,
    );

    _runRightAnimation = spriteSheet.createAnimation(
      row: 3,
      stepTime: _animationSpeed,
      to: 4,
    );

    _standingAnimation = spriteSheet.createAnimation(
      row: spriteSheetRow,
      stepTime: _animationSpeed,
      to: 1,
    );
  }

  void movePlayer(double delta) async {
    switch (direction) {
      case Direction.up:
        spriteSheetRow = 2;
        if (canPlayerMoveUp()) {
          animation = _runUpAnimation;
          moveUp(delta);
        }
        break;
      case Direction.down:
        spriteSheetRow = 0;
        if (canPlayerMoveDown()) {
          animation = _runDownAnimation;
          moveDown(delta);
        }
        break;
      case Direction.left:
        spriteSheetRow = 1;
        if (canPlayerMoveLeft()) {
          animation = _runLeftAnimation;
          moveLeft(delta);
        }
        break;
      case Direction.right:
        spriteSheetRow = 3;
        if (canPlayerMoveRight()) {
          animation = _runRightAnimation;
          moveRight(delta);
        }
        break;
      case Direction.none:
        //animation = _standingAnimation;
        animation = spriteSheet.createAnimation(
            row: spriteSheetRow, stepTime: _animationSpeed, to: 1);
        break;
    }
  }

  bool canPlayerMoveUp() {
    if (_hasCollided && _collisionDirection == Direction.up) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveDown() {
    if (_hasCollided && _collisionDirection == Direction.down) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveLeft() {
    if (_hasCollided && _collisionDirection == Direction.left) {
      return false;
    }
    return true;
  }

  bool canPlayerMoveRight() {
    if (_hasCollided && _collisionDirection == Direction.right) {
      return false;
    }
    return true;
  }

  /// 条件式は壁に衝突判定が出てる状態で別の壁をすり抜けてしまうバグの対処
  void moveUp(double delta) {
    if (position.y + (delta * -_playerSpeed) > 60) {
      position.add(Vector2(0, delta * -_playerSpeed));
    }
  }

  void moveDown(double delta) {
    if (position.y + (delta * _playerSpeed) < 2100) {
      position.add(Vector2(0, delta * _playerSpeed));
    }
  }

  void moveLeft(double delta) {
    if (position.x + (delta * -_playerSpeed) > 150) {
      position.add(Vector2(delta * -_playerSpeed, 0));
    }
  }

  void moveRight(double delta) {
    if (position.x + (delta * _playerSpeed) < 2200) {
      position.add(Vector2(delta * _playerSpeed, 0));
    }
  }
}
