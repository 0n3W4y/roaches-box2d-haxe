package;

import flash.display.Sprite;
import flash.Lib;
import flash.events.KeyboardEvent;
import flash.display.Stage;
import flash.text.TextField;
import flash.text.TextFieldType;

import box2D.dynamics.B2Body;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.collision.shapes.B2PolygonShape;

import Math;





class ScenePlayerActor extends SceneActor
{
	private var _parent:Scene;
	private var speed:Int = 0;

	private var body:B2Body;
	private var headCoord = new Array();
	private var bodyCoord = new Array();
	private var goLeft:Bool = false;
	private var goRight:Bool = false;
	private var goJump:Bool = false;
	private var speedX:Int;
	private var speedY:Int;

	private var _eType:String;
	private var _name:String;
	private var _hp:Int = 50;
	private var _nameTextField:TextField;
	private var _hpTextField:TextField;

	public var canJump:Bool = false;


	public function new(scene:Scene, pos:B2Vec2, velocityX:Int, velocityY:Int, eType:String, name:String = "Random")
	{
		_parent = scene;
		speedX = velocityX;
		speedY = velocityY;
		_eType = eType;
		_name = name;
		body = createBody(pos);
		var sprite:Sprite = createSprite();
		
		
		createName();
		createHp();

		sprite.addChild(_nameTextField);
		sprite.addChild(_hpTextField);

		addEventListener(PlayerEvent.PLAYER_OFF_SCREEN, handlePlayerOffScreen);

		super(scene, body, sprite, eType);

	}

	private function createBody(pos):B2Body
	{
		var polygonHead = new B2PolygonShape();
		var polygonBody = new B2PolygonShape();
		var polygonFootsSensor = new B2PolygonShape();
		var bodyDef = new B2BodyDef();
		var fixtureBody = new B2FixtureDef ();
		var fixtureHead = new B2FixtureDef ();
		var fixtureFootsSensor = new B2FixtureDef ();
		fixtureBody.density = 1;
		fixtureBody.friction = 1;
		fixtureBody.restitution = 0;
		fixtureHead.density = 1;
		fixtureHead.friction = 1;
		fixtureHead.restitution = 0;
		var body;

		bodyDef.position.set (pos.x, pos.y);
		bodyDef.type = B2Body.b2_dynamicBody;
		
		headCoord = [new B2Vec2(-2/_parent.worldScale, -12/_parent.worldScale), new B2Vec2(2/_parent.worldScale, -12/_parent.worldScale),
					new B2Vec2(2/_parent.worldScale, -8/_parent.worldScale), new B2Vec2(-2/_parent.worldScale, -8/_parent.worldScale)];
		
		bodyCoord = [new B2Vec2(-5/_parent.worldScale, -8/_parent.worldScale), new B2Vec2(5/_parent.worldScale, -8/_parent.worldScale),
					new B2Vec2(5/_parent.worldScale, 8/_parent.worldScale), new B2Vec2(-5/_parent.worldScale, 8/_parent.worldScale)];
		
		var footSensorCoord = new Array();
		footSensorCoord = [new B2Vec2(-5/_parent.worldScale, 8/_parent.worldScale), new B2Vec2(5/_parent.worldScale, 8/_parent.worldScale),
					new B2Vec2(5/_parent.worldScale, 12/_parent.worldScale), new B2Vec2(-5/_parent.worldScale, 12/_parent.worldScale)];


		polygonHead.setAsArray(headCoord, headCoord.length);
		polygonBody.setAsArray(bodyCoord, bodyCoord.length);
		polygonFootsSensor.setAsArray(footSensorCoord, footSensorCoord.length);

		body = _parent.world.createBody (bodyDef);
		fixtureBody.shape = polygonBody;
		fixtureBody.userData = "Body";
		fixtureHead.shape = polygonHead;
		fixtureHead.userData = "Head";
		fixtureFootsSensor.shape = polygonFootsSensor;
		fixtureFootsSensor.isSensor = true;
		fixtureFootsSensor.userData = "footSensor";
		body.createFixture(fixtureBody);
		body.createFixture(fixtureHead);
		body.createFixture(fixtureFootsSensor);
		body.setFixedRotation(true);

		return body;
	}

	private function createSprite():Sprite
	{
		var sprite = new Sprite();
		var color;
		if (_eType == "Player")
			color = 0x0000ff;
		else 
			color = 0xff0000;

		sprite.graphics.beginFill(color, 1);
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

		sprite.graphics.endFill();
		_parent.addChild(sprite);
		return sprite;
	}

	private function keyDownListener(e:KeyboardEvent)
	{	
		if (e.keyCode == 37)
		{
			goLeft = true;
		}
		else if(e.keyCode == 39)
		{
			goRight = true;
		}
		else if(e.keyCode == 38 && canJump)
		{
			goJump = true;
		}		
	}

	private function keyUpListener(e:KeyboardEvent)
	{
		if (e.keyCode == 37)
			goLeft = false;

		if (e.keyCode  == 39)
			goRight = false;

		if (e.keyCode == 38)
			goJump = false;
	
	}

	override public function childSpecificUpdate()
	{	
		playerMoving();
		playerOutOffScreen();
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

	private function playerOutOffScreen()
	{
		if (_sprite.y > _parent.maxSceneHeight || _sprite.x > _parent.maxSceneWidth){
			dispatchEvent(new PlayerEvent(PlayerEvent.PLAYER_OFF_SCREEN));
			//remove;
		}
	}

	private function handlePlayerOffScreen(e:PlayerEvent)
	{
		var actorToRemove:ScenePlayerActor = e.currentTarget;
		_parent.markToRemovePlayer(actorToRemove);
		actorToRemove.removeEventListener(PlayerEvent.PLAYER_OFF_SCREEN, handlePlayerOffScreen);
	}

	private function createName()
	{
		var textName:String;
		if (_name == "Random")
			textName = createRandomName();
		else
			textName = _name;

		_nameTextField = new TextField();
        _nameTextField.x = -50;
        _nameTextField.y = -80;
        _nameTextField.width = 100;
        _nameTextField.height = 25;
        _nameTextField.text = textName;

	}

	private function createHp()
	{
		_hpTextField = new TextField();
        _hpTextField.x = -12;
        _hpTextField.y = -50;
        _hpTextField.width = 25;
        _hpTextField.height = 25;
        var hp = Std.string(_hp);
        _hpTextField.text = hp;
	}

	private function createRandomName()
	{
		var names:Array<String> = new Array();
		names = ["Bob Greender", "Dylan Backstreet", "Rolf Cannigan", "Carl Wolf", "Duck Haskee", "Gorsen Freemon", "Hubort Konter", "lol :D"];
		var index = Math.round(Math.random() * names.length );
		return names[index];
	}

	public function addInputListener()
	{
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
	}

	public function removeInputListener()
	{
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
	}

	public function runAI()
	{

	}

	public function forciblyKeyUp()
	{
		goLeft = false;
		goRight = false;
		goJump = false;

	}
}