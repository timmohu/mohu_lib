package mohu.modules.navigator.model.sitemap {
	import mohu.modules.navigator.view.page.PageTransitions;

	/**
	 * @author Tim Kendrick
	 */
	public class PageNode extends Node {

		public var viewComponent:Class;
		public var title:String;
		public var transitions:PageTransitions;
		public var childTransitionSequence:String;
		public var data:*;

		public function PageNode(viewComponent:Class, title:String = null, transitions:PageTransitions = null, childTransitionSequence:String = "SIMULTANEOUS", data:* = null) {
			this.viewComponent = viewComponent;
			this.title = title;
			this.transitions = transitions;
			this.childTransitionSequence = childTransitionSequence;
			this.childTransitionSequence = childTransitionSequence;
			this.data = data;

			super();
		}
	}
}
