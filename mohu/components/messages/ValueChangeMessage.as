package mohu.components.messages {
	import mohu.messages.Message;

	/**
	 * @author Tim Kendrick
	 */
	public class ValueChangeMessage extends Message {

		public var oldValue:Number;
		public var newValue:Number;

		public function ValueChangeMessage( oldValue:Number , newValue:Number ) {
			this.oldValue = oldValue;
			this.newValue = newValue;

			super();
		}

		
		
		override public function clone():Message {
			return new ValueChangeMessage(oldValue, newValue);
		}
	}
}
