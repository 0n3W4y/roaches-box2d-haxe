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
	private var maxHeight:Int = 100;
	private var minHeight:Int = 5;
	private var maxHoleWidth:Int = 20;

	private var coordsArray:Array<Dynamic> = new Array();

	public function new(scene:Scene, width:Float, pos:B2Vec2, figures:Int, holes:Bool = false)
	{	
		_parent = scene;
		//var body = generateGround(width, pos, figures);
		var body = createBody(width, pos, figures, holes);
		var sprite = createSprite(pos);

		super(scene, body, sprite);
	}

	private function createSprite(pos:B2Vec2)
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0x00dd44, 0.5);
		sprite.graphics.lineStyle(2, 0xff0000);


			var wh = coordsArray[0];
			sprite.graphics.moveTo(wh[0].x*_parent.worldScale, 1*_parent.worldScale);
			sprite.graphics.lineTo(wh[1].x*_parent.worldScale, wh[1].y*_parent.worldScale);
			sprite.graphics.lineTo(wh[2].x*_parent.worldScale, wh[2].y*_parent.worldScale);
			sprite.graphics.lineTo(wh[3].x*_parent.worldScale, 4*_parent.worldScale);
			sprite.graphics.lineTo(wh[0].x*_parent.worldScale, 1*_parent.worldScale);
			trace(wh[0].y + " = wh0y; " + wh[1].y + " = wh1y;");
		
		sprite.graphics.endFill();
		_parent.addChild(sprite);

		return sprite;
	}

	private function createBody(width:Float, pos:B2Vec2, figures:Int, holes:Bool)
	{
		var polygonArray = new Array();
		var fixturesArray = new Array();

		var widthPerFigure = width*2 / figures;
		var maxWidth = width;

		for (i in 0...figures)
		{	
			var coordArray = new Array();
			var a = 0;

			if (holes)
			{	
				var doHoles = Math.round(Math.random());
				if(doHoles > 0)
					a = maxHoleWidth;
			}

			var p1x;
			var p2x;
			var py;

			if (i < figures/2)
			{
				p1x = -maxWidth + a;
				p2x = -maxWidth + widthPerFigure - a;
				py = minHeight;

			}
			else
			{
				p1x = maxWidth - widthPerFigure + a;
				p2x = maxWidth - a;
				py = minHeight;
				
			}

			coordArray.push(new B2Vec2(p1x/_parent.worldScale, -py/_parent.worldScale));
			coordArray.push(new B2Vec2(p2x/_parent.worldScale, -py/_parent.worldScale));
			coordArray.push(new B2Vec2(p2x/_parent.worldScale, py/_parent.worldScale));
			coordArray.push(new B2Vec2(p1x/_parent.worldScale, py/_parent.worldScale));

			

			coordsArray.push(coordArray);

			if (maxWidth > widthPerFigure)
				maxWidth -= widthPerFigure;
			else if (maxWidth == widthPerFigure && i < figures/2)
			{

			}
			else
				maxWidth += widthPerFigure;

			var newPolygon = new B2PolygonShape();
			newPolygon.setAsArray(coordArray, coordArray.length);
			polygonArray.push(newPolygon);

			var newFixture = new B2FixtureDef();
			newFixture.density = 0;
			newFixture.friction = 0.1;
			newFixture.restitution = 0.6;
			fixturesArray.push(newFixture);
			
		}

		var bodyDef = new B2BodyDef();
		var body:B2Body;

		bodyDef.position.set(pos.x, pos.y);
		body = _parent.world.createBody(bodyDef);

		for (k in 0...polygonArray.length)
		{
			fixturesArray[k].shape = polygonArray[k];
			body.createFixture(fixturesArray[k]);
		}

		return body;


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

		for (k in 0...polygonArray.length)
		{
			fixturesArray[k].shape = polygonArray[k];
			body.createFixture(fixturesArray[k]);
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

			var lPointX;
			var lPoint2X;
			var	rPoint2X;
			var rPointX;


			if (i < polygonArray.length/2)
			{
				lPointX = -maxWidth;
				rPointX = -maxWidth + maxWidthPerPolygon;
				lPoint2X = -(Math.round((maxWidth - maxWidthPerPolygon/2) + Math.random()*(maxWidth - (maxWidth - maxWidthPerPolygon/2))));
				rPoint2X = -(Math.round((maxWidth - maxWidthPerPolygon) + Math.random()*((maxWidth - maxWidthPerPolygon/2) - (maxWidth - maxWidthPerPolygon))));
			}
			else
			{
				lPointX = maxWidth -  maxWidthPerPolygon;
				rPointX = maxWidth;
				lPoint2X = (Math.round((maxWidth - maxWidthPerPolygon) + Math.random()*((maxWidth - maxWidthPerPolygon/2) - (maxWidth - maxWidthPerPolygon))));
				rPoint2X = (Math.round((maxWidth - maxWidthPerPolygon/2) + Math.random()*(maxWidth - (maxWidth - maxWidthPerPolygon/2))));	
			}


			var lPointY = minHeight;
			var rPointY = minHeight;
			var	lPoint2Y = -Math.round((minHeight) + Math.random()*(maxHeight - minHeight));
			var	rPoint2Y = -Math.round((minHeight) + Math.random()*(maxHeight - minHeight));
			

			if (maxWidth > maxWidthPerPolygon)
				maxWidth -= maxWidthPerPolygon;
			else if (maxWidth == maxWidthPerPolygon && i <= polygonArray.length/2)
			{

			}
			else
				maxWidth += maxWidthPerPolygon;

			
			coordArray.push(new B2Vec2(lPointX/_parent.worldScale, -lPointY/_parent.worldScale));
			
			coordArray.push(new B2Vec2(lPoint2X/_parent.worldScale, lPoint2Y/_parent.worldScale));
			coordArray.push(new B2Vec2(rPoint2X/_parent.worldScale, rPoint2Y/_parent.worldScale));			

			coordArray.push(new B2Vec2(rPointX/_parent.worldScale, -rPointY/_parent.worldScale));
			coordArray.push(new B2Vec2(rPointX/_parent.worldScale, rPointY/_parent.worldScale));

			coordArray.push(new B2Vec2(lPointX/_parent.worldScale, lPointY/_parent.worldScale));

			

			polygonArray[i].setAsArray(coordArray, coordArray.length);

			coordsArray[i] = coordArray;
		}

		return polygonArray;
	}

}