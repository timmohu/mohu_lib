package mohu.components {
	import mohu.components.controllers.SelectableButtonController;
	import mohu.components.interfaces.ISelectableButton;
	import mohu.components.messages.FocusMessage;
	import mohu.components.messages.MouseMessage;
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.display.InteractiveObject;
	import flash.display.Sprite;

	/**
	 * @author Tim Kendrick
	 */
	public class SelectableButton extends Sprite implements ISelectableButton {

		private var _controller:SelectableButtonController;

		private var _onFocusIn:Dispatcher;
		private var _onFocusOut:Dispatcher;
		private var _onRollOver:Dispatcher;
		private var _onRollOut:Dispatcher;
		private var _onPress:Dispatcher;
		private var _onRelease:Dispatcher;
		private var _onReleaseOutside:Dispatcher;
		private var _onChange:Dispatcher;
		private var _onSelect:Dispatcher;
		private var _onDeselect:Dispatcher;

		public function SelectableButton() {
			super();
			
			buttonMode = useHandCursor = true;
			mouseChildren = false;

			_onFocusIn = new Dispatcher(this);
			_onFocusOut = new Dispatcher(this);
			_onRollOver = new Dispatcher(this);
			_onRollOut = new Dispatcher(this);
			_onPress = new Dispatcher(this);
			_onRelease = new Dispatcher(this);
			_onReleaseOutside = new Dispatcher(this);
			_onChange = new Dispatcher(this);
			_onSelect = new Dispatcher(this);
			_onDeselect = new Dispatcher(this);
			
			_controller = new SelectableButtonController(this);
			
			_controller.onFocusIn.addListener(onControllerFocusIn);
			_controller.onFocusOut.addListener(onControllerFocusOut);
			_controller.onRollOver.addListener(onControllerRollOver);
			_controller.onRollOut.addListener(onControllerRollOut);
			_controller.onPress.addListener(onControllerPress);
			_controller.onRelease.addListener(onControllerRelease);
			_controller.onReleaseOutside.addListener(onControllerReleaseOutside);
			_controller.onChange.addListener(onControllerChange);
			_controller.onSelect.addListener(onControllerSelect);
			_controller.onDeselect.addListener(onControllerDeselect);

			updateAppearance();
		}

		
		
		protected function updateAppearance():void {
		}

		
		
		private function onControllerFocusIn( message:FocusMessage ):void {
			_onFocusIn.dispatch(message, this);
		}

		
		
		private function onControllerFocusOut( message:FocusMessage ):void {
			_onFocusOut.dispatch(message, this);
		}

		
		
		private function onControllerRollOver( message:MouseMessage ):void {
			updateAppearance();
			_onRollOver.dispatch(message, this);
		}

		
		
		private function onControllerRollOut( message:MouseMessage ):void {
			updateAppearance();
			_onRollOut.dispatch(message, this);
		}

		
		
		private function onControllerPress( message:MouseMessage ):void {
			updateAppearance();
			_onPress.dispatch(message, this);
		}

		
		
		private function onControllerRelease( message:MouseMessage ):void {
			updateAppearance();
			_onRelease.dispatch(message, this);
		}

		
		
		private function onControllerReleaseOutside( message:MouseMessage ):void {
			updateAppearance();
			_onReleaseOutside.dispatch(message, this);
		}

		
		
		private function onControllerChange( message:Message ):void {
			_onChange.dispatch(message, this);
		}

		
		
		private function onControllerSelect( message:Message ):void {
			updateAppearance();
			_onSelect.dispatch(message, this);
		}

		
		
		private function onControllerDeselect( message:Message ):void {
			updateAppearance();
			_onDeselect.dispatch(message, this);
		}

		
		
		public function get trackAsMenu():Boolean {
			return _controller.trackAsMenu;
		}

		
		
		public function set trackAsMenu( value:Boolean ):void {
			_controller.trackAsMenu = value;
		}

		
		
		public function get rolledOver():Boolean {
			return _controller.rolledOver;
		}

		
		
		public function get pressed():Boolean {
			return _controller.pressed;
		}

		
		
		public function get selected():Boolean {
			return _controller.selected;
		}

		
		
		public function set selected( value:Boolean ):void {
			_controller.selected = value;
		}

		
		
		public function get onRollOver():Dispatcher {
			return _onRollOver;
		}

		
		
		public function get onRollOut():Dispatcher {
			return _onRollOut;
		}

		
		
		public function get onPress():Dispatcher {
			return _onPress;
		}

		
		
		public function get onRelease():Dispatcher {
			return _onRelease;
		}

		
		
		public function get onReleaseOutside():Dispatcher {
			return _onReleaseOutside;
		}

		
		
		public function get onFocusIn():Dispatcher {
			return _onFocusIn;
		}

		
		
		public function get onFocusOut():Dispatcher {
			return _onFocusOut;
		}

		
		
		public function get onChange():Dispatcher {
			return _onChange;
		}

		
		
		public function get onSelect():Dispatcher {
			return _onSelect;
		}

		
		
		public function get onDeselect():Dispatcher {
			return _onDeselect;
		}

		
		
		public function get interactiveObject():InteractiveObject {
			// TODO: Auto-generated method stub
			return null;
		}

		
		
		public function set interactiveObject(interactiveObject:InteractiveObject):void {
		}
	}
}
