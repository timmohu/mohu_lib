package mohu.modules.deeplink.messages {
	import mohu.messages.Message;

	/**
	 * @author Tim Kendrick
	 */
	public class DeepLinkMessage extends Message {

		public var path:String;

		public function DeepLinkMessage(path:String) {
			this.path = path;
		}

		override public function clone():Message {
			return new DeepLinkMessage(path);
		}
	}
}
