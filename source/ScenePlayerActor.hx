package;

import flash.display.Sprite;
import flash.Lib;
import flash.events.KeyboardEvent;
import flash.display.Stage;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.events.MouseEvent;
import flash.events.Event;

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
	private var bodyCoord = new Array();
	private var goLeft:Bool = false;
	private var goRight:Bool = false;
	private var goJump:Bool = false;
	private var goShoot:Bool = false;
	private var canShoot:Bool = false;
	private var speedX:Int;
	private var speedY:Int;
	private var isMooving:Bool = false;
	private var endShooting:Bool = false;
	private var _moveAfterShooting:Bool = false;

	private var _enemy:ScenePlayerActor = null;
	private var _aimDirection = null;
	private var _isEndAiming:Bool = false;

	private var _haveWeapon:Bool = false;
	private var _weapon:Weapon;
	private var _isWeaponShowed:Bool = false;

	private var _eType:String;
	private var _name:String;
	private var _hp:Int = 50;
	private var _nameTextField:TextField;
	private var _hpTextField:TextField;

	public var canJump:Bool = false;


	public function new(scene:Scene, pos:B2Vec2, velocityX:Int, velocityY:Int, eType:String, name:String = "Random", categoryBits, maskBits)
	{
		_parent = scene;
		speedX = velocityX;
		speedY = velocityY;
		_eType = eType;
		_name = name;
		body = createBody(pos, categoryBits, maskBits);
		var sprite:Sprite = createSprite();
		
		
		createName();
		createHp();

		sprite.addChild(_nameTextField);
		sprite.addChild(_hpTextField);

		addEventListener(PlayerEvent.PLAYER_OFF_SCREEN, handlePlayerOffScreen);

		super(scene, body, sprite, eType);

	}

	private function createBody(pos, categoryBits, maskBits):B2Body
	{
		var polygonBody = new B2PolygonShape();
		var polygonFootsSensor = new B2PolygonShape();
		var bodyDef = new B2BodyDef();
		var fixtureBody = new B2FixtureDef ();
		var fixtureFootsSensor = new B2FixtureDef ();
		fixtureBody.density = 100;
		fixtureBody.friction = 1;
		fixtureBody.restitution = 0;
		fixtureBody.filter.categoryBits = categoryBits;
		fixtureBody.filter.maskBits = maskBits;
		var body;

		bodyDef.position.set (pos.x, pos.y);
		bodyDef.type = B2Body.b2_dynamicBody;
		
		bodyCoord = [new B2Vec2(-5/_parent.worldScale, -8/_parent.worldScale), new B2Vec2(5/_parent.worldScale, -8/_parent.worldScale),
					new B2Vec2(5/_parent.worldScale, 8/_parent.worldScale), new B2Vec2(-5/_parent.worldScale, 8/_parent.worldScale)];
		
		var footSensorCoord = new Array();
		footSensorCoord = [new B2Vec2(-5/_parent.worldScale, 8/_parent.worldScale), new B2Vec2(5/_parent.worldScale, 8/_parent.worldScale),
					new B2Vec2(5/_parent.worldScale, 12/_parent.worldScale), new B2Vec2(-5/_parent.worldScale, 12/_parent.worldScale)];


		polygonBody.setAsArray(bodyCoord, bodyCoord.length);
		polygonFootsSensor.setAsArray(footSensorCoord, footSensorCoord.length);

		body = _parent.world.createBody (bodyDef);
		fixtureBody.shape = polygonBody;
		fixtureBody.userData = "Body";
		fixtureFootsSensor.shape = polygonFootsSensor;
		fixtureFootsSensor.isSensor = true;
		fixtureFootsSensor.userData = "footSensor";
		body.createFixture(fixtureBody);
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
		{
			goLeft = false;
		}

		if (e.keyCode  == 39)
		{
			goRight = false;
		}

		if (e.keyCode == 38)
		{
			goJump = false;
		}

	}

	override public function childSpecificUpdate()
	{	
		playerOutOffScreen();

		if (_myScene.getCurrentPlayer() == this)
		{
			if (!endShooting)
			{
				if (goLeft || goRight || goJump || !canJump)
					isMooving = true;
				else 
					isMooving = false;

				if (isMooving)
					displayWeapon("hide");
				else
					displayWeapon("show");

				if (_haveWeapon)
					_weapon.update(body);

				if (_myScene.bulletOnScene() || isMooving || !canJump || _weapon == null)
					canShoot = false;
				else
					canShoot = true;
			}
			else
			{
				canShoot = false;
			}

			updateAI();
			playerMoving();

		}

	}

	private function updateAI()
	{
		if (_myScene.getCurrentPlayer() == this && _entityType != "Player")
		{
			var timerCount = _myScene.getGameTurnControl().getTimerCount();
			//var turnTime = _myScene.getGameTurnControl().getTurnTime();

			if (timerCount >= 2 && _enemy == null)
			{
				getClosestPlayer();
			}

			if (timerCount >= 5 && !_isEndAiming)
			{
				getDirection();
				aimToEnemy();
				_isEndAiming = true;

			}
			if ( timerCount >= 7 && canShoot)
				shootAI();

		}
	}

	private function updateWeaponRotation(e:MouseEvent)
	{
		if (_haveWeapon)
		{
			var dist_x = _weapon.getBody().getPosition().x - _parent.getUI().mouseX;
			var dist_y = _weapon.getBody().getPosition().y - _parent.getUI().mouseY;
			_weapon.getBody().setAngle(Math.atan2(- dist_y,- dist_x));
		}
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
        _nameTextField.x = -30;
        _nameTextField.y = -45;
        _nameTextField.width = 100;
        _nameTextField.height = 25;
        _nameTextField.text = textName;
        _name = textName;

	}

	private function createHp()
	{
		_hpTextField = new TextField();
        _hpTextField.x = -10;
        _hpTextField.y = -35;
        _hpTextField.width = 25;
        _hpTextField.height = 25;
        var hp = Std.string(_hp);
        _hpTextField.text = hp;
	}

	private function updateHp()
	{
		var hp = Std.string(_hp);
		_hpTextField.text = hp;
	}

	private function createRandomName()
	{
		var names:Array<String> = new Array();
		names = ["Bob Greender", "Dylan Backstreet", "Rolf Cannigan", "Carl Wolf", "Duck Haskee", "Gorsen Freemon", "Hubort Konter", "lol :D"];
		var index = Math.floor(Math.random() * names.length);
		return names[index];
	}

	private function addInputListener()
	{
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, updateWeaponRotation);
		Lib.current.stage.addEventListener(MouseEvent.CLICK, shoot);
	}

	private function removeInputListener()
	{
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpListener);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_MOVE, updateWeaponRotation);
		Lib.current.stage.removeEventListener(MouseEvent.CLICK, shoot);
	}


	private function getClosestPlayer()
	{
		var playerList = _parent.getListOfPlayers();

		var myPos = body.getPosition();
		var positionArray = new Array();
		var selfIndex = 0;
		for (i in 0...playerList.length)
		{
			if (playerList[i] != this)
			{
				var position = playerList[i].getBody().getPosition();
				positionArray.push(position);
			}
			else
				selfIndex = i;
			
		}

		var distArray = new Array();

		for (j in 0...positionArray.length)
		{
			var distanceX = Math.abs(positionArray[j].x - myPos.x);
			var distanceY = Math.abs(positionArray[j].y - myPos.y);
			var distance = Math.sqrt(distanceX*distanceX + distanceY*distanceY);
			distance = Math.round(distance);
			distArray.push(distance);
		}

		var unsortedDistArray = distArray.concat(new Array());

		distArray.sort(function(a, b)
			{
				if (a < b)
					return -1;
				else if (a > b)
					return 1;
				else 
					return 0;
			});
		var closest = distArray[0];

		var index = unsortedDistArray.indexOf(closest);

		if (index >= selfIndex)
			index += 1;

		_enemy = playerList[index];
		trace(this._name + ", have enemy =" + _enemy.getName() );


	}

	private function getDirection()
	{
		var enemyPos = _enemy.getBody().getPosition();
		var selfPos = body.getPosition();

		var difX = selfPos.x - enemyPos.x;
		var difY = selfPos.y - enemyPos.y;

		var directionX = "center";
		var directionY = "center";

		if (difX > 0)
			directionX = "left";
		else if(difX < 0)
			directionX = "right";
		else
			directionX = "center";

		if (difY < 0)
			directionY = "down";
		else if(difX > 0)
			directionY = "up";
		else
			directionY = "center";

		_aimDirection = [directionX, directionY];

		trace(this._name + " direction to enemy on X =" + directionX);
	}

	private function aimToEnemy()
	{

		var selfPos = body.getPosition();
		var enemyPos = _enemy.getBody().getPosition();

		var difX = Math.abs(selfPos.x - enemyPos.x);
		var difY = Math.abs(selfPos.y - enemyPos.y);
		var dif = Math.sqrt(difX*difX + difY*difY);

		var sinAlpha = difY/dif;
		var arcSinAlpha = Math.asin(sinAlpha);
		var alpha = arcSinAlpha*(180/Math.PI);

		var weaponBody = _weapon.getBody();

		var angle:Float = getAimAngle();
		weaponBody.setAngle(angle);
	}

	private function getAimAngle():Float
	{
		var directionX = _aimDirection[0];
		var directionY = _aimDirection[1];

		if (directionX == "left")
		{
			var result = 180*(Math.PI/180);
			return result;
		}
		else 
		{
			var result2 = 0*(Math.PI/180);
			return result2;
		}

	}

	private function forciblyKeyUp()
	{
		goLeft = false;
		goRight = false;
		goJump = false;
		canShoot = false;

	}

	private function shoot(e:Event)
	{
		if (canShoot)
		{
			var weaponBullet = _myScene.createWeaponBullet();
			var coord = new B2Vec2(Math.cos(_weapon.getBody().getAngle())*20, Math.sin(_weapon.getBody().getAngle())*20);
			var bulletBody = weaponBullet.getBody();
			bulletBody.applyImpulse(coord, _weapon.getBody().getWorldCenter());
			var weaponAmmo = _weapon.ammo;
			weaponAmmo--;
			if (weaponAmmo <= 0)
			{
				endShooting = true;
				displayWeapon("hide");
				canShoot = false;
			}
		}
		
	}

	private function shootAI()
	{
		if (canShoot)
		{
			var weaponBullet = _myScene.createWeaponBullet();
			var coord = new B2Vec2(Math.cos(_weapon.getBody().getAngle())*20, Math.sin(_weapon.getBody().getAngle())*20);
			var bulletBody = weaponBullet.getBody();
			bulletBody.applyImpulse(coord, _weapon.getBody().getWorldCenter());
			var weaponAmmo = _weapon.ammo;
			weaponAmmo--;
			if (weaponAmmo <= 0)
			{
				endShooting = true;
				displayWeapon("hide");
				canShoot = false;
			}

		}
	}

	public function getWeapon()
	{
		return _weapon;
	}

	public function setWeapon(weapon)
	{
		if (_haveWeapon)
			destroyWeapon();

		_weapon = weapon;
		var weaponSprite = _weapon.getSprite();
		_parent.addChild(weaponSprite);
		_haveWeapon = true;
	}

	private function displayWeapon(x)
	{
		if (x == "show")
		{
			if (!_isWeaponShowed)
			{
				var sprite = _weapon.getSprite();
				_parent.addChild(sprite);
				_isWeaponShowed = true;
			}
		}
		else if (x == "hide")
		{
			if(_isWeaponShowed)
			{
				var sprite = _weapon.getSprite();
				_parent.removeChild(sprite);
				_isWeaponShowed = false;
			}
		}
	}

	public function destroyWeapon()
	{
		if (_haveWeapon == true)
		{
			var weaponSprite = _weapon.getSprite();
			var weaponBody = _weapon.getBody();

			_parent.removeChild(weaponSprite);
			_parent.world.destroyBody(weaponBody);

			_weapon = null;
			_haveWeapon = false;
		}
	}

	public function hitByBullet(dmg)
	{
		var damage = dmg;
		_hp -= damage;
		if (_hp <= 0)
		{
			//death
		}
		else
			updateHp();
	}

	private function giveControlToPlayer()
	{
		addInputListener();
		endShooting = false;
	}

	private function withdrawControlFromPlayer()
	{
		forciblyKeyUp();
		removeInputListener();
	}

	public function startTurn()
	{
		_isEndAiming = false;
		canShoot = true;
		endShooting = false;
		_enemy = null;
		if (_weapon == null)
			createWeapon("default");
		else
			displayWeapon("show");

		if (_parent.getCurrentPlayer().getEntityType() == "Player")
			giveControlToPlayer();
	}

	public function endTurn()
	{
		displayWeapon("hide");
		withdrawControlFromPlayer();

	}

	private function createWeapon(weaponType)
	{
		var weapon = new Weapon(_parent, weaponType);
		setWeapon(weapon);
	}

	public function getName():String
	{
		return _name;
	}
}