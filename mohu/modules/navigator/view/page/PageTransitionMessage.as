package mohu.modules.navigator.view.page {
	import mohu.messages.Message;

	/**
	 * @author Tim Kendrick
	 */
	public class PageTransitionMessage extends Message {

		public var oldPage:Page;
		public var newPage:Page;

		public function PageTransitionMessage(oldPage:Page, newPage:Page) {
			this.oldPage = oldPage;
			this.newPage = newPage;
		}

		override public function clone():Message {
			return new PageTransitionMessage(oldPage, newPage);
		}
	}
}
