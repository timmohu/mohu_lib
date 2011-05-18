package mohu.modules.navigator.messages {
	import mohu.messages.Message;
	import mohu.modules.navigator.view.page.Page;

	/**
	 * @author Tim Kendrick
	 */
	public class CreatePageMessage extends Message {

		public var page:Page;
		public var data:*;

		public function CreatePageMessage(page:Page, data:*) {
			this.page = page;
			this.data = data;
		}

		override public function clone():Message {
			return new CreatePageMessage(page, data);
		}
	}
}
