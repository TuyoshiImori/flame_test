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
  Direction direction = Direction.none;
  Direction _collisionDirection = Direction.none;
  int spriteSheetRow = 0;
  bool _hasCollided = false;
  bool _hasEnemy = false;

  Player()
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
  }

  @override
  void onMount() {
    super.onMount();
    // オブジェクトのサイズと同じ衝突判定
    final shape = RectangleHitbox(
      size: size,
      anchor: Anchor.center,
      // srcSizeのxの半分を引くことで画面の真ん中に配置
      position: size / 2,
    );
    add(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    movePlayer(dt);
  }

  void joystickAction() {
    if (_hasEnemy) {
      print('ボタン');
      final textBox = TextBoxComponent(
        text: 'Hellow world',
        position: Vector2(
          position.x - ((gameRef.size.x - 50) / 2),
          position.y + ((gameRef.size.y - 50) / 2) - 50,
        ),
        size: Vector2(gameRef.size.x, 50),
      );
      gameRef.add(textBox);
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is WorldCollidable) {
      if (!_hasCollided) {
        _hasCollided = true;
        _collisionDirection = direction;
      }
    }
    if (other is Enemy) {
      if (!_hasEnemy) {
        _hasEnemy = true;
      }
    }
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);
    _hasCollided = false;
    _hasEnemy = false;
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
