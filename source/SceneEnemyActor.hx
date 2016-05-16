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





class SceneEnemyActor extends SceneActor
{
	private var _parent:Scene;
	private var speed:Int = 0;

	private var body:B2Body;
	private var headCoord = new Array();
	private var bodyCoord = new Array();
	private var footCoord = new Array();
	private var goLeft:Bool = false;
	private var goRight:Bool = false;
	private var goJump:Bool = false;
	private var speedX:Int;
	private var speedY:Int;

	public var canJump:Bool = false;


	public function new(scene:Scene, pos:B2Vec2, velocityX:Int, velocityY:Int)
	{
		_parent = scene;
		speedX = velocityX;
		speedY = velocityY;
		body = createBody(pos);
		var sprite:Sprite = createSprite();

		addEventListener(EnemyEvent.ENEMY_OFF_SCREEN, handleEnemyOffScreen);

		super(scene, body, sprite);

	}

	private function createBody(pos):B2Body
	{
		var polygonHead = new B2PolygonShape();
		var polygonBody = new B2PolygonShape();
		var polygonFoots = new B2PolygonShape();
		var polygonFootsSensor = new B2PolygonShape();
		var bodyDef = new B2BodyDef();
		var fixtureBody = new B2FixtureDef ();
		var fixtureHead = new B2FixtureDef ();
		var fixtureFoots = new B2FixtureDef ();
		var fixtureFootsSensor = new B2FixtureDef ();
		fixtureBody.density = 1;
		fixtureBody.friction = 0;
		fixtureBody.restitution = 0.1;
		fixtureFoots.density = 1;
		fixtureFoots.friction = 1;
		fixtureFoots.restitution = 0;
		fixtureHead.density = 1;
		fixtureHead.friction = 0;
		fixtureHead.restitution = 0.1;
		var body;

		bodyDef.position.set (pos.x, pos.y);
		bodyDef.type = B2Body.b2_dynamicBody;
		
		headCoord = [new B2Vec2(-5/_parent.worldScale, -25/_parent.worldScale), new B2Vec2(5/_parent.worldScale, -25/_parent.worldScale),
					new B2Vec2(5/_parent.worldScale, -15/_parent.worldScale), new B2Vec2(-5/_parent.worldScale, -15/_parent.worldScale)];
		
		bodyCoord = [new B2Vec2(-10/_parent.worldScale, -15/_parent.worldScale), new B2Vec2(10/_parent.worldScale, -15/_parent.worldScale),
					new B2Vec2(10/_parent.worldScale, 15/_parent.worldScale), new B2Vec2(-10/_parent.worldScale, 15/_parent.worldScale)];
		
		footCoord = [new B2Vec2(-8/_parent.worldScale, 15/_parent.worldScale), new B2Vec2(8/_parent.worldScale, 15/_parent.worldScale),
					new B2Vec2(8/_parent.worldScale, 30/_parent.worldScale), new B2Vec2(-8/_parent.worldScale, 30/_parent.worldScale)];
		var footSensorCoord = new Array();
		footSensorCoord = [new B2Vec2(-8/_parent.worldScale, 30/_parent.worldScale), new B2Vec2(8/_parent.worldScale, 30/_parent.worldScale),
					new B2Vec2(8/_parent.worldScale, 35/_parent.worldScale), new B2Vec2(-8/_parent.worldScale, 35/_parent.worldScale)];


		polygonHead.setAsArray(headCoord, headCoord.length);
		polygonBody.setAsArray(bodyCoord, bodyCoord.length);
		polygonFoots.setAsArray(footCoord, footCoord.length);
		polygonFootsSensor.setAsArray(footSensorCoord, footSensorCoord.length);

		body = _parent.world.createBody (bodyDef);
		fixtureBody.shape = polygonBody;
		fixtureBody.userData = "Body";
		fixtureHead.shape = polygonHead;
		fixtureHead.userData = "Head";
		fixtureFoots.shape = polygonFoots;
		fixtureFoots.userData = "Foots";
		fixtureFootsSensor.shape = polygonFootsSensor;
		fixtureFootsSensor.isSensor = true;
		fixtureFootsSensor.userData = "footSensor";
		body.createFixture(fixtureBody);
		body.createFixture(fixtureHead);
		body.createFixture(fixtureFoots);
		body.createFixture(fixtureFootsSensor);
		body.setFixedRotation(true);

		return body;
	}

