package mohu.components.controllers {
	import mohu.components.interfaces.IButton;
	import mohu.components.interfaces.IScrollBar;
	import mohu.components.interfaces.ISlider;
	import mohu.components.messages.ValueChangeMessage;
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author Tim Kendrick
	 */
	public class ScrollBarController implements IScrollBar {

		private var _slider:ISlider;
		private var _content:DisplayObject;
		private var _scrollMask:DisplayObject;
		private var _upArrow:IButton;
		private var _downArrow:IButton;
		private var _horizontal:Boolean;
		private var _keyboardNudge:Number;
		private var _snap:Number;
		private var _offset:Number;

		private var _scrollOrigin:Point;
		private var _oldScrollLength:Number;
		private var _oldScrollable:Boolean;

		private var _onScrollEnabled:Dispatcher;
		private var _onScrollDisabled:Dispatcher;
		private var _onChange:Dispatcher;
		private var _onDragStop:Dispatcher;
		private var _onDragStart:Dispatcher;

		public function ScrollBarController( horizontal:Boolean = false , content:DisplayObject = null , scrollMask:DisplayObject = null , slider:ISlider = null , upArrow:IButton = null , downArrow:IButton = null , keyboardNudge:Number = 16 , snap:Number = 0 ) {
			_horizontal = horizontal;
			_keyboardNudge = keyboardNudge;
			_snap = snap;
			
			_onChange = new Dispatcher(this);
			_onDragStart = new Dispatcher(this);
			_onDragStop = new Dispatcher(this);
			_onScrollEnabled = new Dispatcher(this);
			_onScrollDisabled = new Dispatcher(this);
			
			_scrollOrigin = new Point();
			
			this.content = content;
			this.scrollMask = scrollMask;
			this.slider = slider;
			this.upArrow = upArrow;
			this.downArrow = downArrow;
		}

		
		
		public function updateAppearance():void {
			_offset = position * maxScroll;
			if ( _content ) {
				var contentPosition:Number = ( _horizontal ? _scrollOrigin.x : _scrollOrigin.y ) - _offset;
				if ( _horizontal ) _content.x = contentPosition; else this.content.y = contentPosition;
			}
		}

		
		
		public function get content():DisplayObject {
			return _content;
		}

		
		
		public function set content( value:DisplayObject ):void {
			if ( _content == value ) return;
			if ( _content ) {
				if ( _content.mask == _scrollMask ) _content.mask = null;

				_scrollOrigin = new Point();

				_content.removeEventListener(Event.ADDED_TO_STAGE, onContentAdded);
				_content.removeEventListener(Event.REMOVED_FROM_STAGE, onContentRemoved);
				_content.removeEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel);
			}
			
			_content = value;
			
			if ( _content ) {
				if ( _scrollMask ) _content.mask = _scrollMask;
				_content.cacheAsBitmap = true;

				_scrollOrigin = new Point(_content.x, _content.y);

				_content.addEventListener(Event.ADDED_TO_STAGE, onContentAdded, false, 0, true);
				_content.addEventListener(Event.REMOVED_FROM_STAGE, onContentRemoved, false, 0, true);
				_content.addEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel, false, 0, true);

				if ( _content.stage ) onContentAdded(null);
			}
			
			updateScrollLength();
		}

		
		
		private function onScrollWheel( event:MouseEvent ):void {
			_slider.position -= event.delta * _slider.keyboardNudge;
		}

		
		
		private function onContentAdded( event:Event ):void {
			_content.addEventListener(Event.ENTER_FRAME, onEnterFrame);				
		}

		
		
		private function onContentRemoved( event:Event ):void {
			_content.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		
		
		private function onEnterFrame( event:Event ):void {
			updateScrollLength();
		}

		
		
		private function updateScrollLength():void {

			var scrollLength:Number = this.scrollLength;
			if ( scrollLength == _oldScrollLength ) return;
			
			if ( _slider ) {
				updateSliderSnap();
				updateSliderNudge();
			}
			_oldScrollLength = scrollLength;

			var scrollable:Boolean = this.scrollable;
			if ( scrollable != _oldScrollable ) {
				if ( scrollable ) {
					onScrollEnabled.dispatch();
				} else {
					_slider.position = 0;
					onScrollDisabled.dispatch();
				}
			}
			_oldScrollable = scrollable;
		}

		
		
		private function updateSliderSnap():void {
			var maxScroll:Number = this.maxScroll;
			_slider.keyboardNudge = ( maxScroll == 0 ? 0 : _snap / maxScroll );
		}

		
		
		private function updateSliderNudge():void {
			var maxScroll:Number = this.maxScroll;
			_slider.keyboardNudge = ( maxScroll == 0 ? 0 : _keyboardNudge / maxScroll );
		}

		
		
		public function get scrollMask():DisplayObject {
			return _scrollMask;
		}

		
		
		public function get slider():ISlider {
			return _slider;
		}

		
		
		public function set scrollMask( value:DisplayObject ):void {
			if ( _scrollMask == value ) return;
			
			if ( _scrollMask ) {
				if ( _content ) _content.mask = null;
			}
			
			_scrollMask = value;

			if ( _scrollMask ) {
				if ( _content ) _content.mask = _scrollMask;
			}
			
			updateScrollLength();
		}

		
		
		public function set slider( value:ISlider ):void {
			if ( _slider ) {
				_slider.onChange.removeListener(onSliderChange);
				_slider.onDragStart.addListener(onSliderDragStart);
				_slider.onDragStop.addListener(onSliderDragStop);
			}
			_slider = value;
			if ( _slider ) {
				_slider.onChange.addListener(onSliderChange);
				_slider.onDragStart.addListener(onSliderDragStart);
				_slider.onDragStop.addListener(onSliderDragStop);
			}
		}

		
		
		private function onSliderDragStart( message:Message ):void {
			_onDragStart.dispatch(message, this);
		}

		
		
		private function onSliderDragStop( message:Message ):void {
			_onDragStop.dispatch(message, this);
		}

		
		
		private function onSliderChange( message:ValueChangeMessage ):void {
			updateAppearance();
			_onChange.dispatch(message, this);
		}

		
		
		public function get upArrow():IButton {
			return _upArrow;
		}

		
		
		public function set upArrow( value:IButton ):void {
			if ( _upArrow == value ) return;

			if ( _upArrow ) _upArrow.onPress.removeListener(onPressUpArrow);
			
			_upArrow = value;

			if ( _upArrow ) _upArrow.onPress.addListener(onPressUpArrow);
		}

		
		
		private function onPressUpArrow( message:Message ):void {
			if ( _slider ) _slider.position -= _slider.keyboardNudge;
		}

		
		
		public function get downArrow():IButton {
			return _downArrow;
		}

		
		
		public function set downArrow(value:IButton):void {
			if ( _downArrow == value ) return;

			if ( _downArrow ) _downArrow.onPress.removeListener(onPressDownArrow);
			
			_downArrow = value;

			if ( _downArrow ) _downArrow.onPress.addListener(onPressDownArrow);
		}

		
		
		private function onPressDownArrow( message:Message ):void {
			if ( _slider ) _slider.position += _slider.keyboardNudge;
		}

		
		
		
		public function get snap():Number { 
			return _snap; 
		}

		
		
		public function set snap( value:Number ):void { 
			_snap = ( isNaN(value) || ( value < 0 ) ? 0 : value );
			updateSliderSnap(); 
		}

		
		
		public function get keyboardNudge():Number {
			return _keyboardNudge;
		}

		
		
		public function set keyboardNudge( value:Number ):void {
			_keyboardNudge = ( isNaN(value) || ( value < 0 ) ? 0 : value );
			updateSliderNudge();
		}

		
		
		public function get offset():Number {
			return _offset;
		}

		
		
		public function set offset( value:Number ):void {
			var maxScroll:Number = this.maxScroll;
			if ( _slider ) _slider.position = ( maxScroll == 0 ? 0 : value / maxScroll );
		}

		
		
		public function get scrollable():Boolean {
			return ( scrollLength > pageLength );
		}

		
		
		public function get scrollLength():Number {
			if ( !_content ) return 0;
			var rect:Rectangle = _content.getBounds(_content);
			return ( _horizontal ? rect.right : rect.bottom );
		}

		
		
		public function get maxScroll():Number {
			// TODO: Test maxScroll for different values of scrollOrigin
			if ( !_content ) return 0;
			if ( !_scrollMask ) return 0;
			var origin:Point = ( _content.parent ? _scrollMask.globalToLocal(_content.parent.localToGlobal(_scrollOrigin)) : _scrollOrigin );
			return Math.max(0, scrollLength + ( _horizontal ? origin.x : origin.y ) - pageLength);
		}

		
		
		public function get pageLength():Number {
			return ( _scrollMask ? ( _horizontal ? _scrollMask.width : _scrollMask.height ) : 0 );
		}

		
		
		public function get liveUpdate():Boolean { 
			return ( _slider ? _slider.liveUpdate : false ); 
		}

		
		
		public function set liveUpdate( value:Boolean ):void { 
			if ( _slider ) _slider.liveUpdate = value; 
		}

		
		
		public function get position():Number { 
			return ( _slider ? _slider.position : 0 ); 
		}

		
		
		public function set position( value:Number ):void {
			if ( _slider ) _slider.position = value; 
		}

		
		
		public function get sliding():Boolean { 
			return ( _slider ? _slider.sliding : false ); 
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

		
		
		public function get onScrollEnabled():Dispatcher {
			return _onScrollEnabled;
		}

		
		
		public function get onScrollDisabled():Dispatcher {
			return _onScrollDisabled;
		}
	}
}
