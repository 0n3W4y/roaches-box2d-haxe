package;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;

import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;

class Scene extends Sprite
{
	public var myGame:Game;
	public var world:B2World;

	private var worldScale:Int = 30; // pixel to metr;
	private var worldGravity:B2Vec2;
	private var worldStep:Float; 
	private var velocityIterations:Int = 10;
	private var positionIterations:Int = 10;

	public function new(game)
	{
		super();
		initilize();
		myGame = game;
		Main.myGameScene = this;
	}

	private function initilize()
	{
		createWorld();
	}

	private function createWorld()
	{
		worldGravity = new B2Vec2(0, 9.8); //x=0, y=G == 9.8;
		var isSleep:Bool = true;
		world = new B2World(worldGravity, isSleep);
	}

	public function start(fps:Int)
	{	
		worldStep = 1/fps;
		addEventListener(Event.ENTER_FRAME, update);

	}

	private function update(event:Event)
	{
		world.step(worldStep, velocityIterations, positionIterations);
		world.clearForces();
	}


}