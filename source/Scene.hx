package;

import flash.display.Sprite;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;
import flash.events.EventDispatcher;
import flash.geom.Point;
import flash.geom.Rectangle;

import box2D.dynamics.B2World;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2DebugDraw;

class Scene extends Sprite
{
	public var myGame:Game;
	public var world:B2World;
	public var worldScale:Int = 30; // pixel to metr;

	private var worldGravity:B2Vec2;
	private var worldStep:Float = 1/30;
	private var velocityIterations:Int = 10;
	private var positionIterations:Int = 10;
	private var sceneContactListener:ContactListener;
	private var _timeMaster:TimeMaster;
	private var _allPlayersOnScene:Array<Dynamic> = new Array();
	private var _playersToRemove:Array<Dynamic> = new Array();
	private var myGameTurnControl:GameTurnControl;
	private var _userInterface:UserInterface;
	private var _curPlayer:ScenePlayerActor;
	private var _collisionCategories = new Array();
	private var _weaponBullet:WeaponBullet;
	private var _destroyBullet:Bool = false;

	public var maxSceneWidth:Int = 2048;
	public var maxSceneHeight:Int = 1280;

	private var _allActors:Array<Dynamic> = new Array();

	public function new(game)
	{
		super();
		myGame = game;
		initilize();
	}

	private function initilize()
	{
		createTimeMaster();
		createWorld();
		createContactListener();
		createUserInterface();
		createCollisionCategories();

		addDebuger();

	}

	private function createGameTurnControl(timePerEachPlayerTurn)
	{
		myGameTurnControl = new GameTurnControl(this, timePerEachPlayerTurn);
	}

	private function createCollisionCategories()
	{
		_collisionCategories.push(0x0001);
		_collisionCategories.push(0x0002);
		_collisionCategories.push(0x0004);
		_collisionCategories.push(0x0008);
	}

	private function createUserInterface()
	{
		_userInterface = new UserInterface(this);
		addChild(_userInterface);
	}

	private function createTimeMaster()
	{
		_timeMaster = new TimeMaster(this, worldStep);
	}

	private function createWorld()
	{
		worldGravity = new B2Vec2(0, 9.8); //x=0, y=G == 9.8;
		var isSleep:Bool = true;
		world = new B2World(worldGravity, isSleep);
	}

	private function createContactListener()
	{
		sceneContactListener = new ContactListener(this);
		world.setContactListener(sceneContactListener);
	}

	private function update(event:Event)
	{
		var step = _timeMaster.getTimeStep();
		world.step(step, velocityIterations, positionIterations);
		world.clearForces();
		world.drawDebugData();

		for(i in 0..._allActors.length)
		{
			_allActors[i].update();
		}

		cameraControl();

		myGameTurnControl.update();
		_userInterface.update();
		if (_weaponBullet != null)
			_weaponBullet.update();

		removePlayersFromScene();
		
	}

	private function addDebuger()
	{
		var debugDraw = new B2DebugDraw();
		var debugSprite = new Sprite();
		addChild(debugSprite);
		
		debugDraw.setSprite(debugSprite);
		debugDraw.setDrawScale(worldScale);
		debugDraw.setFlags(B2DebugDraw.e_shapeBit);
		
		world.setDebugDraw(debugDraw);
	}

	private function createActors()
	{
		
		var playerPos = new B2Vec2(100, 650);
		createPlayerActor(playerPos, 3, 100);

		var enemyPos = new B2Vec2(300, 650);
		createBotActor(enemyPos, 3, 100);

		var enemypos2 = new B2Vec2(500, 650);
		createBotActor(enemypos2, 3, 100);

		var enemyPos3 = new B2Vec2(700, 650);
		createBotActor(enemyPos3, 3, 100);
	}

	private function createGround(width:Int, height:Int, pos:B2Vec2, figures:Int)
	{
		var width = width/2;
		var height = height/2;
		var loc = new B2Vec2(pos.x/2/worldScale, pos.y/worldScale);

		var categoryBits = getCollisionCategory("ground");
		var maskBits = -1;

		var newGroundActor = new SceneGroundActor(this, width, height, loc, figures, true, categoryBits, maskBits);

		_allActors.push(newGroundActor);
	}

	private function createPlayerActor(pos:B2Vec2, velocityX:Int, velocityY:Int)
	{
		var loc = new B2Vec2(pos.x/worldScale, pos.y/worldScale);
		var eType = "Player";
		var name = "I'm a player";
		var categoryBits = getCollisionCategory("player");
		var mask2 = getCollisionCategory("ground");
		var mask1 = getCollisionCategory("bullet");
		var maskBits = mask1 | mask2;
		var player = new ScenePlayerActor(this, loc, velocityX, velocityY, eType, name, categoryBits, maskBits);
		_allActors.push(player);
	}

