import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flame_bloc/flame_bloc.dart';

//Game Events
abstract class GameEvent {}

class GameWin extends GameEvent {}

class GameOver extends GameEvent {}

class GameRestart extends GameEvent {}

//Game States
abstract class GameState {}

class GameInitial extends GameState {}

class GameRunning extends GameState {}

class GamePaused extends GameState {}

class GameWon extends GameState {}

class GameLost extends GameState {}

//Game Bloc
class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameInitial());

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    if (event is GameWin) {
      yield GameWon();
    } else if (event is GameOver) {
      yield GameLost();
    } else if (event is GameRestart) {
      yield GameRunning();
    }
  }
}
