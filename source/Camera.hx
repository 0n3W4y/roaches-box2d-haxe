package;

import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.display.Stage;

class Camera extends Sprite{

	private var ZOOM_IN_AMT:Float = 3.3;
	private var _stageWidth:Int = 1280;
	private var _stageHeight:Int = 720;
	private var _myScene:Scene;
	
	public function new(scene:Scene)
	{
		super();
		_myScene = scene;
		//this.stageWidth = _stageWidth;
		//this.stageHeight = _stageHeight;
	}

	public function zoomTo(whatPoint:Point)
	{
		this.scaleX = ZOOM_IN_AMT;
		this.scaleY = ZOOM_IN_AMT;


		this.x = -whatPoint.x + ZOOM_IN_AMT;
		this.y = -whatPoint.y + ZOOM_IN_AMT;

	}

	public function zoomOut()
	{
		this.scaleX = 1.0;
		this.scaleY = 1.0;

		this.x = 0;
		this.y = 0;
	}

}