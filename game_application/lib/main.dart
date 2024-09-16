import 'package:Cuphead_application/bloc/game_bloc.dart';
import 'package:Cuphead_application/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => GameBloc(),
      child: CupheadGameApp(),
    ),
  );
}

class CupheadGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var game = CupheadGame(context: context);
    return GameWidget(
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
    );
  }
}
