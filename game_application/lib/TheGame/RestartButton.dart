import 'package:flutter/material.dart';

class GameRestartButton extends StatelessWidget {
  final VoidCallback onRestart;

  const GameRestartButton({required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onRestart,
        child: Text('Restart'),
      ),
    );
  }
}
