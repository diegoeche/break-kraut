package;
import flash.system.System; // Or nme.system.System if you're using NME

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.tweens.FlxTween;

import flixel.group.FlxGroup;
import flixel.FlxState;

import flixel.text.FlxText;
import flixel.ui.FlxButton;

import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxColor;

class PlayState extends FlxState {
  private var ball: Ball;

  private static inline var BAT_SPEED:Int = 350;
  private var _score:Int = 0;
  private var _bat:FlxSprite;
  private var _scoreText:FlxText;
  private var _topMenu:FlxText;

  private var walls:WallGroup;
  private var _bricks:FlxGroup;

  private var _lifes:Int = 3;

  override public function create():Void {
    FlxG.mouse.visible = false;

    // Add bat
    _bat = new FlxSprite(180, 220);
    _bat.makeGraphic(40, 6, FlxColor.HOT_PINK);
    _bat.immovable = true;
    add(_bat);

    bricks(5, 6);
    add(_bricks);

    walls = new WallGroup();
    add(walls);

    _topMenu = new FlxText(0, -2, 100, "Brek-Kraut! " + _lifes);
    _scoreText = new FlxText(270, -2, 100, "score: " + _score);

    add(_scoreText);
    add(_topMenu);

    startGame();
    super.create();
  }

  private function startGame() {
    if(ball != null) {
      ball.kill();
    }
    ball = new Ball();
    ball.addToScene(this);
    ball.startPosition();
  }

  private function bricks(columns: Int, rows: Int) {
    if(rows > 10) {
      throw "Rows cannot be greater than 10";
    }

    if(_bricks != null) {
      _bricks.kill();
    }

    _bricks = new FlxGroup();

    var brickColours:Array<Int> = [0xffd03ad1, 0xfff75352, 0xfffd8014, 0xffff9024, 0xff05b320, 0xff6d65f6];

    var bx:Int = 10;
    var by:Int = 30;

    var size_x:Int = cast(300 / columns);
    var size_y:Int = 15;

    for (y in 0...rows) {
      for (x in 0...columns) {
	var tempBrick:FlxSprite = new FlxSprite(bx, by);
	tempBrick.makeGraphic(size_x, size_y, brickColours[y%brickColours.length]);
	tempBrick.immovable = true;
	_bricks.add(tempBrick);
	bx += size_x;
      }

      bx = 10;
      by += size_y;
    }
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update():Void {
    super.update();
    _bat.velocity.x = 0;

    if (FlxG.keys.anyPressed(["LEFT", "A"]) && _bat.x > 10) {
      onLeft();
    } else if (FlxG.keys.anyPressed(["RIGHT", "D"]) && _bat.x < 270) {
      onRight();
    } else if (FlxG.keys.anyPressed(["Q"])) {
      System.exit(0);
    }
    if (_bat.x < 10) {
      _bat.x = 10;
    }

    if (_bat.x > 270) {
      _bat.x = 270;
    }

    updateTopMenu();
    updateScoreText();

    FlxG.collide(ball.sprite, walls.bottomWall, loseLife);
    FlxG.collide(ball.sprite, walls, hitWall);
    FlxG.collide(_bat, ball.sprite, ping);
    FlxG.collide(ball.sprite, _bricks, hitBrick);

    if (_lifes == 0) {
      gotoLostState();
    } else if (hasWon()) {
      bricks(5, 6);
      add(_bricks);
    }
  }

  private function hasWon() : Bool {
    var accum = true;
    var allBricks = _bricks.members;
    for(brick in _bricks.members) {
      accum = accum && !brick.exists;
    }
    return accum;
  }

  private function gotoLostState() {
    FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
      FlxG.switchState(new LostState(_score));
    });
  }

  private function updateTopMenu() {
    _topMenu.text = "Break-Kraut! " + _lifes;
  }

  private function updateScoreText() {
    _scoreText.text = "score: " + _score;
  }

  private function onLeft() {
    _bat.velocity.x = -BAT_SPEED;
  }

  private function onRight() {
    _bat.velocity.x = BAT_SPEED;
  }

  private function hitBrick(Ball:FlxSprite, Brick:FlxObject):Void {
    Brick.exists = false;
    ball.squeeze();
    _score += 1;
    FlxG.sound.play("assets/sounds/NFF-laser.wav", 0.2, false);
  }

  private function hitWall(Ball:FlxSprite, Brick:FlxObject):Void {
    ball.squeeze();
  }


  private function loseLife(Ball:FlxObject, Wall:FlxObject):Void {
    _lifes -= 1;
    startGame();
  }

  private function ping(Bat:FlxObject, Ball:FlxObject):Void {
    ball.squeeze();
    var batmid:Int = Std.int(Bat.x) + 20;
    var ballmid:Int = Std.int(Ball.x) + 3;
    var diff:Int= batmid - ballmid;

    if (ballmid < batmid) {
      // Ball is on the left of the bat
      Ball.velocity.x = ( -10 * diff);
    }
    else if (ballmid > batmid) {
      // Ball on the right of the bat
      diff = ballmid - batmid;
      Ball.velocity.x = (10 * diff);
    }
    else {
      // Ball is perfectly in the middle
      // A little random X to stop it bouncing up!
      Ball.velocity.x = 2 + FlxRandom.intRanged(0, 8);
    }
  }
}