	private function createBotActor(pos:B2Vec2, velocityX:Int, velocityY:Int)
	{
		var loc = new B2Vec2(pos.x/worldScale, pos.y/worldScale);
		var eType = "Bot";
		var name = "Random";
		var categoryBits = getCollisionCategory("player");
		var mask2 = getCollisionCategory("ground");
		var mask1 = getCollisionCategory("bullet");
		var maskBits = mask1 | mask2;
		var newEnemy = new ScenePlayerActor(this, loc, velocityX, velocityY, eType, name, categoryBits, maskBits);
		_allActors.push(newEnemy);
	}

	private function sceneFollowPlayer()
	{
 		root.scaleX = 2;
 		root.scaleY = 2;
 		this.x = -_curPlayer.getSprite().x + stage.stageWidth/4;
 		this.y = -_curPlayer.getSprite().y + stage.stageHeight/4;
	}

	private function scneeFollowBullet()
	{
		root.scaleX = 2;
 		root.scaleY = 2;
 		this.x = -_weaponBullet.getSprite().x + stage.stageWidth/4;
 		this.y = -_weaponBullet.getSprite().y + stage.stageHeight/4;
	}

	private function createLevel()
	{	
		var groundPos = new B2Vec2(1920, 700);
		createGround(1920, 20, groundPos, 10);

	//	createWalls();
	}

	private function cameraControl()
	{
		if (_weaponBullet == null)
			sceneFollowPlayer();
		else
			scneeFollowBullet();
	}

	private function doPlayerTurnQue()
	{
		for (i in 0..._allActors.length)
		{
			var player = _allActors[i];
			if (player.getEntityType() == "Player" || player.getEntityType() == "Bot")
				_allPlayersOnScene.push(player);
		}

		_allPlayersOnScene.sort(function(x,y){ return Math.round(Math.random()); });
		_curPlayer = _allPlayersOnScene[0];
		//round start

	}

	private function teamPlayerTurnQue()
	{
		//TODO: turn players in team mode, 1 member per team, then next member per team, for the last member - round end;
	}

	
	private function startTimer()
	{
		myGameTurnControl.startTimer();
	}

	public function markToRemovePlayer(playerActor:ScenePlayerActor)
	{
		if( _playersToRemove.indexOf(playerActor) < 0 )
			_playersToRemove.push(playerActor);
	}

	public function removePlayersFromScene()
	{
		for (i in 0..._playersToRemove.length){
			_playersToRemove[i].destroy();
			var index =_playersToRemove.indexOf(_playersToRemove[i]);
			if (index > -1){
				_playersToRemove.splice(index, 1);
			}
		}
		_playersToRemove = new Array();

		if (_destroyBullet)
		{
			_weaponBullet.totallyDestroy();
			_destroyBullet = false;
			_weaponBullet = null;
		}
	}

	public function getUI()
	{
		return _userInterface;
	}

	public function start()
	{
		addEventListener(Event.ENTER_FRAME, update);
		//TODO: helloScreen -> menuScreen -> customWormScreen -> warScreen ( matchScreen )

		//now, just start MatchScreen while other not ready;
		startMatch();
	}

	public function stop():Void
	{
		removeEventListener(Event.ENTER_FRAME, update);
	}

	private function getCollisionCategory(category)
	{
		
		if (category == "player")
			return _collisionCategories[0];

		else if (category == "bullet")
			return _collisionCategories[1];

		else if (category == "weapon")
			return _collisionCategories[2];

		else if (category == "ground")
			return _collisionCategories[3];

		else
			return -1;
		
	}

	public function getCurrentPlayer()
	{
		return _curPlayer;
	}

	public function createWeaponBullet()
	{
		var categoryBits = getCollisionCategory("bullet");
		var mask1 = getCollisionCategory("ground");
		var mask2 = getCollisionCategory("player");
		var maskBits = mask1 | mask2;
		var damage = getCurrentPlayer().getWeapon().damage;
		_weaponBullet = new WeaponBullet(this, categoryBits, maskBits, damage);
		return _weaponBullet;
	}

	public function markToDestroyBullet()
	{
		_destroyBullet = true;
	}

	public function bulletOnScene()
	{
		if (_weaponBullet != null)
			return true;
		else
			return false;
	}

	public function startMatch()
	{
		//create maplevel;
		createLevel();

		//create Players ( roaches ) with bots;
		createActors(); // feature: ( players, bots )

		// create Turn Master, who can control players with them turn;
		var timePerEachPlayerTurn = 10;
		createGameTurnControl(timePerEachPlayerTurn);

		// sort player in que, who started match first ( now without teams, just deathmatch)
		doPlayerTurnQue();

		//TODO: so much work... :(

		//when all done, start round;
		myGameTurnControl.turnStart();
	}

	private function roundEnd()
	{
		//TODO: say to all player, that round ended, do some cleaning;
	}

	public function setCurrentPlayer(player)
	{
		_curPlayer = player;
	}

	public function getListOfPlayers()
	{
		return _allPlayersOnScene;
	}

	public function getGameTurnControl()
	{
		return myGameTurnControl;
	}


}