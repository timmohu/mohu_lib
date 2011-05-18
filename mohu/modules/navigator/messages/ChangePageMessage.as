package mohu.modules.navigator.messages {
	import mohu.messages.Message;

	/**
	 * @author Tim Kendrick
	 */
	public class ChangePageMessage extends Message {

		public var oldPath:String;
		public var newPath:String;

		public function ChangePageMessage(newPath:String, oldPath:String = null) {
			this.newPath = newPath;
			this.oldPath = oldPath;
		}

		override public function clone():Message {
			return new ChangePageMessage(newPath, oldPath);
		}
	}
}
