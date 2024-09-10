import 'package:Cuphead_application/game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  var game = CupheadGame();
  runApp(GameWidget(game: game));
}
