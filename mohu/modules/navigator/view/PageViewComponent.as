package mohu.modules.navigator.view {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * @author Tim Kendrick
	 */
	public class PageViewComponent extends Sprite implements IPageViewComponent {

		private var _childContainer:DisplayObjectContainer;

		public function PageViewComponent() {
			_childContainer = this;

			super();
		}

		public function show():void {
		}

		public function hide():void {
		}

		public function get childContainer():DisplayObjectContainer {
			return _childContainer;
		}

		public function set childContainer(value:DisplayObjectContainer):void {
			_childContainer = value;
		}
	}
}
