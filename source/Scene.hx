package;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;

import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2DebugDraw;

class Scene extends Sprite
{
	public var myGame:Main;
	public var world:B2World;
	public var worldScale:Int = 30; // pixel to metr;
	
	private var worldGravity:B2Vec2;
	private var worldStep:Float; 
	private var velocityIterations:Int = 10;
	private var positionIterations:Int = 10;
	private var sceneContactListener:ContactListener;

	private var _allChilds:Array<Dynamic>;

	public function new(game)
	{
		super();

		initilize();
		myGame = game;
	}

	private function initilize()
	{
		createWorld();
		addDebuger();
	}

	private function createWorld()
	{
		worldGravity = new B2Vec2(0, 9.8); //x=0, y=G == 9.8;
		var isSleep:Bool = true;
		world = new B2World(worldGravity, isSleep);
		sceneContactListener = new ContactListener();
		world.setContactListener(sceneContactListener);
	}

	public function start(fps:Int)
	{	
		worldStep = 1/fps;
		addEventListener(Event.ENTER_FRAME, update);

	}

	public function stop()
	{
		removeEventListener(Event.ENTER_FRAME, update);
	}

	public function pause(){

	}

	private function update(event:Event)
	{
		world.step(worldStep, velocityIterations, positionIterations);
		world.clearForces();
		world.drawDebugData();

		for(i in 0..._allChilds.length)
		{
			_allChilds[i].update();
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


}