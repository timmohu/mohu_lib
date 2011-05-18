package mohu.modules.popup.model {
	import mohu.messages.Dispatcher;
	import mohu.modules.popup.messages.PopupMessage;
	import mohu.modules.popup.view.PopupViewComponent;
	import mohu.mvcs.model.Model;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Tim Kendrick
	 */
	public class PopupModel extends Model {

		public var container:DisplayObjectContainer;

		private var _currentPopup:PopupViewComponent;

		private var _onPopupAdded:Dispatcher;
		private var _onPopupRemoved:Dispatcher;

		public function PopupModel(container:DisplayObjectContainer) {
			_onPopupAdded = new Dispatcher(this);
			_onPopupRemoved = new Dispatcher(this);
			
			this.container = container;
		}

		
		public function get currentPopup():PopupViewComponent {
			return _currentPopup;
		}

		public function set currentPopup(value:PopupViewComponent):void {
			if (_currentPopup == value) return;
			if (_currentPopup) _onPopupRemoved.dispatch(new PopupMessage(_currentPopup));
			_currentPopup = value;
			if (_currentPopup) _onPopupAdded.dispatch(new PopupMessage(_currentPopup));
		}

		public function get onPopupAdded():Dispatcher {
			return _onPopupAdded;
		}

		public function get onPopupRemoved():Dispatcher {
			return _onPopupRemoved;
		}
	}
}
