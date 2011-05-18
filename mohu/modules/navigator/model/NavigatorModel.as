package mohu.modules.navigator.model {
	import mohu.messages.Dispatcher;
	import mohu.modules.navigator.messages.ChangePageMessage;
	import mohu.modules.navigator.messages.CreatePageMessage;
	import mohu.modules.navigator.model.sitemap.PageNode;
	import mohu.modules.navigator.view.page.Page;
	import mohu.mvcs.model.Model;

	/**
	 * @author Tim Kendrick
	 */
	public class NavigatorModel extends Model {

		private static const REGEXP_METACHARACTERS:RegExp = /([^$\.*+?()[\]{}|])/g;

		public var rootNode:PageNode;
		public var redirects:Object;
		public var pathLevelSeparator:String;
		public var pathDataSeparator:String;

		private var _currentPath:String;

		private var _onPageChanged:Dispatcher;
		private var _onPageCreated:Dispatcher;

		public function NavigatorModel(pathLevelSeparator:String = "/", pathDataSeparator:String = ":") {
			_onPageChanged = new Dispatcher(this);
			_onPageCreated = new Dispatcher(this);
			
			super();
			
			this.pathLevelSeparator = pathLevelSeparator;
			this.pathDataSeparator = pathDataSeparator;
		}

		public function init(rootNode:PageNode, redirects:Object = null, initialPath:String = ""):NavigatorModel {
			this.rootNode = rootNode;
			this.redirects = redirects;

			_currentPath = getValidPath(initialPath);

			return this;
		}

		public function getPage(path:String):Page {
			var pageNode:PageNode = rootNode.getPath(getPathHierarchy(path, pathLevelSeparator, pathDataSeparator)) as PageNode;
			var page:Page = new Page(new pageNode.viewComponent(), pageNode.title, pageNode.transitions, pageNode.childTransitionSequence);
			var data:String = (path.lastIndexOf(pathDataSeparator) > path.lastIndexOf(pathLevelSeparator) ? path.substr(path.indexOf(pathDataSeparator) + pathDataSeparator.length) : pageNode.data);
			_onPageCreated.dispatch(new CreatePageMessage(page, data));
			return page;
		}

		public function getValidPath(path:String):String {
			if (path == null) path = "";
			if (redirects) while (redirects[path] != null) path = redirects[path];
			while (!(rootNode.pathExists(getPathHierarchy(path, pathLevelSeparator, pathDataSeparator)))) if (path.indexOf(pathLevelSeparator) == -1) return ""; else path = path.substr(0, path.lastIndexOf(pathLevelSeparator));
			if (redirects) while (redirects[path] != null) path = redirects[path];
			return path;
		}

		private function getPathHierarchy(path:String, pathLevelSeparator:String, pathDataSeparator:String):Array {
			if (!path) return [];
			if (path.indexOf(pathLevelSeparator) == 0) path = path.substr(pathLevelSeparator.length);
			path = path.replace(new RegExp(pathDataSeparator.replace(REGEXP_METACHARACTERS, "\\$1") + ".*?(" + pathLevelSeparator.replace(REGEXP_METACHARACTERS, "\\$1") + "|$)", "g"), "$1");
			return path ? path.split(pathLevelSeparator) : [];
		}

		public function get currentPath():String {
			return _currentPath;
		}

		public function set currentPath(value:String):void {
			value = getValidPath(value);
			if (_currentPath == value) return;			
			var oldPath:String = _currentPath;
			_currentPath = value;
			_onPageChanged.dispatch(new ChangePageMessage(_currentPath, oldPath));
		}

		public function get onPageChanged():Dispatcher {
			return _onPageChanged;
		}

		public function get onPageCreated():Dispatcher {
			return _onPageCreated;
		}
	}
}
