import 'package:flame_test/overlays/pause_button.dart';
import 'package:flame_test/ray_world_game.dart';
import 'package:flutter/material.dart';

// This class represents the pause button overlay.
class MessageBoard extends StatelessWidget {
  static const String id = 'MessageBoard';
  final RayWorldGame gameRef;

  const MessageBoard({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        gameRef.resumeEngine();
        gameRef.overlays.remove(MessageBoard.id);
        gameRef.overlays.add(PauseButton.id);
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(gameRef.text),
      ),
    );
  }
}
