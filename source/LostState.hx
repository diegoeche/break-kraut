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
import haxe.Http;
import haxe.Json;

class LostState extends FlxState {
  // Local:
  // private static inline var BACKEND = "http://localhost:4000/";
  // Production:
  private static inline var BACKEND = "http://fast-everglades-7042.herokuapp.com/";

  var score: Int;
  var rankingNameList: FlxText;
  var rankingPointsList: FlxText;
  var ranking: Array<Dynamic>;

  public function new(score: Int) {
    this.score = score;
    super();
  }

  override public function create():Void {
    FlxG.mouse.visible = true;
    add(new FlxText(0, 5,  100, "R to Restart"));
    add(new FlxText(0, 15, 100, "Q to Quit"));

    rankingNameList = new FlxText(110, 40, 300, "Loading...");
    rankingPointsList = new FlxText(190, 40, 300, "");

    add(rankingNameList);
    add(rankingPointsList);

    add(new FlxText(30, 120, 300, "YOU LOST!", 40));
    add(new FlxText(140, 170, 300, "SCORE: " + score));

    ranking = null;
    doRankingCall();
    doScoreCall();
  }

  override public function destroy():Void {
    super.destroy();
  }

  private function restartGame() {
    FlxG.camera.fade(FlxColor.BLACK,.33, false, function() {
      FlxG.switchState(new PlayState());
    });
  }

  private function doRankingCall() {
    var rankingCall: Http = new haxe.Http(BACKEND + "api/ranking");
    rankingCall.onError = function (error: String) {
      trace("Error getting the ranking data");
    }
    rankingCall.onData = function (data: String) {
      ranking = Json.parse(data);
    }
    rankingCall.request();
  }

  private function doScoreCall() {
    if(score != null) {
      var scoreCall: Http = new haxe.Http(BACKEND + "api/user/1");
      scoreCall.setHeader("Content-Type", "application/json; charset=utf-8");
      var data = {
        new_score: score + ""
      };
      scoreCall.setPostData(Json.stringify(data));
      trace(Json.stringify(data));

      scoreCall.onError = function (error: String) {
        trace("Error doing the score call: " + error);
      }
      scoreCall.onData = function (data: String) {
        trace("Worked");
      }
      scoreCall.request(true);
    }
  }

  override public function update():Void {
    super.update();

    if (FlxG.keys.anyPressed(["Q"])) {
      System.exit(0);
    } else if (FlxG.keys.anyPressed(["R"])) {
      restartGame();
    }

    #if !FLX_NO_TOUCH
    for (touch in FlxG.touches.list) {
      if (touch.pressed) {
        restartGame();
      }
    }
    #end

    if(ranking != null) {
      var names = "";
      var points = "";
      for(rank in ranking) {
        names += "\n" + rank.name;
        points += "\n" + rank.points;
      }
      this.rankingNameList.text = names;
      this.rankingPointsList.text = points;

      ranking = null;
    }
  }
}
