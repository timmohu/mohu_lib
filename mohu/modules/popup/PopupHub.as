package mohu.modules.popup {
	import mohu.messages.Dispatcher;
	import mohu.mvcs.Hub;

	/**
	 * @author Tim Kendrick
	 */
	public class PopupHub extends Hub {

		private var _showPopup:Dispatcher;
		private var _hidePopup:Dispatcher;
		private var _addPopup:Dispatcher;
		private var _removePopup:Dispatcher;

		public function PopupHub() {
			_showPopup = new Dispatcher(this);
			_hidePopup = new Dispatcher(this);
			_addPopup = new Dispatcher(this);
			_removePopup = new Dispatcher(this);
		}

		public function get showPopup():Dispatcher {
			return _showPopup;
		}

		public function get hidePopup():Dispatcher {
			return _hidePopup;
		}

		public function get addPopup():Dispatcher {
			return _addPopup;
		}

		public function get removePopup():Dispatcher {
			return _removePopup;
		}
	}
}
