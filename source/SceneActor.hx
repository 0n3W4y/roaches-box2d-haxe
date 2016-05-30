package;


import flash.events.EventDispatcher;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;

import box2D.dynamics.B2Body;


class SceneActor extends EventDispatcher{
	
	private var _body:B2Body;
	private var _sprite:Sprite;
	private var _myScene:Scene;
	private var _entityType:String;
	
	public function new(scene:Scene, body:B2Body, sprite:Sprite, eType:String)
	{
		
		_body = body;
		_sprite = sprite;

		_myScene = scene;
		_body.setUserData(this);
		_entityType = eType;

		updateSprite();
		super();
	}

	public function update()
	{
		if( _body.getType() != STATIC_BODY){
			updateSprite();
		}
		
		childSpecificUpdate();
	}

	public function destroy(){
		cleanUpBeforeRemoving();

		_sprite.parent.removeChild(_sprite);
		_myScene.world.destroyBody(_body);
	}

	private function cleanUpBeforeRemoving()
	{

	}

	private function childSpecificUpdate()
	{

	}

	private function updateSprite()
	{
		_sprite.x = _body.getPosition().x * _myScene.worldScale;
		_sprite.y = _body.getPosition().y * _myScene.worldScale;
		_sprite.rotation = _body.getAngle() * 180/Math.PI;
	}

	public function getSprite()
	{
		return _sprite;
	}

	public function getBody()
	{
		return _body;
	}

	public function getEntityType()
	{
		return _entityType;
	}
}