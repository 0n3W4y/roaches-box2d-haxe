package;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;
import flash.events.EventDispatcher;

import Math;

import flash.display.Sprite;

class WeaponBullet extends EventDispatcher
{
	private var _myScene:Scene;
	private var _body:B2Body;
	private var _sprite:Sprite;
	private var _damage:Int;

	public function new(scene, categoryBits, maskBits, dmg)
	{
		_damage = dmg;
		_myScene = scene;
		_body = createBody(categoryBits, maskBits);
		_sprite = createSprite();
		_body.setUserData(this);
		addEventListener(PlayerEvent.PLAYER_OFF_SCREEN, handleBulletOffScreen);
		update();
		super();
	}

	private function createBody(categoryBits, maskBits)
	{
		var polygonBody = new B2PolygonShape();
		var bodyDef = new B2BodyDef();
		var fixtureBody = new B2FixtureDef ();

		fixtureBody.density = 0;
		fixtureBody.friction = 0;
		fixtureBody.restitution = 0;

		fixtureBody.filter.categoryBits = categoryBits;
		fixtureBody.filter.maskBits = maskBits;

		var body;

		var weapon = _myScene.getCurrentPlayer().getWeapon();

		var posX = ( weapon.getBody().getPosition().x + (10/_myScene.worldScale)*Math.cos(weapon.getBody().getAngle()) );
		var posY = ( weapon.getBody().getPosition().y + (10/_myScene.worldScale)*Math.sin(weapon.getBody().getAngle()) );

		bodyDef.position.set(posX, posY);

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

		bulletOutOffScreen();
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
		//need 2-3 seconds, to play blow animation, then need to go to the next turn.
	}

	public function totallyDestroy()
	{
		_myScene.removeChild(_sprite);
		_myScene.world.destroyBody(_body);
	}

	private function bulletOutOffScreen()
	{
		if (_sprite.y > _myScene.maxSceneHeight || _sprite.x > _myScene.maxSceneWidth){
			dispatchEvent(new PlayerEvent(PlayerEvent.PLAYER_OFF_SCREEN));
			//remove;
		}
	}

	private function handleBulletOffScreen(e:PlayerEvent)
	{
		var actorToRemove:WeaponBullet = e.currentTarget;
		_myScene.markToDestroyBullet();
		actorToRemove.removeEventListener(PlayerEvent.PLAYER_OFF_SCREEN, handleBulletOffScreen);
	}

	public function getDamage()
	{
		return _damage;
	}

}