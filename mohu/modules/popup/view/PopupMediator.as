package mohu.modules.popup.view {
	import mohu.messages.Message;
	import mohu.modules.popup.PopupHub;
	import mohu.modules.popup.messages.PopupMessage;
	import mohu.mvcs.view.Mediator;

	/**
	 * @author Tim Kendrick
	 */
	public class PopupMediator extends Mediator {

		[Inject("view")]

		public var view:PopupViewComponent;

		[Inject("hub")]
		public var hub:PopupHub;

		override public function onRegister():void {
			view.onClose.addListener(onClosePopup);
		}

		private function onClosePopup(message:Message):void {
			hub.hidePopup.dispatch(new PopupMessage(view));
		}
	}
}
