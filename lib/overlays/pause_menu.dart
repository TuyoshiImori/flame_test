import 'package:flame_test/ray_world_game.dart';
import 'package:flutter/material.dart';

import 'pause_button.dart';

// This class represents the pause menu overlay.
class PauseMenu extends StatelessWidget {
  static const String id = 'PauseMenu';
  final RayWorldGame gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Pause menu title.
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              '一時停止中',
              style: TextStyle(
                fontSize: 50.0,
                color: Colors.black,
                shadows: [
                  Shadow(
                    blurRadius: 20.0,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  )
                ],
              ),
            ),
          ),

          // Resume button.
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.resumeEngine();
                gameRef.overlays.remove(PauseMenu.id);
                gameRef.overlays.add(PauseButton.id);
              },
              child: const Text('ゲームに戻る'),
            ),
          ),
          // Exit button.
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: ElevatedButton(
              onPressed: () {
                gameRef.overlays.remove(PauseMenu.id);
                gameRef.resumeEngine();

                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (context) => const MainMenu(),
                //   ),
                // );
              },
              child: const Text('タイトルに戻る'),
            ),
          ),
        ],
      ),
    );
  }
}
