package mohu.components.controllers {
	import mohu.components.interfaces.IButton;
	import mohu.components.messages.MouseMessage;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Tim Kendrick
	 */
	public class RepeatButtonController {

		private var _button:IButton;

		private var _repeatTimer:Timer;
		private var _delayTimer:Timer;

		private var _delay:int;
		private var _interval:int;
		private var _repeating:Boolean;
		private var _acceleration:Number;
		private var _minInterval:Number;

		public function RepeatButtonController( delay:int = 400 , interval:int = 40 , acceleration:Number = 1 , minInterval:int = 5 , button:IButton = null ) {
			_delayTimer = new Timer(0, 1);
			_repeatTimer = new Timer(0, 1);
			
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onBeginRepeat, false, 0, true);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat, false, 0, true);

			this.delay = delay;
			this.interval = interval;
			this.acceleration = acceleration;
			this.minInterval = minInterval;
			
			if ( button ) this.button = button;
		}

		
		
		public function get delay():int {
			return _delay;
		}

		
		
		public function set delay( value:int ):void {
			if ( _repeating ) cancelRepeat();
			
			_delay = Math.max(0, value);
			_delayTimer.delay = _delay;
		}

		
		
		public function get interval():int {
			return _interval;
		}

		
		
		public function set interval( value:int ):void {
			if ( _repeating ) cancelRepeat();
			
			_interval = Math.max(0, value);
		}

		
		
		public function get acceleration():Number {
			return _acceleration;
		}

		
		
		public function set acceleration( value:Number ):void {
			if ( _repeating ) cancelRepeat();
			
			_acceleration = ( isNaN(value) ? 0 : value );
		}

		
		
		public function get minInterval():int {
			return _minInterval;
		}

		
		
		public function set minInterval( value:int ):void {
			if ( _repeating ) cancelRepeat();
			
			_minInterval = Math.max(0, value);
		}

		
		
		public function get button():IButton {
			return _button;
		}

		
		
		public function set button( value:IButton ):void {
			if ( _button == value ) return;
			
			if ( _repeating ) cancelRepeat();
			
			if ( _button ) {
				_button.onPress.removeListener(onPress);
				_button.onRelease.removeListener(onRelease);
				_button.onReleaseOutside.removeListener(onRelease);
			}
			
			_button = value;
			
			if ( _button ) {
				_button.onPress.addListener(onPress);
				_button.onRelease.addListener(onRelease);
				_button.onReleaseOutside.addListener(onRelease);
			}
		}

		
		
		private function onRelease( message:MouseMessage ):void {
			cancelRepeat();
		}

		
		
		private function onPress( message:MouseMessage ):void {
			if  ( _repeating ) return;
			_repeating = true;
			if ( _delay == 0 ) onBeginRepeat(null); else _delayTimer.start();
		}

		
		
		private function onBeginRepeat( event:TimerEvent ):void {
			_repeatTimer.delay = _interval;
			_repeatTimer.start();
			_button.onPress.dispatch(new MouseMessage());
		}

		
		
		private function onRepeat( event:TimerEvent ):void {			
			_button.onPress.dispatch(new MouseMessage());
			_repeatTimer.reset();
			_repeatTimer.delay = Math.max(_minInterval, _repeatTimer.delay - _acceleration);
			if ( _repeatTimer.delay != 0 ) _repeatTimer.start();
		}

		
		
		private function cancelRepeat():void {
			_repeatTimer.stop();
			_repeatTimer.reset();
			
			_delayTimer.stop();
			_delayTimer.reset();
			
			_repeating = false;
		}

		
		
		public function get repeating():Boolean {
			return _repeating;
		}
	}
}
