package;

import flash.display.Sprite;

import box2D.dynamics.B2Body;
import box2D.common.math.B2Vec2;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;

import Math;

class SceneGroundActor  extends SceneActor
{
	private var _parent:Scene;
	private var maxHeight:Int = 60;
	private var minHeight:Int = 10;
	private var maxHoleWidth:Int = 20;

	private var coordsArray:Array<Dynamic> = new Array();

	public function new(scene:Scene, width:Float, pos:B2Vec2, figures:Int)
	{	
		_parent = scene;
		var body = generateGround(width, pos, figures);
		var sprite = createSprite();

		super(scene, body, sprite);
	}

	private function createSprite()
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000, 1);
		sprite.graphics.lineStyle(2, 0x0000ff);

		for (i in 0...coordsArray.length)
		{
			var firstCoord = coordsArray[i];
			var firstPoint = firstCoord[0];

			sprite.graphics.moveTo(firstPoint.x*_parent.worldScale, firstPoint.y*_parent.worldScale);
			for(i in 1...firstCoord.length){
				var nextPoint = firstCoord[i];
				sprite.graphics.lineTo(nextPoint.x*_parent.worldScale, nextPoint.y*_parent.worldScale);
			}
			sprite.graphics.lineTo(firstPoint.x*_parent.worldScale, firstPoint.y*_parent.worldScale);
			sprite.graphics.endFill();
			_parent.addChild(sprite);
		}

		return sprite;
	}

	private function generateGround(width:Float, pos:B2Vec2, figures:Int) //generate from left to right
	{
		var polygonArray = new Array();
		var fixturesArray = new Array();
		for (i in 0...figures)
		{
			var newPolygon = new B2PolygonShape();
			var newFixture = new B2FixtureDef();

			newFixture.density = 1;
			newFixture.friction = 0.1;
			newFixture.restitution = 0.6;
			polygonArray.push(newPolygon);
			fixturesArray.push(newFixture);
		}

		var definedPolygons = generatePolygons(width, pos, polygonArray);

		var bodyDef = new B2BodyDef();
		var body:B2Body;

		bodyDef.position.set(pos.x, pos.y);
		body = _parent.world.createBody(bodyDef);

		for (j in 0...polygonArray.length)
		{
			fixturesArray[j].shape = polygonArray[j];
			body.createFixture(fixturesArray[j]);
		}

		return body;


	}

	private function generatePolygons(width:Float, pos:B2Vec2, polygonArray:Array<Dynamic>)
	{	
		var maxWidthPerPolygon = width*2 / polygonArray.length;
		var maxWidth = width;

		for (i in 0...polygonArray.length)
		{
			var coordArray = new Array();
			var doHole = Math.round(Math.random());
			var a:Int;

			if (i < polygonArray.length/2)
				a = -1;
			else
				a = 1;

			var lPointX;
			var rPointX;

			var lPointY = maxHeight;
			var rPointY = maxHeight;

			if (doHole > 0)
			{
				lPointX = a*maxWidth - a*maxHoleWidth;
				rPointX = a*maxWidth - a*maxWidthPerPolygon - a*maxHoleWidth;
			}
			else
			{
				lPointX = a*maxWidth;
				rPointX = a*maxWidth - a*maxWidthPerPolygon - a*maxHoleWidth;
			}


			var lPoint2X = a*(Math.round((maxWidth - maxWidthPerPolygon/2) + Math.random()*(maxWidth - (maxWidth - maxWidthPerPolygon/2))));
			var	lPoint2Y = -Math.round((minHeight) + Math.random()*(maxHeight - minHeight));

			var	rPoint2X = a*(Math.round(maxWidthPerPolygon + Math.random()*((maxWidth - maxWidthPerPolygon/2) - maxWidthPerPolygon)));
			var	rPoint2Y = -Math.round((minHeight) + Math.random()*(maxHeight - minHeight));
			

			if (maxWidth > 0)
				maxWidth -= maxWidthPerPolygon;
			else
				maxWidth += maxWidthPerPolygon;


			

			coordArray.push(new B2Vec2(lPointX/_parent.worldScale, lPointY/_parent.worldScale));
			coordArray.push(new B2Vec2(lPointX/_parent.worldScale, -lPointY/_parent.worldScale));
			
			coordArray.push(new B2Vec2(lPoint2X/_parent.worldScale, lPoint2Y/_parent.worldScale));
			coordArray.push(new B2Vec2(rPointX/_parent.worldScale, rPointY/_parent.worldScale));			

			coordArray.push(new B2Vec2(rPointX/_parent.worldScale, -rPointY/_parent.worldScale));
			coordArray.push(new B2Vec2(rPointX/_parent.worldScale, rPointY/_parent.worldScale));

			

			polygonArray[i].setAsArray(coordArray, coordArray.length);

			coordsArray.push(coordArray);
		}

		return polygonArray;
	}
}