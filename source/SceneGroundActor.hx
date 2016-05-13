package;

import flash.display.Sprite;

import box2D.dynamics.B2Body;
import box2D.common.math.B2Vec2;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;

class SceneGroundActor  extends SceneActor
{
	private var _parent:Scene;

	public function new(scene:Scene, coord:Array<B2Vec2>, pos:B2Vec2)
	{	
		_parent = scene;
		var body = createBody(coord, pos);
		var sprite = createSprite(coord);

		super(scene, body, sprite);
	}

	private function createBody(coord:Array<B2Vec2>, pos:B2Vec2)
	{		
		var polygon = new B2PolygonShape ();
		var bodyDef = new B2BodyDef();
		var fixtureDef = new B2FixtureDef ();
		fixtureDef.density = 1;
		fixtureDef.friction = 0.3;
		fixtureDef.restitution = 0.4;
		var body;

		bodyDef.position.set (pos.x, pos.y);
		polygon.setAsArray(coord, coord.length);
		body = _parent.world.createBody (bodyDef);
		fixtureDef.shape = polygon;
		body.createFixture(fixtureDef);

		return body;
	}

	private function createSprite(coord:Array<B2Vec2>)
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000, 1);
		sprite.graphics.lineStyle(2, 0x0000ff);
		var firstPoint = coord[0];
		sprite.graphics.moveTo(firstPoint.x*_parent.worldScale, firstPoint.y*_parent.worldScale);
		for(i in 1...coord.length){
			var nextPoint = coord[i];
			sprite.graphics.lineTo(nextPoint.x*_parent.worldScale, nextPoint.y*_parent.worldScale);
		}

		sprite.graphics.lineTo(firstPoint.x*_parent.worldScale, firstPoint.y*_parent.worldScale);
		sprite.graphics.endFill();
		_parent.addChild(sprite);

		return sprite;
	}
}