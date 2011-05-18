package mohu.core.display {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Tim Kendrick
	 */

	public class DisplayObjectInstantiator extends Sprite {

		private static const CREATION_POLICIES:Array = [CreationPolicy.IMMEDIATE,
			CreationPolicy.DEFERRED,
			CreationPolicy.ALWAYS];

		private var _creationPolicy:String;
		private var _instanceClass:Class;
		private var _instance:DisplayObject;

		public function DisplayObjectInstantiator( instanceClass:Class , creationPolicy:String = "DEFERRED" ) {
			super();
			_instanceClass = instanceClass;
			this.creationPolicy = creationPolicy;
		}

		
		
		private function addInstance():void {
			_instance = new _instanceClass();
			addChild(_instance);
		}

		
		
		private function removeInstance( ):void {
			if ( _instance.parent == this ) removeChild(_instance);
			_instance = null;
		}

		
		
		private function onAdded(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			addInstance();
		}

		
		
		private function onRemoved(event:Event):void {
			removeInstance();
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
		}

		
		
		public function get instanceClass():Class {
			return _instanceClass;
		}

		
		
		public function set instanceClass( value:Class ):void {
			_instanceClass = value;
			if ( _instance ) {
				removeInstance();
				addInstance();
			}
		}

		
		
		public function get creationPolicy():String {
			return _creationPolicy;
		}

		
		
		public function set creationPolicy( value:String):void {
			if (CREATION_POLICIES.indexOf(value) == -1) throw new ArgumentError("Invalid creation policy specified");

			_creationPolicy = value;

			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);

			switch ( value ) {
				case CreationPolicy.IMMEDIATE:
					if ( !_instance ) addInstance();
					break;
				case CreationPolicy.DEFERRED:
					if ( !_instance ) addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
					break;
				case CreationPolicy.ALWAYS:
					addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
					addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
					if ( _instance && !_instance.parent ) removeInstance(); 
					break;
			}
		}

		
		
		public function get instance():DisplayObject {
			return _instance;
		}
	}
}
