package;

import flash.display.Sprite;
import flash.events.Event;

class Game extends Sprite
{
	public var myMain:Main;

	private var fps:Int = 30;
	private var _allMyScenes:Array<Dynamic>;
	private var isStarted:Bool = false;
	private var isStopped:Bool = false;

	public function new(main:Main)
	{
		super();

		initilize(main);
	}

	private function initilize(main:Main)
	{
		myMain = main;
	}

	public function createScene(game:Game, fps:Int)
	{
		var myNewScene = new Scene(game, fps);
		_allMyScenes.push(mynewScene);
	}

	public function update(e:Event)
	{
		for (i in 0..._allMyScenes.length)
		{
			_allMyScenes[i].update();
		}
	}

	public function start()
	{
		if (!isStarted)
		{
			addEventListener(Event.ENTER_FRAME, update);
			isStarted = true;
		}
		
	}

	public function stop()
	{
		if (!isStopped)
		{
			removeEventListener(Event.ENTER_FRAME, update);
			isStopped = true;
		}
	}

	public function removeSceneFromUpdate(scene)
	{
		//TODO: safe remove scen from list of all scenes
		// убирает сцену из списка тикающих сцен
	}
}