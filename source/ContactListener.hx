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

	}

	override public function endContact(contact:B2Contact)
	{

		var bodyUserDataA = contact.getFixtureA().getBody().getUserData();
		var bodyUserDataB = contact.getFixtureB().getBody().getUserData();
	}
	
}