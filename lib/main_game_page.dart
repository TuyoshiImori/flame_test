import 'package:flame/game.dart';
import 'package:flame_test/overlays/joypad_screen.dart';
import 'package:flame_test/overlays/message_board.dart';
import 'package:flame_test/overlays/pause_button.dart';
import 'package:flame_test/overlays/pause_menu.dart';
import 'package:flutter/material.dart';

import 'ray_world_game.dart';

class MainGamePage extends StatefulWidget {
  const MainGamePage({Key? key}) : super(key: key);

  @override
  MainGameState createState() => MainGameState();
}

class MainGameState extends State<MainGamePage> {
  RayWorldGame game = RayWorldGame()..debugMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: Stack(
        children: [
          GameWidget(
            game: game,
            initialActiveOverlays: const [JoypadScreen.id, PauseButton.id],
            overlayBuilderMap: {
              JoypadScreen.id: (BuildContext context, RayWorldGame gameRef) =>
                  JoypadScreen(
                    gameRef: gameRef,
                    onDirectionChanged: game.onJoypadDirectionChanged,
                    onJoypadOnTap: game.onJoypadOnTap,
                    screenHeight: MediaQuery.of(context).size.height,
                    screenWidth: MediaQuery.of(context).size.width,
                  ),
              PauseButton.id: (BuildContext context, RayWorldGame gameRef) =>
                  PauseButton(
                    gameRef: gameRef,
                  ),
              PauseMenu.id: (BuildContext context, RayWorldGame gameRef) =>
                  PauseMenu(
                    gameRef: gameRef,
                  ),
              MessageBoard.id: (BuildContext context, RayWorldGame gameRef) =>
                  MessageBoard(
                    gameRef: gameRef,
                  ),
              // GameOverMenu.id: (BuildContext context, RayWorldGame gameRef) =>
              //     GameOverMenu(
              //       gameRef: gameRef,
              //     ),
            },
          ),
        ],
      ),
    );
  }
}
