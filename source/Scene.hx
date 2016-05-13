package;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;
import flash.events.EventDispatcher;
import flash.geom.Point;

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
	private var _camera:Camera;
	private var _timeMaster:TimeMaster;

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
		createGroundActor();
		createPlayerActor();
	}

	private function createGroundActor()
	{
/*
		var coord = new Array();
		coord.push(new B2Vec2(-1280/2/worldScale, 40/2/worldScale));
		coord.push(new B2Vec2(-1280/2/worldScale, -40/2/worldScale));
		coord.push(new B2Vec2(-1000/2/worldScale, -80/2/worldScale));
		coord.push(new B2Vec2(-80/2/worldScale, -40/2/worldScale));
		coord.push(new B2Vec2(400/2/worldScale, -80/2/worldScale));
		coord.push(new B2Vec2(1280/2/worldScale, -40/2/worldScale));
		coord.push(new B2Vec2(1280/2/worldScale, 40/2/worldScale));
*/
		var width = 1280/2;
		var figures = 4;
		var pos = new B2Vec2(1280/2/worldScale, 720/worldScale);

		var newGroundActor = new SceneGroundActor(this, width, pos, figures);

		_allActors.push(newGroundActor);
	}

	private function createPlayerActor()
	{
		var pos = new B2Vec2(300/worldScale, 100/worldScale);
		var newPlayer = new ScenePlayerActor(this, pos);
		_allActors.push(newPlayer);
	}

	public function start()
	{
		addEventListener(Event.ENTER_FRAME, update);
	}

	public function stop():Void
	{
		removeEventListener(Event.ENTER_FRAME, update);
	}


}