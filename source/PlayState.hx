package;

// Or nme.system.System if you're using NME
import flash.system.System;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
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
  private var _bricks:Bricks;

  private var _lifes:Int = 3;
  private var _level:Int = 0;
  private var laserSound:FlxSound;
  override public function create():Void {
    laserSound = FlxG.sound.load("assets/sounds/NFF-laser.wav");

    FlxG.mouse.visible = false;

    // Add bat
    _bat = new Bat(180, 220);
    add(_bat);

    walls = new WallGroup();
    add(walls);

    startNewLevel(_level);
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

  private function startNewLevel(level:Int = 0):Void {
    if(_bricks != null) {
      _bricks.destroy();
    }
    _bricks = new Bricks(5, 6 + level);
    add(_bricks);
  }

  override public function destroy():Void {
    super.destroy();
  }

  override public function update():Void {
    super.update();
    _bat.velocity.x = 0;

    #if !FLX_NO_TOUCH
    // Simple routine to move bat to x position of touch
    for (touch in FlxG.touches.list)
    {
      if (touch.pressed)
      {
	if (touch.x > 10 && touch.x < 270)
	  _bat.x = touch.x;
      }
    }
    // Vertical long swipe up or down resets game state
    for (swipe in FlxG.swipes)
    {
      if (swipe.distance > 100)
      {
	if ((swipe.angle < 10 && swipe.angle > -10) || (swipe.angle > 170 || swipe.angle < -170))
	{
	  FlxG.resetState();
	}
      }
    }
    #end

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
    } else if (_bricks.allDestroyed()) {
      _level++;
      startNewLevel(_level);
    }
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
    laserSound.play();
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
