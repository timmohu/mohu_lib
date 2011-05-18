package mohu.modules.popup.view {
	import mohu.messages.Dispatcher;

	import flash.display.Sprite;

	/**
	 * @author Tim Kendrick
	 */
	public class PopupViewComponent extends Sprite {

		private var _onClose:Dispatcher;

		public function PopupViewComponent() {
			_onClose = new Dispatcher(this);
		}

		public function get onClose():Dispatcher {
			return _onClose;
		}
	}
}
