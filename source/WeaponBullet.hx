package;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;

import Math;

import flash.display.Sprite;

class WeaponBullet 
{
	private var _myScene:Scene;
	private var _body:B2Body;
	private var _sprite:Sprite;

	public function new(scene, categoryBits, maskBits)
	{
		_myScene = scene;
		_body = createBody(categoryBits, maskBits);
		_sprite = createSprite();
	}

	private function createBody(categoryBits, maskBits)
	{
		var polygonBody = new B2PolygonShape();
		var bodyDef = new B2BodyDef();
		var fixtureBody = new B2FixtureDef ();

		fixtureBody.density = 0;
		fixtureBody.friction = 1;
		fixtureBody.restitution = 0;

		fixtureBody.filter.categoryBits = categoryBits;
		fixtureBody.filter.maskBits = maskBits;

		var body;

		//var posX = ( weapon.getBody().getPosition().x+( weapon.getSize("X")+3)*Math.cos( weapon.getBody().getAngle()))/_myScene.worldScale;
		//var posY = ( weapon.getBody().getPosition().y+( weapon.getSize("Y")+3)*Math.sin( weapon.getBody().getAngle()))/_myScene.worldScale;

		//bodyDef.position.set(posX, posY);

		var weapon = _myScene.getCurrentPlayer().getWeapon();

		bodyDef.position.set( weapon.getBody().getPosition().x,  weapon.getBody().getPosition().y);
		bodyDef.type = B2Body.b2_dynamicBody;
		bodyDef.bullet = true;


			
		polygonBody.setAsBox(2/_myScene.worldScale,1/_myScene.worldScale);

		body = _myScene.world.createBody (bodyDef);

		fixtureBody.shape = polygonBody;
		fixtureBody.userData = "bullet";
		
		body.createFixture(fixtureBody);
		body.setFixedRotation(true);

		return body;
	}

	private function createSprite()
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0x00ff00, 1);
		sprite.graphics.lineStyle(1, 0x000000, 1);

		sprite.graphics.moveTo( -2, 1);
		sprite.graphics.lineTo( 2, 1);
		sprite.graphics.lineTo( 2, -1);
		sprite.graphics.lineTo( -2, -1);
		sprite.graphics.lineTo( -2, 1);

		sprite.graphics.endFill();
		_myScene.addChild(sprite);
		return sprite;
	}

	public function update()
	{
		_sprite.x = _body.getPosition().x*_myScene.worldScale;
		_sprite.y = _body.getPosition().y*_myScene.worldScale;
		_sprite.rotation = _body.getAngle() * 180/Math.PI;
	}

	public function getBody()
	{
		return _body;
	}

	public function getSprite()
	{
		return _sprite;
	}

	public function destroy()
	{
		_myScene.markToDestroyBullet();
	}

	public function totallyDestroy()
	{
		_myScene.removeChild(_sprite);
		_myScene.world.destroyBody(_body);
	}

}