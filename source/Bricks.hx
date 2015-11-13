package;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;

class Bricks extends FlxGroup {
  public function new(rows: Int, columns: Int) {
    super();

    if(rows > 10) {
      throw "Rows cannot be greater than 10";
    }

    var brickColours:Array<Int> = [
      0xffd03ad1,
      0xfff75352,
      0xfffd8014,
      0xffff9024,
      0xff05b320,
      0xff6d65f6
    ];

    var bx:Int = 10;
    var by:Int = 30;

    var size_x:Int = cast(300 / columns);
    var size_y:Int = 15;

    for (y in 0...rows) {
      for (x in 0...columns) {
	var tempBrick:FlxSprite = new FlxSprite(bx, by);
	tempBrick.makeGraphic(size_x, size_y, brickColours[y%brickColours.length]);
	tempBrick.immovable = true;
	add(tempBrick);
	bx += size_x;
      }

      bx = 10;
      by += size_y;
    }
  }

  public function allDestroyed(): Bool {
    var accum = true;
    for(brick in members) {
      accum = accum && !brick.exists;
    }
    return accum;
  }
}
