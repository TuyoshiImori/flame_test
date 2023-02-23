import 'package:flame_test/helpers/direction.dart';
import 'package:flame_test/ray_world_game.dart';
import 'package:flutter/material.dart';

// This class represents the pause button overlay.
class JoypadScreen extends StatelessWidget {
  static const String id = 'JoypadScreen';
  final RayWorldGame gameRef;

  final ValueChanged<Direction> onDirectionChanged;
  final Function() onJoypadOnTap;
  Direction direction = Direction.none;
  Offset onPosition = Offset.zero;
  final double screenHeight;

  final double screenWidth;

  JoypadScreen({
    Key? key,
    required this.onDirectionChanged,
    required this.onJoypadOnTap,
    required this.gameRef,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onJoypadOnTap();
      },
      onPanDown: onDragDown,
      onPanUpdate: onDragUpdate,
      onPanEnd: onDragEnd,
      onPanCancel: onDragCancel,
      child: Container(
        height: screenHeight,
        width: screenWidth,
        decoration: const BoxDecoration(
          color: Color(0x88ffffff),
        ),
      ),
    );
    // return Align(
    //   alignment: Alignment.bottomCenter,
    //   child: TextButton(
    //     child: const Icon(
    //       Icons.pause_rounded,
    //       color: Colors.white,
    //     ),
    //     onPressed: () {
    //       gameRef.pauseEngine();
    //       gameRef.overlays.add(PauseMenu.id);
    //       gameRef.overlays.remove(PauseButton.id);
    //     },
    //   ),
    // );
  }

  void updateDelta(Offset newDelta) {
    final newDirection = getDirectionFromOffset(newDelta);
    if (newDirection != direction) {
      direction = newDirection;
      onDirectionChanged(direction);
    }
    // setState(() {
    //   delta = newDelta;
    // });
  }

  Direction getDirectionFromOffset(Offset offset) {
    if (offset.dy > 0 && offset.dx.abs() < offset.dy) {
      return Direction.up;
    } else if (offset.dy < 0 && offset.dx.abs() < offset.dy.abs()) {
      return Direction.down;
    } else if (offset.dx > 0 && offset.dx > offset.dy.abs()) {
      return Direction.left;
    } else if (offset.dx < 0 && offset.dx.abs() > offset.dy.abs()) {
      return Direction.right;
    }
    return Direction.none;
  }

  void onDragDown(DragDownDetails d) {
    onPosition = d.localPosition;
  }

  void onDragUpdate(DragUpdateDetails d) {
    updateDelta(onPosition - d.localPosition);
  }

  void onDragEnd(DragEndDetails d) {
    onPosition = Offset.zero;
    updateDelta(Offset.zero);
  }

  void onDragCancel() {
    onPosition = Offset.zero;

    updateDelta(Offset.zero);
  }
}
