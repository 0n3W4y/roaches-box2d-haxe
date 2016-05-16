package;

import flash.events.Event;

class PlayerEvent extends Event{

	public static var PLAYER_OFF_SCREEN:String = "PlayerOfScreen";


	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false){
		super(type, bubbles, cancelable);
	}

	public override function clone(){
		return new PlayerEvent(type, bubbles, cancelable);
	}

	public override function toString(){
		return formatToString("PlayerEvent", "type", "bubbles", "cancelable", "eventPhase");
	}

}