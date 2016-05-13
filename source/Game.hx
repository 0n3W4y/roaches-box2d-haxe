package;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;

class Game
{
	private var myMain:Sprite;

	private var _allMyScenes:Array<Dynamic> = new Array();
	private var _scenesToStart:Array<Dynamic> = new Array();
	private var _scenesToStop:Array<Dynamic> = new Array();

	public function new(main:Sprite):Void
	{
		myMain = main;
		initilize();
	}

	private function initilize():Void
	{
		createScene();
	}

	public function createScene():Void
	{
		var myNewScene = new Scene(this);
		myMain.addChild(myNewScene);
		_allMyScenes.push(myNewScene);
	}

	public function start():Void
	{
		
		for (i in 0... _allMyScenes.length)
		{
			_allMyScenes[i].start();
		}
	}

	public function stop():Void
	{
		for (i in 0... _allMyScenes.length)
		{
			_allMyScenes[i].stop();
		}
	}

	public function getMain():Sprite
	{
		return myMain;
	}
/*
	public function addSceneToStart(scene:Scene):Void
	{
		_scenesToStart.push(scene);
	}

	public function addSceneToStop(scene:Scene):Void
	{
		_scenesToStop.push(scene);
	}
*/
}
