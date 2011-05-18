package mohu.modules.navigator.view {
	import mohu.modules.navigator.messages.ChangePageMessage;
	import mohu.modules.navigator.model.NavigatorModel;
	import mohu.modules.navigator.view.page.Page;
	import mohu.modules.navigator.view.page.PageTransitionMessage;
	import mohu.mvcs.view.Mediator;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Tim Kendrick
	 */
	public class NavigatorMediator extends Mediator {

		private var _model:NavigatorModel;

		private var _targetPath:String;
		private var _activePath:String;
		private var _activePage:Page;
		private var _queue:Array;
		private var _loading:Boolean;

		public function NavigatorMediator() {
			super();	
		}

		public function showPath(path:String):void {
			_queue.push(path);
			if (!_loading) _showNextPath();
		}

		private function _handleRootPageShown(message:PageTransitionMessage):void {
			_loading = false;
			updateActivePage();
		}

		private function _handlePageChanged(message:ChangePageMessage):void {
			this.showPath(message.newPath);
		}

		private function _showNextPath():void {
			_targetPath = _queue.shift();
			updateActivePage();
		}

		protected function updateActivePage():void {
			if (_activePath == _targetPath) {
				if (_queue.length > 0) _showNextPath();
				return;
			}
			var activeHierarchy:Array = _activePath.split(_model.pathLevelSeparator);
			var targetHierarchy:Array = (_targetPath ? _targetPath.split(_model.pathLevelSeparator) : [""]);
			var depth:int = 0;
			while (activeHierarchy[depth] == targetHierarchy[depth]) depth++;
			if (!targetHierarchy[depth] || (activeHierarchy.length > depth + 1)) {
				_activePath = (activeHierarchy.slice(0, -1)).join(_model.pathLevelSeparator);
				hidePage();
			} else {
				_activePath = (targetHierarchy.slice(0, depth + 1)).join(_model.pathLevelSeparator);
				showPage(_model.getPage(_activePath), activeHierarchy[depth] != null);
			}
		}

		private function showPage(page:Page, replaceActivePage:Boolean):void {
			_loading = true;
			var parentPage:Page = (replaceActivePage ? _activePage.parentPage : _activePage as Page);
			page.onShow.addListener(onCompleteShowPage, true);
			parentPage.showChildPage(page);

			function onCompleteShowPage(message:PageTransitionMessage):void {
				_activePage = page;
				_loading = false;
				updateActivePage();
			}
		}

		private function hidePage():void {
			_loading = true;
			var parentPage:Page = _activePage.parentPage;
			_activePage.onHide.addListener(onCompleteHidePage, true);
			parentPage.hideChildPage();

			function onCompleteHidePage(message:PageTransitionMessage):void {
				_activePage = parentPage;
				_loading = false;
				updateActivePage();
			}
		}

		public function get activePath():String {
			return _activePath;
		}

		public function get activePage():Page {
			return _activePage;
		}

		public function get model():NavigatorModel {
			return _model;
		}

		public function set model(value:NavigatorModel):void {
			if (_model) _model.onPageChanged.removeListener(_handlePageChanged);
			
			_model = value;

			_activePath = "";
			_targetPath = "";
			_activePage = _model.getPage("");
			_queue = [];

			_model.onPageChanged.addListener(_handlePageChanged);

			(viewComponent as DisplayObjectContainer).addChild(_activePage.viewComponent);

			_activePage.onShow.addListener(_handleRootPageShown, true);
			_loading = true;
			_activePage.show(null, null, false);

			if (model.currentPath) showPath(model.currentPath);
		}
	}
}
