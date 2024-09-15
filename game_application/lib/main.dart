import 'package:Cuphead_application/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  var game = CupheadGame();
  runApp(
    GameWidget(
      game: game,
      overlayBuilderMap: {
        'RestartButton': (BuildContext context, CupheadGame game) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                game.restartGame();
              },
              child: Text('Restart'),
            ),
          );
        },
        'WinButton': (BuildContext context, CupheadGame game) {
          return Center(
            child: ElevatedButton(
              onPressed: () {
                game.restartGame();
              },
              child: Text('You Win! Restart?'),
            ),
          );
        },
      },
      initialActiveOverlays: const [],
    ),
  );
}
