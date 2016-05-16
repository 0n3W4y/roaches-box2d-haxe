package;

import flash.events.Event;

class EnemyEvent extends Event{

	public static var ENEMY_OFF_SCREEN:String = "EnemyOfScreen";


	public function new(type:String, bubbles:Bool = false, cancelable:Bool = false){
		super(type, bubbles, cancelable);
	}

	public override function clone(){
		return new EnemyEvent(type, bubbles, cancelable);
	}

	public override function toString(){
		return formatToString("EnemyEvent", "type", "bubbles", "cancelable", "eventPhase");
	}

}