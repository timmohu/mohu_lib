package mohu.components.controllers {
	import mohu.components.interfaces.IButton;
	import mohu.components.messages.MouseMessage;
	import mohu.messages.Dispatcher;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Tim Kendrick
	 */
	public class ButtonController implements IButton {

		private var _trackAsMenu:Boolean;

		private var _onFocusIn:Dispatcher;
		private var _onFocusOut:Dispatcher;
		private var _onRollOver:Dispatcher;
		private var _onRollOut:Dispatcher;
		private var _onPress:Dispatcher;
		private var _onRelease:Dispatcher;
		private var _onReleaseOutside:Dispatcher;

		private var _rolledOver:Boolean;
		private var _pressed:Boolean;
		private var _target:InteractiveObject;

		public function ButtonController( target:InteractiveObject = null ) {
			super();

			_onFocusIn = new Dispatcher(this);
			_onFocusOut = new Dispatcher(this);
			_onRollOver = new Dispatcher(this);
			_onRollOut = new Dispatcher(this);
			_onPress = new Dispatcher(this);
			_onRelease = new Dispatcher(this);
			_onReleaseOutside = new Dispatcher(this);
			
			if ( target ) this.target = target;
		}

		
		public function get target():InteractiveObject {
			return _target;
		}

		
		
		public function set target( value:InteractiveObject ):void {
			if ( _target == value ) return;
			
			if ( _target ) {
				_target.removeEventListener(MouseEvent.ROLL_OVER, onRollOverEvent);
				_target.removeEventListener(MouseEvent.ROLL_OUT, onRollOutEvent);
				_target.removeEventListener(MouseEvent.MOUSE_DOWN, onPressEvent);
				_target.removeEventListener(MouseEvent.MOUSE_UP, onReleaseEvent);
			}
			
			_target = value;
			
			if ( _target ) {
				_target.addEventListener(MouseEvent.ROLL_OVER, onRollOverEvent, false, 0, true);
				_target.addEventListener(MouseEvent.ROLL_OUT, onRollOutEvent, false, 0, true);
				_target.addEventListener(MouseEvent.MOUSE_DOWN, onPressEvent, false, 0, true);
				_target.addEventListener(MouseEvent.MOUSE_UP, onReleaseEvent, false, 0, true);
			}
		}

		
		
		private function onRollOverEvent( event:MouseEvent ):void {
			if ( event.buttonDown && !_trackAsMenu && !_pressed ) return;
			_rolledOver = true;
			dispatchMessage(_onRollOver, event);
			if ( event.buttonDown && ( _trackAsMenu != _pressed ) ) onPressEvent(event);
		}

		
		
		private function onRollOutEvent(event:MouseEvent):void {
			if ( event.buttonDown && !_trackAsMenu && !_pressed ) return;
			if ( event.buttonDown && _trackAsMenu ) onReleaseOutsideEvent(event);
			_rolledOver = false;
			dispatchMessage(_onRollOut, event);
		}

		
		
		private function onPressEvent(event:MouseEvent):void {
			_pressed = true;
			dispatchMessage(_onPress, event);
			if ( _trackAsMenu ) return;
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, onReleaseOutsideEvent, false, 0, true);
			_target.stage.addEventListener(Event.MOUSE_LEAVE, onReleaseOutsideEvent, false, 0, true);
			_target.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
		}

		
		
		private function onRemoved(event:Event):void {
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseOutsideEvent);
			_target.stage.removeEventListener(Event.MOUSE_LEAVE, onReleaseOutsideEvent);
			_target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}

		
		
		private function onReleaseEvent( event:MouseEvent ):void {
			// TODO: look into this
			if ( _target.stage ) {
				_target.stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseOutsideEvent);
				_target.stage.removeEventListener(Event.MOUSE_LEAVE, onReleaseOutsideEvent);
			}
			_target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			_rolledOver = true;
			if ( _pressed ) {
				_pressed = false;
				dispatchMessage(_onRelease, event);
			}
			dispatchMessage(_onRollOver, event);
		}

		
		
		private function onReleaseOutsideEvent(event:MouseEvent):void {
			_target.stage.removeEventListener(MouseEvent.MOUSE_UP, onReleaseOutsideEvent);
			_target.stage.removeEventListener(Event.MOUSE_LEAVE, onReleaseOutsideEvent);
			_target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			_pressed = false;
			_rolledOver = false;
			dispatchMessage(_onReleaseOutside, event);
		}

		
		
		private function dispatchMessage( dispatcher:Dispatcher, event:MouseEvent ):void {
			dispatcher.dispatch(new MouseMessage(event.relatedObject, event.ctrlKey, event.altKey, event.shiftKey, event.buttonDown));
		}

		
		
		public function get trackAsMenu():Boolean {
			return _trackAsMenu;
		}

		
		
		public function set trackAsMenu( value:Boolean ):void {
			_trackAsMenu = value;
		}

		
		
		public function get pressed():Boolean {
			return _pressed;
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

		
		
		public function get rolledOver():Boolean {
			return _rolledOver;
		}

		
		
		public function get onFocusIn():Dispatcher {
			return _onFocusIn;
		}

		
		
		public function get onFocusOut():Dispatcher {
			return _onFocusOut;
		}

		
		public function get interactiveObject():InteractiveObject {
			return _target;
		}

		
		
		public function set interactiveObject(interactiveObject:InteractiveObject):void {
			_target = interactiveObject;
		}
	}
}
