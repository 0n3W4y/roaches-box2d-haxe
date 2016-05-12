package;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;
import flash.events.EventDispatcher;

import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2DebugDraw;

class Scene
{
	public var parent:Game;
	public var globalSprite:Sprite;
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
		initilize();
		parent = game;
		globalSprite = game.parent;
		trace (game.parent);


	}

	private function initilize()
	{
		createTimeMaster();
		createWorld();
		createContactListener();
		createCamera();

	//	addDebuger();

	//	createActors();
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

	public function getCamera():Camera
	{
		return _camera;
	}

	private function update(event:Event)
	{
		var step = _timeMaster.getTimeStep();
		world.step(1/30, velocityIterations, positionIterations);
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
		_camera.addChild(debugSprite);
		
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

	private function createCamera()
	{
		_camera = new Camera(this);
	//	globalSprite.addChild(_camera);
	globalSprite.addSpriteChild(_camera);
	}

	private function createGroundActor()
	{
		var coord = new Array();
		coord.push(new B2Vec2(-1280/worldScale, 700/worldScale));
		coord.push(new B2Vec2(-1100/worldScale, 680/worldScale));
		coord.push(new B2Vec2(-800/worldScale, 710/worldScale));
		coord.push(new B2Vec2(-500/worldScale, 690/worldScale));
		coord.push(new B2Vec2(-250/worldScale, 720/worldScale));
		coord.push(new B2Vec2(0/worldScale, 730/worldScale)); //special point
		coord.push(new B2Vec2(200/worldScale, 690/worldScale));
		coord.push(new B2Vec2(1280/worldScale, 720/worldScale));
		coord.push(new B2Vec2(1280/worldScale, 760/worldScale));
		coord.push(new B2Vec2(-1280/worldScale, 760/worldScale));

		var pos = new B2Vec2(1280/worldScale, 720/worldScale);

		var newGroundActor = new SceneGroundActor(this, coord, pos);

		_allActors.push(newGroundActor);
	}

	private function createPlayerActor()
	{
		var pos = new B2Vec2(300/worldScale, 100/worldScale);
		var newPlayer = new ScenePlayerActor(this, pos);
		_allActors.push(newPlayer);
	}


}