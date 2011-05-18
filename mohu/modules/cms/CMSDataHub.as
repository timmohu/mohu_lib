package mohu.modules.cms {
	import mohu.messages.Dispatcher;
	import mohu.mvcs.Hub;

	/**
	 * @author Tim Kendrick
	 */
	public class CMSDataHub extends Hub {

		private var _loadData:Dispatcher;

		private var _onDataLoaded:Dispatcher;

		public function CMSDataHub() {
			_loadData = new Dispatcher(this);
			_onDataLoaded = new Dispatcher(this);
		}

		public function get loadData():Dispatcher {
			return _loadData;
		}

		public function get onDataLoaded():Dispatcher {
			return _onDataLoaded;
		}
	}
}
