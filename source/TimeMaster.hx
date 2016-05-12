package;

class TimeMaster {
	
	private var _frameRate:Float;
	private var _normalStep:Float;
	private var _myScene:Scene;

	public function new(scene:Scene, worldStep:Float)
	{
		_frameRate = worldStep;
		_normalStep = worldStep;
		_myScene = scene;
	}

	public function getTimeStep()
	{
		return(_frameRate);
	}

	public function slowMotion()
	{
		_frameRate = _normalStep * 5;
	}

	public function backToNormal()
	{
		_frameRate = _normalStep;
	}
}