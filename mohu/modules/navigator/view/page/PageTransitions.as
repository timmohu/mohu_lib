package mohu.modules.navigator.view.page {

	/**
	 * @author Tim Kendrick
	 */
	public class PageTransitions extends Object {

		public function show(page:Page, oldPage:Page, skipTransition:Boolean):void {
			skipTransition;
			page.onShow.dispatch(new PageTransitionMessage(oldPage, page));
		}

		public function hide(page:Page, newPage:Page, skipTransition:Boolean):void {
			skipTransition;
			page.onHide.dispatch(new PageTransitionMessage(page, newPage));
		}

		public function addChildPage(parentPage:Page, oldPage:Page, newPage:Page, skipTransition:Boolean):void {
			skipTransition;
			parentPage.childContainer.addChild(newPage.viewComponent);
			parentPage.onAddChild.dispatch(new PageTransitionMessage(oldPage, newPage));
		}

		public function removeChildPage(parentPage:Page, oldPage:Page, newPage:Page, skipTransition:Boolean):void {
			skipTransition;
			if (oldPage.viewComponent.parent == parentPage.childContainer) parentPage.childContainer.removeChild(oldPage.viewComponent);
			parentPage.onRemoveChild.dispatch(new PageTransitionMessage(oldPage, newPage));
		}
	}
}
