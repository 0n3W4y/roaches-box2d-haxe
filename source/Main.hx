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
	private var _allMyGames:Array<Dynamic>;
	private var myGame:Game;

	public static var globalSprite:Sprite;

	public static function main()
	{
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		globalSprite = new Main();
		Lib.current.addChild(globalSprite);

	}

	public function new()
	{
		super();

		initialize();

	}

	private function initialize()
	{
		myGame = new Game(globalSprite);
		_allMyGames.push(myGame);

		start();
	}

	public function start()
	{
		if (!isStarted)
		{
			isStarted = true;
			myGame.start(); //addEventListener(Event.ENTER_FRAME, _allMyGames[index].update);
		}

	}

	public function stop()
	{
		if(!isStopped)
		{
			isStopped = true;
			myGame.stop(); //removeEventListener(Event.ENTER_FRAME, _allMyGames[index].update);
				
		}
	}

}