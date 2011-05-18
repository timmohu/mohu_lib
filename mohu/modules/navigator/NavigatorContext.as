package mohu.modules.navigator {
	import mohu.modules.navigator.model.NavigatorModel;
	import mohu.modules.navigator.model.sitemap.PageNode;
	import mohu.modules.navigator.view.NavigatorMediator;
	import mohu.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Tim Kendrick
	 * 	
	 */
	public class NavigatorContext extends Context {

		private var _model:NavigatorModel;
		private var _mediator:NavigatorMediator;

		public function NavigatorContext(contextView:DisplayObjectContainer, pathLevelSeparator:String = "/", pathDataSeparator:String = ":") {
			super(new NavigatorHub(), contextView);
			
			_initModel(pathLevelSeparator, pathDataSeparator);
			_initView();
			_initController();
			_initServices();
		}

		private function _initModel(pathLevelSeparator:String = "/", pathDataSeparator:String = ":"):void {
			var hub:NavigatorHub = this.hub as NavigatorHub;
			_model = new NavigatorModel(pathLevelSeparator, pathDataSeparator);
			_model.onPageCreated.addListener(hub.onPageCreated.dispatch);
			_model.onPageChanged.addListener(hub.onPageChanged.dispatch);
			this.injector.mapClassInstance(NavigatorModel, _model);
		}

		private function _initView():void {
			_mediator = mediatorMap.createMediator(contextView, NavigatorMediator) as NavigatorMediator;
		}

		private function _initController():void {
		}

		private function _initServices():void {
		}

		public function startup(rootNode:PageNode, redirects:Object, initialPath:String):void {
			_model.init(rootNode, redirects, initialPath);
			_mediator.model = _model;
		}

		public function get currentPath():String {
			return _model.currentPath;
		}

		public function set currentPath(value:String):void {
			_model.currentPath = value;
		}
	}
}
