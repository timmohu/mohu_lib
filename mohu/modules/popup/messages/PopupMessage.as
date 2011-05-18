package mohu.modules.popup.messages {
	import mohu.messages.Message;
	import mohu.modules.popup.view.PopupViewComponent;

	/**
	 * @author Tim Kendrick
	 */
	public class PopupMessage extends Message {

		public var popup:PopupViewComponent;

		public function PopupMessage(popup:PopupViewComponent) {
			this.popup = popup;
		}

		override public function clone():Message {
			return new PopupMessage(popup);
		}
	}
}
