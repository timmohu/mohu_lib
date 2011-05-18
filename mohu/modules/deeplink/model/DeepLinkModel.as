package mohu.modules.deeplink.model {
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;
	import mohu.modules.deeplink.messages.DeepLinkMessage;
	import mohu.mvcs.model.Model;

	/**
	 * @author Tim Kendrick
	 */
	public class DeepLinkModel extends Model {

		private var _deepLinker:DeepLinker;
		private var _currentPath:String;

		private var _onPathChanged:Dispatcher;

		public function DeepLinkModel(pathPrefix:String = "", updateDelay:int = 100):void {
			_onPathChanged = new Dispatcher(this);
			
			if (_deepLinker) {
				_deepLinker.onChanged.removeListener(_handleDeepLinkChanged);
				_deepLinker.destroy();
			}
			try {
				_deepLinker = new DeepLinker(pathPrefix, updateDelay);
				_deepLinker.onChanged.addListener(_handleDeepLinkChanged);
				_currentPath = _deepLinker.currentPath;
			} catch (error:Error) {				
				trace("Deep link error: " + error.message);
			}
		}

		public function replacePath(path:String):void {
			_currentPath = path;
			if (_deepLinker) _deepLinker.replace(path);
		}

		private function _handleDeepLinkChanged(message:Message):void {
			_currentPath = _deepLinker.currentPath;
			_onPathChanged.dispatch(new DeepLinkMessage(_currentPath));
		}

		public function get currentPath():String {
			return _currentPath;
		}

		public function set currentPath(value:String):void {
			if (_currentPath == value) return;
			_currentPath = value;
			if (_deepLinker) _deepLinker.go(value);
		}

		public function get onPathChanged():Dispatcher {
			return _onPathChanged;
		}
	}
}
