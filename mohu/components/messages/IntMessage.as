package mohu.components.messages {
	import mohu.messages.Message;

	/**
	 * @author Arthur Comben
	 */
	public class IntMessage extends Message {

		private var _value:int;

		public function IntMessage( value:int ) {
			_value = value;
			super();
		}

		
		
		override public function clone():Message {
			return new IntMessage(value);
		}

		
		
		public function get value():int {
			return _value;
		}

		
		
		public function set value(value:int):void {
			_value = value;
		}
	}
}
