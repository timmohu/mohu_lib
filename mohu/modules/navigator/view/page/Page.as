package mohu.modules.navigator.view.page {
	import mohu.messages.Dispatcher;
	import mohu.modules.navigator.view.IPageViewComponent;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;

	/**
	 * @author Tim Kendrick
	 */

	public class Page extends Object {

		private static const CHILD_TRANSITION_SEQUENCES:Array = [PageTransitionSequence.SIMULTANEOUS,
			PageTransitionSequence.UNLOAD_FIRST,
			PageTransitionSequence.LOAD_FIRST];

		private var _childTransitionSequence:String;

		private var _title:String;
		private var _viewComponent:DisplayObject;
		private var _parentPage:Page;
		private var _childPage:Page;
		private var _loading:Boolean;
		private var _creationPolicy:String;
		private var _transitions:PageTransitions;

		private var _onShow:Dispatcher;
		private var _onHide:Dispatcher;
		private var _onAddChild:Dispatcher;
		private var _onRemoveChild:Dispatcher;

		public function Page(viewComponent:DisplayObject, title:String = null, transitions:PageTransitions = null, childTransitionSequence:String = "SIMULTANEOUS") {
			super();

			_title = title;
			_viewComponent = viewComponent;

			_onShow = new Dispatcher(this);
			_onHide = new Dispatcher(this);
			_onAddChild = new Dispatcher(this);
			_onRemoveChild = new Dispatcher(this);

			this.transitions = (transitions || new PageTransitions());
			this.childTransitionSequence = childTransitionSequence;

			_onShow.addListener(onShowPage);
			_onHide.addListener(onHidePage);
		}

		private function onShowPage(message:PageTransitionMessage):void {
			_loading = false;
			if (viewComponent is IPageViewComponent) (viewComponent as IPageViewComponent).show();
		}

		private function onHidePage(message:PageTransitionMessage):void {
			_parentPage = null;
			_loading = false;
		}

		public function showChildPage(page:Page, skipTransition:Boolean = false):Page {
			if (!page) return hideChildPage(skipTransition);
			if (_childPage) return replaceChild(_childPage, page, skipTransition);
			_childPage = page;
			transitions.addChildPage(this, null, page, skipTransition);
			page.show(this, null, skipTransition);
			return page;
		}

		private function replaceChild(oldPage:Page, newPage:Page, skipTransition:Boolean):Page {
			_childPage = newPage;

			var thisPage:Page = this;

			switch (childTransitionSequence) {
				case PageTransitionSequence.SIMULTANEOUS:

					transitions.addChildPage(thisPage, oldPage, newPage, skipTransition);
					oldPage.onHide.addListener(onSimultaneousHideComplete, true);
					oldPage.hide(newPage, skipTransition);
					newPage.show(this, oldPage, skipTransition);

					break;

				case PageTransitionSequence.UNLOAD_FIRST:

					oldPage.onHide.addListener(onUnloadFirstHideComplete, true);
					oldPage.hide(newPage, skipTransition);

					break;

				case PageTransitionSequence.LOAD_FIRST:

					transitions.addChildPage(thisPage, oldPage, newPage, skipTransition);
					newPage.onShow.addListener(onLoadFirstShowComplete, true);
					newPage.show(this, oldPage, skipTransition);

					break;
			}
			return newPage;

			function onSimultaneousHideComplete(message:PageTransitionMessage):void {
				transitions.removeChildPage(thisPage, oldPage, newPage, skipTransition);
			}

			function onUnloadFirstHideComplete(message:PageTransitionMessage):void {
				transitions.removeChildPage(thisPage, oldPage, newPage, skipTransition);
				transitions.addChildPage(thisPage, oldPage, newPage, skipTransition);
				newPage.show(thisPage, oldPage, skipTransition);
			}

			function onLoadFirstShowComplete(message:PageTransitionMessage):void {
				oldPage.onHide.addListener(onLoadFirstHideComplete, true);
				oldPage.hide(newPage, skipTransition);
			}

			function onLoadFirstHideComplete(message:PageTransitionMessage):void {
				transitions.removeChildPage(thisPage, oldPage, newPage, skipTransition);
			}
		}

		public function show(parentPage:Page, oldPage:Page, skipTransition:Boolean):void {
			if (_loading) throw new IllegalOperationError("Page is already loading");
			_loading = true;
			_parentPage = parentPage;
			transitions.show(this, oldPage, skipTransition);
		}

		public function hide(newPage:Page, skipTransition:Boolean):void {
			if (_loading) throw new IllegalOperationError("Page is already loading");
			_loading = true;
			if (viewComponent is IPageViewComponent) (viewComponent as IPageViewComponent).hide();
			transitions.hide(this, newPage, skipTransition);
		}

		public function hideChildPage(skipTransition:Boolean = false):Page {
			if (!_childPage) return null;
			var thisPage:Page = this;
			_childPage.onHide.addListener(onHideChild, true);
			_childPage.hide(null, skipTransition);
			return _childPage;

			function onHideChild(message:PageTransitionMessage):void {
				transitions.removeChildPage(thisPage, _childPage, null, skipTransition);
				_childPage = null;
			}
		}

		public function get loading():Boolean {
			return _loading;
		}

		public function get viewComponent():DisplayObject {
			return _viewComponent;
		}

		public function get title():String {
			return _title;
		}

		public function set title(value:String):void {
			_title = value;
		}

		public function get childContainer():DisplayObjectContainer {
			return (_viewComponent is IPageViewComponent ? (_viewComponent as IPageViewComponent).childContainer : _viewComponent as DisplayObjectContainer);
		}

		public function get parentPage():Page {
			return _parentPage;
		}

		public function get childPage():Page {
			return _childPage;
		}

		public function get creationPolicy():String {
			return _creationPolicy;
		}

		public function get childTransitionSequence():String {
			return _childTransitionSequence;
		}

		public function set childTransitionSequence(value:String):void {
			if (CHILD_TRANSITION_SEQUENCES.indexOf(value) == -1) throw new ArgumentError("Invalid child transition sequence specified");
			_childTransitionSequence = value;
		}

		public function get transitions():PageTransitions {
			return _transitions;
		}

		public function set transitions(value:PageTransitions):void {
			_transitions = (value || new PageTransitions());
		}

		public function get onShow():Dispatcher {
			return _onShow;
		}

		public function get onHide():Dispatcher {
			return _onHide;
		}

		public function get onAddChild():Dispatcher {
			return _onAddChild;
		}

		public function get onRemoveChild():Dispatcher {
			return _onRemoveChild;
		}
	}
}
