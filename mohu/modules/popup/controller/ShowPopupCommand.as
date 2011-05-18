package mohu.modules.popup.controller {
	import mohu.modules.popup.messages.PopupMessage;
	import mohu.modules.popup.model.PopupModel;
	import mohu.mvcs.controller.Command;

	/**
	 * @author Tim Kendrick
	 */
	public class ShowPopupCommand extends Command {

		[Inject("message")]

		public var message:PopupMessage;

		[Inject]
		public var model:PopupModel;

		override public function execute():void {
			model.currentPopup = message.popup;
		}
	}
}
