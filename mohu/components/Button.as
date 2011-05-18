package mohu.components {
	import mohu.components.controllers.ButtonController;
	import mohu.components.interfaces.IButton;
	import mohu.components.messages.FocusMessage;
	import mohu.components.messages.MouseMessage;
	import mohu.messages.Dispatcher;

	import flash.display.InteractiveObject;
	import flash.display.Sprite;

	/**
	 * @author Tim Kendrick
	 */
	public class Button extends Sprite implements IButton {

		private var _controller:ButtonController;

		private var _onFocusIn:Dispatcher;
		private var _onFocusOut:Dispatcher;
		private var _onRollOver:Dispatcher;
		private var _onRollOut:Dispatcher;
		private var _onPress:Dispatcher;
		private var _onRelease:Dispatcher;
		private var _onReleaseOutside:Dispatcher;
		private var _interactiveObject:InteractiveObject;

		public function Button() {
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
			
			_controller = new ButtonController(this);
			
			_controller.onFocusIn.addListener(onControllerFocusIn);
			_controller.onFocusOut.addListener(onControllerFocusOut);
			_controller.onRollOver.addListener(onControllerRollOver);
			_controller.onRollOut.addListener(onControllerRollOut);
			_controller.onPress.addListener(onControllerPress);
			_controller.onRelease.addListener(onControllerRelease);
			_controller.onReleaseOutside.addListener(onControllerReleaseOutside);
			
			_interactiveObject = this;
			
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

		
		
		public function get interactiveObject():InteractiveObject {
			return _interactiveObject;
		}

		
		
		public function set interactiveObject(interactiveObject:InteractiveObject):void {
			_interactiveObject = interactiveObject;
		}
	}
}
