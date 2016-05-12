package;

import flash.display.Sprite;

import box2D.dynamics.B2Body;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;


class ScenePlayerActor extends SceneActor
{
	private var _parent:Scene;

	public function new(scene:Scene, pos:B2Vec2)
	{
		_parent = scene;
		var body:B2Body = createBody(pos);
		var sprite:Sprite = createSprite();

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
		polygon.setAsBox(5,5);
		body = _parent.world.createBody (bodyDef);
		fixtureDef.shape = polygon;
		body.createFixture(fixtureDef);

		return body;
	}

	private function createSprite():Sprite
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0x07aa15, 1);
		sprite.graphics.drawCircle(0, 0, 5);
		sprite.graphics.endFill();
		sprite.scaleX = 5 / sprite.width;
		sprite.scaleY = 5 / sprite.height;
		_parent.getCamera().addChild(sprite);
		return sprite;
	}
}