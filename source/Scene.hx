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

		addDebuger();

		createLevel();
		createActors();
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
		
		var playerPos = new B2Vec2(100, 980);
		createPlayerActor(playerPos, 5, 8);
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
		_allActors.push(player);
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
 		
 		root.scaleX = 2;
 		root.scaleY = 2;
 		root.scrollRect = new Rectangle(player.getSprite().x - stage.stageWidth/4, player.getSprite().y - stage.stageHeight/4, stage.stageWidth, stage.stageHeight);
	}

	private function createLevel()
	{	
		var groundPos = new B2Vec2(1920, 1080);
		createGround(1920, 20, groundPos, 10);

		var upperGroundPos = new B2Vec2(1920, 880);
		createGround(1000, 10, upperGroundPos, 4);

	//	createWalls();
	}


}