package mohu.modules.navigator {
	import mohu.messages.Dispatcher;
	import mohu.mvcs.Hub;

	/**
	 * @author Tim Kendrick
	 */
	public class NavigatorHub extends Hub {

		private var _onPageCreated:Dispatcher;
		private var _onPageChanged:Dispatcher;

		public function NavigatorHub() {
			_onPageCreated = new Dispatcher(this);
			_onPageChanged = new Dispatcher(this);
		}

		public function get onPageCreated():Dispatcher {
			return _onPageCreated;
		}

		public function get onPageChanged():Dispatcher {
			return _onPageChanged;
		}
	}
}
