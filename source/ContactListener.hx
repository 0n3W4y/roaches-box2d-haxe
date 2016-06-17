package;

import box2D.collision.B2ContactPoint;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2ContactListener;

class ContactListener extends B2ContactListener{

	private var _myScene:Scene;

	public function new(scene)
	{
		super();
		_myScene = scene;
		
	}

	override public function beginContact(contact:B2Contact)
	{
		var bodyUserDataA = contact.getFixtureA().getBody().getUserData();
		var bodyUserDataB = contact.getFixtureB().getBody().getUserData();
		var fixtureA = contact.getFixtureA();
		var fixtureB = contact.getFixtureB();

		if (Std.is(bodyUserDataA, ScenePlayerActor) && Std.is(bodyUserDataB, SceneGroundActor) && fixtureA.getUserData() == "footSensor")
		{
			bodyUserDataA.canJump = true;
		}

		if (Std.is(bodyUserDataB, ScenePlayerActor) && Std.is(bodyUserDataA, SceneGroundActor) && fixtureB.getUserData() == "footSensor")
		{
			bodyUserDataB.canJump = true;
		}

		if (bodyUserDataA != null)
		{
			//bodyUserDataA.destroy();
			trace("contact from A reflected:" + fixtureA.getUserData());
		}

		if (bodyUserDataB != null)
		{
			//bodyUserDataB.destroy();
			trace("contact from B reflected:" + fixtureB.getUserData());
		}

	}

	override public function endContact(contact:B2Contact)
	{
		var bodyUserDataA = contact.getFixtureA().getBody().getUserData();
		var bodyUserDataB = contact.getFixtureB().getBody().getUserData();
		var fixtureA = contact.getFixtureA();
		var fixtureB = contact.getFixtureB();



	}
	
}