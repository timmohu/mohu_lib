package mohu.modules.deeplink {
	import mohu.messages.Dispatcher;
	import mohu.mvcs.Hub;

	/**
	 * @author Tim Kendrick
	 */
	public class DeepLinkHub extends Hub {

		private var _onPathChanged:Dispatcher;

		public function DeepLinkHub() {
			_onPathChanged = new Dispatcher(this);
		}

		public function get onPathChanged():Dispatcher {
			return _onPathChanged;
		}
	}
}
