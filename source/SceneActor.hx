package;


import flash.events.EventDispatcher;
import flash.display.DisplayObject;


class SceneActor extends Scene{
	
	private var _body:B2Body;
	private var _sprite:Sprite;
	
	public function new(body, sprite)
	{
		_body = body;
		_sprite = sprite;
		super();
	}

	public function update()
	{
		updateSprite();
		childSpecificUpdate();
	}

	public function destroy()
	{
		cleanUpBeforeRemoving();
	}

	private function cleanUpBeforeRemoving()
	{

	}

	private function childSpecificUpdate()
	{

	}

	private function updateSprite()
	{
		_sprite.x = _body.getPosition().x / worldScale;
		_sprite.y = _body.getPosition().y / worldScale;
	}

}