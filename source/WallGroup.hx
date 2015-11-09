package;
import flash.system.System; // Or nme.system.System if you're using NME

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

class WallGroup extends FlxGroup {
  public var bottomWall: FlxSprite;

  public function new() {
    super();

    var leftWall = new FlxSprite(0, 0);
    leftWall.makeGraphic(10, 240, FlxColor.GRAY);
    leftWall.immovable = true;
    this.add(leftWall);

    var rightWall = new FlxSprite(310, 0);
    rightWall.makeGraphic(10, 240, FlxColor.GRAY);
    rightWall.immovable = true;
    this.add(rightWall);

    var topWall = new FlxSprite(0, 0);
    topWall.makeGraphic(320, 10, FlxColor.GRAY);
    topWall.immovable = true;
    this.add(topWall);

    bottomWall = new FlxSprite(0, 239);
    bottomWall.makeGraphic(320, 10, FlxColor.TRANSPARENT);
    bottomWall.immovable = true;

    this.add(bottomWall);
  }
}
