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

	public function createScene(fps:Int)
	{
		var myNewScene = new Scene(this, fps);
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
		addEventListener(Event.ENTER_FRAME, update);
	}

	public function stop()
	{
		removeEventListener(Event.ENTER_FRAME, update);
	}

	public function removeSceneFromUpdate(scene)
	{
		//TODO: safe remove scene from list of all scenes
		// убирает сцену из списка тикающих сцен
	}
}