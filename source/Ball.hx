package;
import flash.system.System; // Or nme.system.System if you're using NME

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.util.FlxColor;

class Ball {
  public var sprite: FlxSprite;
  private var trail: FlxTrail;

  public function new() {
    sprite = new FlxSprite(180, 160);
    sprite.makeGraphic(6, 6, FlxColor.HOT_PINK);
    sprite.elasticity = 1;
    sprite.maxVelocity.set(200, 200);
    trail = new FlxTrail(sprite, null, 20, 3, 0.2, 0.001);
  }

  public function startPosition() {
    sprite.velocity.y = 200;
    sprite.velocity.x = 0;
    sprite.x = 180;
    sprite.y = 160;
    sprite.visible = true;
  }

  public function kill() {
    sprite.kill();
    trail.kill();
  }

  public function addToScene(state: FlxState) {
    state.add(sprite);
    state.add(trail);
  }

  public function squeeze(): Void {
    FlxTween.tween(
      sprite.scale,
      { x: 0.5, y: 0.5 },
      0.08,
      {
        type: FlxTween.ONESHOT,
        complete: resetScale
      }
    );
  }

  private function resetScale(tween:FlxTween):Void {
    FlxTween.tween(
      sprite.scale,
      { x: 1, y: 1 },
      0.08,
      { type: FlxTween.ONESHOT }
    );
  }
}
