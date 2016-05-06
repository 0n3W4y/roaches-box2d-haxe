package;

import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;

import flash.events.Sprite;
import flash.Lib;

class Game
{
	public var myGameScene:Scene;

	private var isStarted:Bool = false;
	private var isPaused:Bool = false;
	private var isStopped:Bool = false;

	public function new():Void
	{
		init();
	}

	private function init():Void
	{	
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		myGameScene = new Scene(this);
		Lib.current.addChild(myGameScene);
	}

	public function start():Void
	{
		if(!isStarted){
			isStarted = true;
			scene.start();
		}
	}

	public function stop():Void
	{
		if(!isStopped){
			isStopped = true;
		}
	}

	public function pause():Void
	{
		if(!isPaused)
			isPaused = true;
		else
			isPaused = false;
	}
}