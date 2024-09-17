import 'package:Cuphead_application/the_game/entities/player/cuphead.dart';
import 'package:Cuphead_application/the_game/entities/player/states/base_state.dart';
import 'package:Cuphead_application/the_game/entities/player/states/jump_state.dart';
import 'package:Cuphead_application/the_game/entities/player/states/shoot_state.dart';
import 'package:Cuphead_application/the_game/extra/helper_functions.dart';
import 'package:flutter/services.dart';

class RunState extends CupheadState {
  @override
  Future<void> enter(Cuphead cuphead) async {
    if (!hasEntered) {
      await loadAnimations(cuphead);
      hasEntered = true;
    }

    cuphead.add(animation);
  }

  @override
  void exit(Cuphead cuphead) {
    if (hasEntered) {
      animation.removeFromParent();
    }
  }

  @override
  Future<void> loadAnimations(Cuphead cuphead) async {
    animation = await createAnimation(
        cuphead.images, cuphead.position, 'Run', 4, 4, cuphead.getSize());
  }

  @override
  void handleInput(Cuphead cuphead, Set<LogicalKeyboardKey> pressedKeys) {
    if (pressedKeys.contains(LogicalKeyboardKey.space)) {
      cuphead.changeState(JumpState());
    } else if (pressedKeys.contains(LogicalKeyboardKey.keyE)) {
      cuphead.changeState(ShootState());
    }
  }

  @override
  void update(Cuphead cuphead, double dt) {
    animation.position = cuphead.position;

    if (cuphead.isLookingLeft) {
      animation.scale.x = -1;
    } else {
      animation.scale.x = 1;
    }
  }
}
