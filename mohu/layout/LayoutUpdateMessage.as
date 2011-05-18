package mohu.layout {
	import mohu.messages.Message;

	/**
	 * @author Arthur Comben
	 */
	public class LayoutUpdateMessage extends Message {

		private var _forceUpdate:Boolean;

		public function LayoutUpdateMessage( forceUpdate:Boolean ) {
			super();
			_forceUpdate = forceUpdate;
		}

		
		
		override public function clone():Message {
			return new LayoutUpdateMessage(_forceUpdate);
		}

		
		
		public function get forceUpdate():Boolean {
			return _forceUpdate;
		}
	}
}
