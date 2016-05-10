package;


import flash.events.EventDispatcher;
import flash.display.DisplayObject;


class SceneActor extends Scene{
	

	
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