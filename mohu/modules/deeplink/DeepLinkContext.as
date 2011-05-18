package mohu.modules.deeplink {
	import mohu.modules.deeplink.model.DeepLinkModel;
	import mohu.mvcs.Context;

	/**
	 * @author Tim Kendrick
	 */
	public class DeepLinkContext extends Context {

		private var _model:DeepLinkModel;

		public function DeepLinkContext(pathPrefix:String = "", updateDelay:int = 100) {
			super(new DeepLinkHub());
			
			_initModel(pathPrefix, updateDelay);
			_initView();
			_initController();
			_initServices();
		}

		private function _initModel(pathPrefix:String = "", updateDelay:int = 100):void {
			var hub:DeepLinkHub = this.hub as DeepLinkHub;
			_model = new DeepLinkModel(pathPrefix, updateDelay);
			_model.onPathChanged.addListener(hub.onPathChanged.dispatch);
		}

		private function _initView():void {
		}

		private function _initController():void {
		}

		private function _initServices():void {
		}

		public function get currentPath():String {
			return _model.currentPath;
		}

		public function set currentPath(value:String):void {
			_model.currentPath = value;
		}
	}
}
