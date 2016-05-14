package;

import flash.display.Sprite;
import flash.Lib;
import flash.events.KeyboardEvent;
import flash.display.Stage;

import box2D.dynamics.B2Body;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;





class ScenePlayerActor extends SceneActor
{
	private var _parent:Scene;
	private var speed:Int = 0;

	private var body:B2Body;

	public function new(scene:Scene, pos:B2Vec2)
	{
		_parent = scene;
		body = createBody(pos);
		var sprite:Sprite = createSprite();

		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		//_parent.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);

		super(scene, body, sprite);

	}

	private function createBody(pos):B2Body
	{
		var polygon = new B2PolygonShape ();
		var bodyDef = new B2BodyDef();
		var fixtureDef = new B2FixtureDef ();
		fixtureDef.density = 1;
		fixtureDef.friction = 0.3;
		fixtureDef.restitution = 0.4;
		var body;

		bodyDef.position.set (pos.x, pos.y);
		bodyDef.type = B2Body.b2_dynamicBody;
		//bodyDef.userData.name = "Player";
		polygon.setAsBox(10/_parent.worldScale,10/_parent.worldScale);
		body = _parent.world.createBody (bodyDef);
		fixtureDef.shape = polygon;
		body.createFixture(fixtureDef);

		return body;
	}

	private function createSprite():Sprite
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0x07aa15, 1);
		sprite.graphics.drawCircle(0, 0, 10);
		sprite.graphics.endFill();
		sprite.scaleX = 20 / sprite.width;
		sprite.scaleY = 20 / sprite.height;
		_parent.addChild(sprite);
		return sprite;
	}

	private function keyDownListener(e:KeyboardEvent)
	{	
		var speedX:Int = 0;
		var speedY:Int = 0;

		if (e.keyCode == 37)
		{
			speedX = -5;
		}

		if (e.keyCode == 39)
		{
			speedX = 5;
		}

		if(e.keyCode == 38)
		{
			speedY = 10;
		}

		body.setLinearVelocity(new B2Vec2(speedX, speedY));
	}

	private function keyUpListener(e:KeyboardEvent)
	{
		if (e.keyCode == 37)
		{
			body.setLinearVelocity(new B2Vec2(0, 0));
		}

		if (e.keyCode == 39)
		{
			body.setLinearVelocity(new B2Vec2(0, 0));
		}

		if(e.keyCode == 38)
		{
			body.setLinearVelocity(new B2Vec2(0, 0));
		}
	}

}