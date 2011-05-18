package mohu.components.messages {
	import mohu.messages.Message;

	import flash.display.InteractiveObject;

	/**
	 * @author Tim Kendrick
	 */
	public class MouseMessage extends Message {

		public var relatedObject:InteractiveObject;
		public var ctrlKey:Boolean;
		public var altKey:Boolean;
		public var shiftKey:Boolean;
		public var buttonDown:Boolean;

		public function MouseMessage( relatedObject:InteractiveObject = null , ctrlKey:Boolean = false , altKey:Boolean = false , shiftKey:Boolean = false , buttonDown:Boolean = false ) {
			super();

			this.relatedObject = relatedObject;
			this.ctrlKey = ctrlKey;
			this.altKey = altKey;
			this.shiftKey = shiftKey;
			this.buttonDown = buttonDown;
		}

		
		
		override public function clone():Message {
			return new MouseMessage(relatedObject, ctrlKey, altKey, shiftKey, buttonDown);
		}
	}
}
