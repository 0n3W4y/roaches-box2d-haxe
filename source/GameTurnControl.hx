package;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.events.TimerEvent;
import flash.utils.Timer;


class GameTurnControl 
{
	private var _myScene:Scene;
	private var _turnTimer:Timer;
	private var _turnTime:Int;
	private var _timerTextField:TextField;
	private var _lastTimerCount:Int = 0;
	private var _currentTime:Int;
	private var _timerIsStopped:Bool = true;
	private var _timeToType:Bool = true;
	private var _timerStarted:Bool = false;

	public function new(scene:Scene, turnTime:Int)
	{
		_myScene = scene;
		_turnTime = turnTime;
		_currentTime = turnTime;
		initialize();

	}

	private function initialize()
	{
		_turnTimer = new Timer(1000, _turnTime);
		_timerTextField = addTimerTextField();
		_timerTextField.alwaysShowSelection = true;
	}

	private function addTimerTextField()
	{
		var result:TextField = new TextField();
        result.x = 0;
        result.y = -100;
        result.width = 25; result.height = 25;
        _myScene.getUI().addChild(result);
        return result;
	}

	public function update()
	{

		isTimeToType();

		if(_timeToType)
		{
			typeNextNum();
		}

		if (_turnTimer.currentCount == _turnTime)
			endTurn();

	}

	public function getTimerCount()
	{
		return _turnTimer.currentCount;
	}

	private function isTimeToType()
	{
		var currentCount = getTimerCount();

		if (currentCount > _lastTimerCount && currentCount <= _turnTime)
		{
			_lastTimerCount = currentCount;
			_timeToType = true;
		}
		else 
		{
			_timeToType = false;
		}
	}

	private function typeNextNum()
	{
		var timerText:String;
		if (_currentTime == _turnTime)
		{
			timerText = Std.string(_currentTime);
			_timerTextField.text = timerText;
			_currentTime--;
		}
		else if (_currentTime >= 10)
		{
			timerText = Std.string(_currentTime);
			_timerTextField.text = timerText;
			_currentTime--;
		}
		else
		{
			timerText = Std.string(_currentTime);
			StringTools.startsWith(timerText, "0");
			_timerTextField.text = timerText;
			_currentTime--;
		}
	}

	public function endTurn()
	{
		_timerTextField.text = "0";
		_timerIsStopped = true;
		_myScene.endTurn();
	}

	public function startTimer()
	{
		if (_timerIsStopped)
			if (_timerStarted)
			{
				_turnTimer.reset();
				_turnTimer.start();
			}
			else
			{
				_turnTimer.start();
				_timerStarted = true;
			}

			_currentTime = _turnTime;
			_lastTimerCount = 0;
			_timerIsStopped = false;
	}

	public function forciblyStopTimer()
	{
		_turnTimer.stop();
		_timerTextField.text = "0";
		_timerIsStopped = true;
	}
}