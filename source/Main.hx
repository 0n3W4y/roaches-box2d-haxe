package;

import flash.Lib;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.display.Sprite;
import flash.events.Event;

class Main extends Sprite
{

	private var isStarted:Bool = false;
	private var isStopped:Bool = false;
	private var isPaused:Bool = false;
	private var myGame:Game;

	public static function main()
	{
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		initialize();
	}

	private function initialize()
	{
		myGame = new Game(this);

		start();
	}

	public function start()
	{
		if (!isStarted)
		{
			isStarted = true;
			myGame.start(); 
		}

	}

	public function stop()
	{
		if(!isStopped)
		{
			isStopped = true;
			myGame.stop();
				
		}
	}

}