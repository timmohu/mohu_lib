package mohu.components.messages {
	import mohu.messages.Message;

	/**
	 * @author Arthur Comben
	 */
	public class NumberMessage extends Message {

		private var _number:Number;
		public function NumberMessage( number:Number ) {
			_number = number;
			super();
		}

		
		
		override public function clone():Message {
			return new NumberMessage(_number);
		}

		
		
		public function get number():Number {
			return _number;
		}
	}
}
