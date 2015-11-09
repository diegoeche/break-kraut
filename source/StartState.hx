package;
import flash.system.System; // Or nme.system.System if you're using NME

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxColor;

import flixel.text.FlxText;

class StartState extends FlxState {
  var score: Int;

  public function new(score: Int) {
    this.score = score;
    super();
  }

  override public function create():Void {
    FlxG.mouse.visible = true;
    add(new FlxText(0, 5,  100, "Start a New Game"));
    add(new FlxText(30, 90, 320, "Break-Kraut!", 32));
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update():Void {
    super.update();

    if (FlxG.keys.anyPressed(["Q"])) {
      System.exit(0);
    } else if (FlxG.keys.anyPressed(["S"])) {
      FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
        FlxG.switchState(new PlayState());
      });
    }
  }
}
