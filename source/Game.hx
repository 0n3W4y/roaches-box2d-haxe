package;

import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;

import flash.display.Sprite;
import flash.Lib;

class Game
{
	public var myGameScene:Scene;
	public var fps:Int = 30;

	private var isStarted:Bool = false;
	private var isPaused:Bool = false;
	private var isStopped:Bool = false;


	public function new()
	{
		init();
	}

	private function init()
	{	
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		myGameScene = new Scene(this);
		Lib.current.addChild(myGameScene);
	}

	public function start()
	{
		if(!isStarted){
			isStarted = true;
			myGameScene.start(fps);
		}
	}

	public function stop()
	{
		if(!isStopped){
			isStopped = true;
		}
	}

	public function pause()
	{
		if(!isPaused)
			isPaused = true;
		else
			isPaused = false;
	}
}