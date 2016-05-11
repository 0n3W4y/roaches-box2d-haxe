package;

import flash.Lib;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;


class Main
{

	
	private var isStarted:Bool = false;
	private var isStopped:Bool = false;
	private var isPaused:Bool = false;
	private var _allMyGames:Array<Dynamic>;

	public function main()
	{
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		myGame = new Game(this);
		Lib.current.addChild(myGame);
		_allMyGames.push(myGame);
	}

	public function start(game)
	{
		if (!isStarted)
		{
			isStarted = true;
			var index = _allMyGames.indexOf(game)
			if (index >= 0)
				_allMyGames[index].start();
		}

	}

	public function stop(game)
	{
		if(!isStopped)
		{
			isStopped = true;
			var index = _allMyGames.indexOf(game)
			if (index >= 0)
				_allMyGames[index].stop();
		}
	}
}