	private function createSprite():Sprite
	{
		var sprite = new Sprite();
		sprite.graphics.beginFill(0xaa0000, 1);
		sprite.graphics.lineStyle(2, 0x000000, 1);
		
	
		sprite.graphics.moveTo(headCoord[0].x*_parent.worldScale, headCoord[0].y*_parent.worldScale);
		sprite.graphics.lineTo(headCoord[1].x*_parent.worldScale, headCoord[1].y*_parent.worldScale);
		sprite.graphics.lineTo(headCoord[2].x*_parent.worldScale, headCoord[2].y*_parent.worldScale);
		sprite.graphics.lineTo(headCoord[3].x*_parent.worldScale, headCoord[3].y*_parent.worldScale);
		sprite.graphics.lineTo(headCoord[0].x*_parent.worldScale, headCoord[0].y*_parent.worldScale);

		sprite.graphics.moveTo(bodyCoord[0].x*_parent.worldScale, bodyCoord[0].y*_parent.worldScale);
		sprite.graphics.lineTo(bodyCoord[1].x*_parent.worldScale, bodyCoord[1].y*_parent.worldScale);
		sprite.graphics.lineTo(bodyCoord[2].x*_parent.worldScale, bodyCoord[2].y*_parent.worldScale);
		sprite.graphics.lineTo(bodyCoord[3].x*_parent.worldScale, bodyCoord[3].y*_parent.worldScale);
		sprite.graphics.lineTo(bodyCoord[0].x*_parent.worldScale, bodyCoord[0].y*_parent.worldScale);

		sprite.graphics.moveTo(footCoord[0].x*_parent.worldScale, footCoord[0].y*_parent.worldScale);
		sprite.graphics.lineTo(footCoord[1].x*_parent.worldScale, footCoord[1].y*_parent.worldScale);
		sprite.graphics.lineTo(footCoord[2].x*_parent.worldScale, footCoord[2].y*_parent.worldScale);
		sprite.graphics.lineTo(footCoord[3].x*_parent.worldScale, footCoord[3].y*_parent.worldScale);
		sprite.graphics.lineTo(footCoord[0].x*_parent.worldScale, footCoord[0].y*_parent.worldScale);


		sprite.graphics.endFill();
		_parent.addChild(sprite);
		return sprite;
	}

	override public function childSpecificUpdate()
	{	
		playerMoving();
		enemyOutOffScreen();
	}

	private function playerMoving()
	{
		var velY = body.getLinearVelocity().y;

		if (goLeft)
		{
			body.applyTorque(10);
			body.setLinearVelocity(new B2Vec2(-speedX, velY));
		}
		else if (goRight)
		{
			body.applyTorque(10);
			body.setLinearVelocity(new B2Vec2(speedX, velY));
		}

		if (goJump && canJump)
		{
			body.applyImpulse(new B2Vec2(0, -speedY), body.getWorldCenter());
			canJump = false;
		}
	}

	private function enemyOutOffScreen()
	{
		if (_sprite.y > _parent.maxSceneHeight || _sprite.x > _parent.maxSceneWidth){
			dispatchEvent(new EnemyEvent(EnemyEvent.ENEMY_OFF_SCREEN));
			//remove;
		}
	}

	private function handleEnemyOffScreen(event:EnemyEvent)
	{
		var actorToRemove = event.currentTarget;
		_parent.markToRemoveEnemy(actorToRemove);
		actorToRemove.removeEventListener(EnemyEvent.ENEMY_OFF_SCREEN, handleEnemyOffScreen);
		
	}

}