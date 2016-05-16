package;

import flash.display.Sprite;
import flash.geom.Rectangle;

class UserInterface extends Sprite
{
	private var _myScene:Scene;

	public function new(scene)
	{
		super();
		_myScene = scene;
	}

	public function update()
	{
		
		this.x =  - _myScene.x + stage.stageWidth/4;
		this.y =  - _myScene.y + stage.stageHeight/4;

	}	
}