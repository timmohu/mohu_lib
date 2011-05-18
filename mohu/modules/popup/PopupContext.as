package mohu.modules.popup {
	import mohu.modules.popup.controller.AddPopupCommand;
	import mohu.modules.popup.controller.HidePopupCommand;
	import mohu.modules.popup.controller.RemovePopupCommand;
	import mohu.modules.popup.controller.ShowPopupCommand;
	import mohu.modules.popup.model.PopupModel;
	import mohu.modules.popup.view.PopupViewComponent;
	import mohu.mvcs.Context;

	import flash.display.DisplayObjectContainer;

	/**
	 * @author Tim Kendrick
	 */
	public class PopupContext extends Context {

		private var _model:PopupModel;

		public function PopupContext(container:DisplayObjectContainer, addPopupCommand:Class = null, removePopupCommand:Class = null) {
			super(new PopupHub());
			
			_initModel(container);
			_initView();
			_initController(addPopupCommand, removePopupCommand);
			_initServices();
		}

		private function _initModel(container:DisplayObjectContainer):void {
			var hub:PopupHub = this.hub as PopupHub;
			_model = new PopupModel(container);
			_model.onPopupAdded.addListener(hub.addPopup.dispatch);
			_model.onPopupRemoved.addListener(hub.removePopup.dispatch);
			this.injector.mapClassInstance(PopupModel, _model);
		}

		private function _initView():void {
		}

		private function _initController(addPopupCommand:Class = null, removePopupCommand:Class = null):void {
			var hub:PopupHub = this.hub as PopupHub;
			
			commandMap.mapCommand(hub.addPopup, addPopupCommand || AddPopupCommand);
			commandMap.mapCommand(hub.removePopup, removePopupCommand || RemovePopupCommand);
			commandMap.mapCommand(hub.showPopup, ShowPopupCommand);
			commandMap.mapCommand(hub.hidePopup, HidePopupCommand);
		}

		private function _initServices():void {
		}

		public function get currentPopup():PopupViewComponent {
			return _model.currentPopup;
		}

		public function set currentPopup(value:PopupViewComponent):void {
			_model.currentPopup = value;
		}
	}
}
