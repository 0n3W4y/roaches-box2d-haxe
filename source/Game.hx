package;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;

class Game
{
	private var parent:Sprite;

	private var _allMyScenes:Array<Dynamic> = new Array();

	public function new(main:Sprite)
	{
		parent = main;
		initilize();
	}

	private function initilize()
	{
		createScene();
	}

	public function createScene()
	{
		var myNewScene = new Scene(this);
		_allMyScenes.push(myNewScene);
	}

	public function update(e:Event)
	{
		for (i in 0..._allMyScenes.length)
		{
			_allMyScenes[i].update();
		}
	}

	public function removeSceneFromUpdate(scene)
	{
		//TODO: safe remove scene from list of all scenes
		// убирает сцену из списка тикающих сцен
	}

	public function start()
	{

	}

	public function stop()
	{

	}

	public function getParent():Sprite
	{
		return parent;
	}

}
