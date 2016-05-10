package;


import flash.events.EventDispatcher;
import flash.display.DisplayObject;


class SceneActor extends EventDispatcher{
	

	
	public function new()
	{

		super();
	}

	public function update()
	{
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

}