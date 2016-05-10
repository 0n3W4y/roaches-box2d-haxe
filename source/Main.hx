package;

import flash.Lib;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;


class Main
{
	public var myScene:Scene;

	private var fps:Int = 30;

	public function main()
	{
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		myGameScene = new Scene(this);
		Lib.current.addChild(myGameScene);
	}

	public function start()
	{
		if(!isStarted){
			isStarted = true;
			myGameScene.start(fps);
		}
	}

	public function stop()
	{
		if(!isStopped){
			isStopped = true;
		}
	}

	public function pause()
	{
		if(!isPaused)
			isPaused = true;
		else
			isPaused = false;
	}
}