package mohu.components.messages {
	import mohu.messages.Message;

	/**
	 * @author Arthur Comben
	 */
	public class StringMessage extends Message {

		private var _value:String;

		public function StringMessage( value:String ) {
			_value = value;
			super();
		}

		
		
		override public function clone():Message {
			return new StringMessage(value);
		}

		
		
		public function get value():String {
			return _value;
		}

		
		
		public function set value(value:String):void {
			_value = value;
		}
	}
}
