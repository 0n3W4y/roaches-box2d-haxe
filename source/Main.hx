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
	private var _allMyGames:Array<Dynamic> = new Array();

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
		var myGame = new Game(this);
		_allMyGames.push(myGame);

		//start(myGame);
	}

	public function start(game)
	{
		if (!isStarted)
		{
			isStarted = true;
			var index = _allMyGames.indexOf(game);
			if (index >= 0)
				addEventListener(Event.ENTER_FRAME, _allMyGames[index].update);
		}

	}

	public function stop(game)
	{
		if(!isStopped)
		{
			isStopped = true;
			var index = _allMyGames.indexOf(game);
			if (index >= 0)
				removeEventListener(Event.ENTER_FRAME, _allMyGames[index].update);
		}
	}

	public function addSpriteChild(child)
	{
		addChild(child);
	}
}