package mohu.modules.cms.messages {
	import mohu.messages.Message;

	/**
	 * @author Tim Kendrick
	 */
	public class CMSDataLoadMessage extends Message {

		public var data:String;
		public var typeMap:Object;

		public function CMSDataLoadMessage(data:String, typeMap:Object) {
			this.data = data;
			this.typeMap = typeMap;
		}

		override public function clone():Message {
			return new CMSDataLoadMessage(data, typeMap);
		}
	}
}
