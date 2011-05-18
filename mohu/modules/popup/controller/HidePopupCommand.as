package mohu.modules.popup.controller {
	import mohu.modules.popup.model.PopupModel;
	import mohu.mvcs.controller.Command;

	/**
	 * @author Tim Kendrick
	 */
	public class HidePopupCommand extends Command {

		[Inject]

		public var model:PopupModel;

		override public function execute():void {
			model.currentPopup = null;
		}
	}
}
