package;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2DebugDraw;

class Scene extends Sprite
{
	public var myGame:Game;
	public var world:B2World;
	public var worldScale:Int = 30; // pixel to metr;

	private var worldGravity:B2Vec2;
	private var worldStep:Float = 1/30;
	private var velocityIterations:Int = 10;
	private var positionIterations:Int = 10;
	private var sceneContactListener:ContactListener;
	private var _timeMaster:TimeMaster;
	private var player:ScenePlayerActor;
	private var _playersToRemove:Array<Dynamic> = new Array();
	private var playerIsAlive:Bool = false;
	private var myGameTurnControl:GameTurnControl;
	private var _userInterface:UserInterface;

	public var maxSceneWidth:Int = 2048;
	public var maxSceneHeight:Int = 1280;

	private var _allActors:Array<Dynamic> = new Array();

	public function new(game)
	{
		super();
		initilize();
		myGame = game;


	}

	private function initilize()
	{
		createTimeMaster();
		createWorld();
		createContactListener();
		createUserInterface();

		addDebuger();

		createLevel();
		createActors();
		createGameTurnControl();
	}

	private function createGameTurnControl()
	{
		myGameTurnControl = new GameTurnControl(this, 30);
	}

	private function createUserInterface()
	{
		_userInterface = new UserInterface(this);
		addChild(_userInterface);
	}

	private function createTimeMaster()
	{
		_timeMaster = new TimeMaster(this, worldStep);
	}

	private function createWorld()
	{
		worldGravity = new B2Vec2(0, 9.8); //x=0, y=G == 9.8;
		var isSleep:Bool = true;
		world = new B2World(worldGravity, isSleep);
	}

	private function createContactListener()
	{
		sceneContactListener = new ContactListener(this);
		world.setContactListener(sceneContactListener);
	}

	private function update(event:Event)
	{
		var step = _timeMaster.getTimeStep();
		world.step(step, velocityIterations, positionIterations);
		world.clearForces();
		world.drawDebugData();

		sceneFollowPlayer();

		for(i in 0..._allActors.length)
		{
			_allActors[i].update();
		}

		removePlayersFromScene();
		myGameTurnControl.update();
		_userInterface.update();
	}

	private function addDebuger()
	{
		var debugDraw = new B2DebugDraw();
		var debugSprite = new Sprite();
		addChild(debugSprite);
		
		debugDraw.setSprite(debugSprite);
		debugDraw.setDrawScale(worldScale);
		debugDraw.setFlags(B2DebugDraw.e_shapeBit);
		
		world.setDebugDraw(debugDraw);
	}

	private function createActors()
	{
		
		var playerPos = new B2Vec2(100, 650);
		createPlayerActor(playerPos, 5, 8);

		var enemyPos = new B2Vec2(300, 650);
		createEnemyActor(enemyPos, 5, 8);
	}

	private function createGround(width:Int, height:Int, pos:B2Vec2, figures:Int)
	{
		var width = width/2;
		var height = height/2;
		var loc = new B2Vec2(pos.x/2/worldScale, pos.y/worldScale);

		var newGroundActor = new SceneGroundActor(this, width, height, loc, figures, true);

		_allActors.push(newGroundActor);
	}

	private function createPlayerActor(pos:B2Vec2, velocityX:Int, velocityY:Int)
	{
		var loc = new B2Vec2(pos.x/worldScale, pos.y/worldScale);
		player = new ScenePlayerActor(this, loc, velocityX, velocityY);
		playerIsAlive = true;
		_allActors.push(player);
	}

	private function createEnemyActor(pos:B2Vec2, velocityX:Int, velocityY:Int)
	{
		var loc = new B2Vec2(pos.x/worldScale, pos.y/worldScale);
		var newEnemy = new SceneEnemyActor(this, loc, velocityX, velocityY);
		_allActors.push(newEnemy);
	}

	public function start()
	{
		addEventListener(Event.ENTER_FRAME, update);
	}

	public function stop():Void
	{
		removeEventListener(Event.ENTER_FRAME, update);
	}

	private function sceneFollowPlayer()
	{
 		if ( playerIsAlive )
 		{
 			root.scaleX = 2;
 			root.scaleY = 2;
 			//root.scrollRect = new Rectangle(player.getSprite().x - stage.stageWidth/4, player.getSprite().y - stage.stageHeight/4, stage.stageWidth, stage.stageHeight);
 			this.x = -player.getSprite().x + stage.stageWidth/4;
 			this.y = -player.getSprite().y + stage.stageHeight/4;
 		}
 		else 
 		{
 			root.scaleX = 1;
 			root.scaleY = 1;
 			root.x = 0;
 			root.y = 900;
 		}
	}

	private function createLevel()
	{	
		var groundPos = new B2Vec2(1920, 700);
		createGround(1920, 20, groundPos, 10);

	//	createWalls();
	}

	public function markToRemovePlayer(playerActor:ScenePlayerActor)
	{
		if( _playersToRemove.indexOf(playerActor) < 0 )
			_playersToRemove.push(playerActor);
			playerIsAlive = false;	
	}

	public function markToRemoveEnemy(enemyActor:SceneEnemyActor)
	{
		if ( _playersToRemove.indexOf(enemyActor) < 0)
			_playersToRemove.push(enemyActor);
	}

	public function removePlayersFromScene()
	{
		for (i in 0..._playersToRemove.length){
			_playersToRemove[i].destroy();
			var index =_playersToRemove.indexOf(_playersToRemove[i]);
			if (index > -1){
				_playersToRemove.splice(index, 1);
			}
		}
		_playersToRemove = new Array();
	}

	public function getUI()
	{
		return _userInterface;
	}

}