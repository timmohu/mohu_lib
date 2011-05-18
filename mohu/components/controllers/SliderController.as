package mohu.components.controllers {
	import mohu.components.interfaces.IButton;
	import mohu.components.interfaces.ISlider;
	import mohu.components.messages.FocusMessage;
	import mohu.components.messages.MouseMessage;
	import mohu.components.messages.ValueChangeMessage;
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	/**
	 * @author Tim Kendrick
	 * 
	 * track and handle IButtons must have their registration points on the left
	 */
	public class SliderController implements ISlider {

		private var _handle:IButton;
		private var _track:IButton;
		private var _fill:DisplayObject;

		private var _horizontal:Boolean;
		private var _handleLength:Number;
		private var _invertAxis:Boolean;
		private var _snap:Number;
		private var _liveUpdate:Boolean;
		private var _position:Number;
		private var _keyboardNudge:Number;

		private var _sliding:Boolean;
		private var _slideOffset:Number;

		private var _onChange:Dispatcher;
		private var _onDragStart:Dispatcher;
		private var _onDragStop:Dispatcher;

		public function SliderController( horizontal:Boolean = false , track:IButton = null , handle:IButton = null , fill:DisplayObject = null , invertAxis:Boolean = false , liveUpdate:Boolean = true , snap:Number = 0 , handleLength:Number = NaN , keyboardNudge:Number = 0.1 ) {
			_horizontal = horizontal;
			_invertAxis = invertAxis;
			_liveUpdate = liveUpdate;
			_snap = ( ( isNaN(snap) || ( snap < 0 ) ) ? 0 : snap );
			_handleLength = handleLength;
			_keyboardNudge = keyboardNudge;
			
			_position = 0;

			_onDragStart = new Dispatcher(this);
			_onDragStop = new Dispatcher(this);
			_onChange = new Dispatcher(this);

			this.handle = handle;
			this.track = track;
			this.fill = fill;
			
			updateAppearance();
		}

		
		
		public function updateAppearance():void {
			positionElements(_position);
		}

		
		
		public function positionElements( position:Number ):void {
			// TODO: is this right?
			var trackPosition:Number = trackLength * ( _invertAxis ? 1 - position : position );
			if ( _horizontal ) {
				if ( _handle && _handle.interactiveObject ) ( _handle.interactiveObject as DisplayObject ).x = ( _track && _track.interactiveObject ? ( _track.interactiveObject as DisplayObject ).x : 0 ) + trackPosition;
				if ( _fill) ( _fill as DisplayObject ).width = ( ( ( _track.interactiveObject ? ( _track.interactiveObject as DisplayObject ).x : 0 ) + trackPosition ) - _fill.x );
			} else {
				if ( _handle && _handle.interactiveObject ) ( _handle.interactiveObject as DisplayObject ).y = ( _track && _track.interactiveObject ? ( _track.interactiveObject as DisplayObject ).y : 0 ) + trackPosition;
				if ( _fill) ( _fill as DisplayObject ).height = ( ( ( _track && _track.interactiveObject ? ( _track.interactiveObject as DisplayObject ).y : 0 ) + trackPosition ) - _fill.y );
			}
		}

		
		
		private function getMousePosition( offset:Number = 0 ):Number {
			var track:DisplayObject = _track.interactiveObject as DisplayObject;
			var mousePosition:Number = ( track ? ( ( ( _horizontal ? track.mouseX * track.scaleX : track.mouseY * track.scaleY ) ) / trackLength ) - offset : 0);
			// TODO: is this right?
			if ( _invertAxis ) mousePosition = 1 - mousePosition;
			return mousePosition;
		}

		
		
		private function snapPosition( position:Number ):Number {
			if ( isNaN(position) ) return 0;
			if ( _snap == 0 ) return position;
			return ( _snap * Math.round(position / _snap) );
		}

		
		
		public function get invertAxis():Boolean {
			return _invertAxis;
		}

		
		
		public function set invertAxis( value:Boolean ):void {
			if ( _invertAxis == value ) return;
			_invertAxis = value;
			updateAppearance();
		}

		
		
		public function get horizontal():Boolean {
			return _horizontal;
		}

		
		
		public function set horizontal( value:Boolean ):void {
			if ( _horizontal == value ) return;
			_horizontal = value;
			updateAppearance();
		}

		
		
		public function get trackLength():Number {
			if( _track) {
				return ( _track && _track.interactiveObject ? ( _horizontal ? ( _track.interactiveObject as DisplayObject ).width : ( _track.interactiveObject as DisplayObject ).height ) - handleLength : 0 );
			}
			return 0;
		}

		
		
		public function get handleLength():Number {
			if ( !isNaN(_handleLength) ) return _handleLength;
			return ( _handle && _handle.interactiveObject ? ( _horizontal ? ( _handle.interactiveObject as DisplayObject ).width : ( _handle.interactiveObject as DisplayObject ).height ) : 0 );
		}

		
		
		public function set handleLength( value:Number ):void {
			if ( _handleLength == value ) return;
			_handleLength = value;
			updateAppearance();
		}

		
		
		public function get handle():IButton {
			return _handle;
		}

		
		
		public function set handle( value:IButton ):void {
			if ( value && !( value.interactiveObject is DisplayObject ) ) throw new ArgumentError("Specified handle is not a DisplayObject");
			if ( _handle == value.interactiveObject ) return;
			if ( _handle ) {
				_handle.onPress.removeListener(onPressHandle);
				_handle.onRelease.removeListener(onReleaseHandle);
				_handle.onReleaseOutside.removeListener(onReleaseHandle);
			}
			_handle = value;
			if ( _handle ) {
				_handle.onPress.addListener(onPressHandle);
				_handle.onRelease.addListener(onReleaseHandle);
				_handle.onReleaseOutside.addListener(onReleaseHandle);
			}
			updateAppearance();
		}

		
		
		private function onPressHandle( message:Message ):void {
			var handle:DisplayObject = _handle.interactiveObject as DisplayObject;
			if ( handle ) {
				var offset:Number = getMousePosition(( _horizontal ? handle.x : handle.y ) / trackLength);
				_slideOffset = _invertAxis ? -offset : offset;
				handle.stage.addEventListener(MouseEvent.MOUSE_MOVE, onDragHandle, false, 0, true);
			}
			_sliding = true;
			_onDragStart.dispatch();
		}

		
		
		private function onDragHandle( event:MouseEvent , forceUpdate:Boolean = false ):void {
			var mousePosition:Number = getMousePosition(_slideOffset);
			if ( _liveUpdate || forceUpdate ) {
				position = snapPosition(mousePosition);
			} else {
				positionElements(snapPosition(mousePosition));
			}
			if ( event ) event.updateAfterEvent();
		}

		
		
		private function onReleaseHandle( message:Message ):void {
			onDragHandle(null, true);
			if ( _handle.interactiveObject ) _handle.interactiveObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDragHandle);
			_sliding = false;
			_slideOffset = NaN;
			_onDragStop.dispatch();
		}

		
		
		public function get track():IButton {
			return _track;
		}

		
		
		public function set track( value:IButton ):void {
			if ( value && !( value.interactiveObject is DisplayObject ) ) throw new ArgumentError("Specified track is not a DisplayObject");
			if ( _track == value ) return;
			if ( _track ) {
				_track.onPress.removeListener(onPressTrack);
				_track.onFocusIn.removeListener(onFocusIn);
				_track.onFocusOut.removeListener(onFocusOut);
			}
			_track = value;
			if ( _track ) {
				_track.onPress.addListener(onPressTrack);
				_track.onFocusIn.addListener(onFocusIn);
				_track.onFocusOut.addListener(onFocusOut);
			}
			updateAppearance();
		}

		
		
		private function onPressTrack( message:MouseMessage ):void {
			if ( _handle.interactiveObject ) ( _handle.interactiveObject as InteractiveObject ).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
			position = snapPosition(getMousePosition(( handleLength / 2) / trackLength));
		}

		
		
		private function onFocusIn( message:FocusMessage ):void {
			if ( !( _track.interactiveObject ) ) return;
			( _track.interactiveObject as InteractiveObject ).addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			( _track.interactiveObject as InteractiveObject ).addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange, false, 0, true);
		}

		
		
		private function onFocusOut( event:Event ):void {
			if ( !( _track.interactiveObject ) ) return;
			( _track.interactiveObject as InteractiveObject ).removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			( _track.interactiveObject as InteractiveObject ).removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, onKeyFocusChange);
		}

		
		
		private function onKeyDown( event:KeyboardEvent ):void {
			if ( sliding ) return;
			var nudge:int = 0;
			switch ( event.keyCode ) {
				case ( horizontal ? Keyboard.LEFT : Keyboard.UP ):
					nudge = ( invertAxis ? 1 : -1 );
					break;
				case ( horizontal ? Keyboard.RIGHT : Keyboard.DOWN):
					nudge = ( invertAxis ? -1 : 1 );
					break;
			}
			if ( nudge ) position = ( _position + nudge * _keyboardNudge );
		}

		
		
		private function onKeyFocusChange( event:FocusEvent ):void {
			if ( ( event.keyCode == ( horizontal ? Keyboard.LEFT : Keyboard.UP ) ) || ( event.keyCode == ( horizontal ? Keyboard.RIGHT : Keyboard.DOWN ) ) ) event.preventDefault();
		}

		
		
		public function get fill():DisplayObject {
			return _fill;
		}

		
		
		public function set fill( value:DisplayObject ):void {
			if ( _fill == value ) return;
			_fill = value;
			if ( _fill is InteractiveObject) ( _fill as InteractiveObject ).mouseEnabled = false;
			updateAppearance();
		}

		
		
		public function get snap():Number {
			return _snap;
		}

		
		
		public function set snap( value:Number ):void {
			_snap = ( ( isNaN(value) || ( value < 0 ) ) ? 0 : value );
		}

		
		
		public function get liveUpdate():Boolean {
			return _liveUpdate;
		}

		
		
		public function set liveUpdate( value:Boolean ):void {
			_liveUpdate = value;
		}

		
		
		public function get position():Number {
			return _position;
		}

		
		
		public function set position( value:Number ):void {
			value = Math.max(0, Math.min(1, value)); 
			if ( _position == value ) return;
			var oldValue:Number = _position;
			_position = value;
			updateAppearance();
			onChange.dispatch(new ValueChangeMessage(oldValue, value));
		}

		
		
		public function get sliding():Boolean {
			return _sliding;
		}

		
		
		public function get keyboardNudge():Number {
			return _keyboardNudge;
		}

		
		
		public function set keyboardNudge( value:Number ):void {
			_keyboardNudge = ( ( isNaN(value) || ( value < 0 ) ) ? 0 : value );
		}

		
		
		public function get onChange():Dispatcher {
			return _onChange;
		}

		
		
		public function get onDragStart():Dispatcher {
			return _onDragStart;
		}

		
		
		public function get onDragStop():Dispatcher {
			return _onDragStop;
		}
	}
}
