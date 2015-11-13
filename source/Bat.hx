package;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class Bat extends FlxSprite {
  public function new(x:Int, y:Int) {
    super(x, y);
    makeGraphic(40, 6, FlxColor.HOT_PINK);
    immovable = true;
  }
}
