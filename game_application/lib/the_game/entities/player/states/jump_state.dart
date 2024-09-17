import 'package:Cuphead_application/the_game/entities/player/cuphead.dart';
import 'package:Cuphead_application/the_game/entities/player/states/base_state.dart';
import 'package:Cuphead_application/the_game/entities/player/states/run_state.dart';
import 'package:Cuphead_application/the_game/extra/helper_functions.dart';
import 'package:flutter/services.dart';

class JumpState extends CupheadState {
  @override
  Future<void> enter(Cuphead cuphead) async {
    if (!hasEntered) {
      await loadAnimations(cuphead);
      hasEntered = true;
    }

    cuphead.add(animation);

    cuphead.velocityY = cuphead.jumpHeight;
    cuphead.isJumping = true;
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
        cuphead.images, cuphead.position, 'Jump', 3, 3, cuphead.getSize(),
        adjustedSize: cuphead.getSize() - 30, totalSprites: 8);
  }

  @override
  void handleInput(Cuphead cuphead, Set<LogicalKeyboardKey> pressedKeys) {
    if (hasEntered) {
      animation.position.x = cuphead.position.x;
    }
  }

  @override
  void update(Cuphead cuphead, double dt) {
    if (hasEntered) {
      cuphead.velocityY += cuphead.gravity * dt;
      animation.position.y += cuphead.velocityY * dt;

      if (animation.position.y >= cuphead.position.y) {
        animation.position.y = cuphead.position.y;
        cuphead.isJumping = false;
        cuphead.velocityY = 0;
        cuphead.changeState(RunState());
      }

      if (cuphead.isLookingLeft) {
        animation.scale.x = -1;
      } else {
        animation.scale.x = 1;
      }
    }
  }
}
