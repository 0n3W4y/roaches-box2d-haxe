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
	private var _afterShootTimer:Timer;

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

		_afterShootTimer = new Timer(1000, 5);
	}

	private function addTimerTextField()
	{
		var result:TextField = new TextField();
        result.x = 0;
        result.y = -150;
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

		playerTurnControl();

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
		if (_currentTime == _turnTime && _currentTime >= 11)
		{
			_currentTime--;
			timerText = Std.string(_currentTime);
			_timerTextField.text = timerText;
			
		}
		else if (_currentTime >= 11)
		{
			_currentTime--;
			timerText = Std.string(_currentTime);
			_timerTextField.text = timerText;
			
		}
		else
		{
			_currentTime--;
			timerText = Std.string(_currentTime);
			var tt = "0" + timerText;
			_timerTextField.text = tt;
			
		}
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
		_timerTextField.text = "00";
		_timerIsStopped = true;
	}

	private function playerTurnControl()
	{
		var player = _myScene.getCurrentPlayer();
		if (_turnTimer.currentCount == _turnTime)
			turnEnd();

		//wait for bullet get target, then end turn for this player
	}

	public function takeTurnToNextPlayer()
	{
		var lastPlayerTurn = _myScene.getCurrentPlayer();
		_myScene.setCurrentPlayer(null);
		
		var listOfPlayers = _myScene.getListOfPlayers();
		var index = listOfPlayers.indexOf(lastPlayerTurn);
		var nextPlayer = null;
		if ( index > -1 )
		{
			if ( index+1 < listOfPlayers.length)
				nextPlayer = listOfPlayers[index+1];
			else 
				nextPlayer = listOfPlayers[0];
				//round ended
		}

		_myScene.setCurrentPlayer(nextPlayer);

		turnStart();
		
	}

	public function turnEnd()
	{
		//TODO: clear all turn moving, stop all collisions,
		_timerTextField.text = "";
		_timerIsStopped = true;

		var player = _myScene.getCurrentPlayer();
		player.endTurn();

		takeTurnToNextPlayer();
	}

	public function turnStart()
	{
		var player = _myScene.getCurrentPlayer();
		player.startTurn();
			
		startTimer();
	}

	public function getTurnTime()
	{
		return _turnTime;
	}

}