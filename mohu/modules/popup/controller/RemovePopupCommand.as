package mohu.modules.popup.controller {
	import mohu.modules.popup.messages.PopupMessage;
	import mohu.modules.popup.model.PopupModel;
	import mohu.mvcs.controller.Command;

	/**
	 * @author Tim Kendrick
	 */
	public class RemovePopupCommand extends Command {

		[Inject("message")]

		public var message:PopupMessage;

		[Inject]
		public var model:PopupModel;

		override public function execute():void {
			if (message.popup.parent == model.container) model.container.removeChild(message.popup);
		}
	}
}
