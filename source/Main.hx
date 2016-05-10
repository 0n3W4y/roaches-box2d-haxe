package;

import flash.Lib;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;


class Main
{
	public static var myGame:Game;

	public function main()
	{
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		myGame = new Game(this);
		Lib.current.addChild(myGame);
	}
}