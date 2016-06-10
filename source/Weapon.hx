package;

import box2D.dynamics.B2Body;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;

import Math;

import flash.display.Sprite;

class Weapon 
{
	public var damage:Int;
	private var _sizeX:Int;
	private var _sizeY:Int;
	private var _name:String = "Bazooka";
	private var _type:String = "rocket";
	private var _body:B2Body;
	private var _sprite:Sprite;
	private var _myScene:Scene;


	public function new(scene)
	{
		damage = 10;
		_sizeX = 5;
		_sizeY = 2;
		_myScene = scene;

		_body = createBody();
		_sprite = createSprite();

	}

	public function getName()
	{
		return _name;
	}

	public function getType()
	{
		return _type;
	}

	public function getBody()
	{
		return _body;
	}

	public function getSprite()
	{
		return _sprite;
	}

	private function createBody()
	{
		var polygonShape = new B2PolygonShape();
		var bodyDef = new B2BodyDef();
		var fixtureBody = new B2FixtureDef ();
		fixtureBody.density = 0;
		fixtureBody.friction = 0;
		fixtureBody.restitution = 0;

		var body;

		bodyDef.position.set (0, 0);
		bodyDef.type = B2Body.b2_kinematicBody;

		polygonShape.setAsBox(_sizeX/_myScene.worldScale, _sizeY/_myScene.worldScale);

		body = _myScene.world.createBody(bodyDef);
		fixtureBody.shape = polygonShape;
		fixtureBody.userData = "weapon";
		body.createFixture(fixtureBody);

		return body;
	}

	private function createSprite()
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0x0000aa, 1);
		sprite.graphics.lineStyle(2, 0x000000, 1);

		sprite.graphics.moveTo( -_sizeX*2, _sizeY*2);
		sprite.graphics.lineTo( _sizeX*2, _sizeY*2);
		sprite.graphics.lineTo( _sizeX*2, -_sizeY*2);
		sprite.graphics.lineTo( -_sizeX*2, -_sizeY*2);

		sprite.graphics.endFill();
		_myScene.addChild(sprite);

		return sprite;


	}
}
