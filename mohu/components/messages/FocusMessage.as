package mohu.components.messages {
	import mohu.messages.Message;

	import flash.display.InteractiveObject;

	/**
	 * @author Tim Kendrick
	 */
	public class FocusMessage extends Message {

		public var relatedObject:InteractiveObject;
		public var shiftKey:Boolean;
		public var keyCode:uint;

		public function FocusMessage( relatedObject:InteractiveObject = null, shiftKey:Boolean = false, keyCode:uint = 0) {
			this.keyCode = keyCode;
			this.shiftKey = shiftKey;
			this.relatedObject = relatedObject;
		}

		override public function clone():Message {
			return new FocusMessage(relatedObject, shiftKey, keyCode);
		}
	}
}
