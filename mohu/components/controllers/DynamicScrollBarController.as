package mohu.components.controllers {
	import mohu.components.messages.NumberMessage;
	import mohu.components.interfaces.IButton;
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;

	/**
	 * @author Arthur Comben
	 * 
	 * handle and track should override their width and height setters if you want to have custom caps
	 * everything is based on the size of the mask and the size of the content so change those then render() to update
	 * do not stretch the mask by altering it's width and height, either redraw or override width/height setters for the mask
	 * 
	 */
	public class DynamicScrollBarController {

		private var _minHandleLength:Number = 50;
		private var _autoHideTrack:Boolean = false;		private var _autoHideHandle:Boolean = true;
		private var _handle:IButton;
		private var _track:IButton;
		private var _isHorizontal:Boolean;
		private var _content:DisplayObject;
		private var _scrollMask:DisplayObject;
		private var _position:Number;
		private var _scrollAvailable:Boolean = false;
		private var _onUpdateAvailableSize:Dispatcher;
		private var _maxAvailableSize:Number = 0;
		private var _offsetPx:Number;
		private var _scrollWheelNudge:Number = 10;
		private var _scrollWheelEnabled:Boolean = true;
		private var _trackOffset:Number = 0;
		private var _contentLength:Number;
		private var _viewableZoneLength:Number;
		private var _scrollableContentLength:Number;
		private var _onChangePosition:Dispatcher;

		public function DynamicScrollBarController( content:InteractiveObject, scrollMask:InteractiveObject, track:IButton, handle:IButton, isHorizontal:Boolean = false ) {
			if ( track && !( track.interactiveObject is InteractiveObject ) ) throw new ArgumentError("Specified track is not a InteractiveObject");
			if ( handle && !( handle.interactiveObject is InteractiveObject ) ) throw new ArgumentError("Specified handle is not a InteractiveObject");
			_onChangePosition = new Dispatcher(this);			_onUpdateAvailableSize = new Dispatcher(this);
			_content = content;
			_scrollMask = scrollMask;
			_content.mask = _scrollMask;
			_track = track;
			_handle = handle;
			_isHorizontal = isHorizontal;
			_position = 0;
			_handle.onPress.addListener(handlePressHandle);			_handle.onRelease.addListener(handlePressRelease);			_handle.onReleaseOutside.addListener(handlePressRelease);
			_track.onPress.addListener(handlePressTrack);
			if(_scrollWheelEnabled) _content.addEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel, false, 0, true);
			render();
		}

		
		
		private function handlePressTrack( message:Message ):void {
			var track:InteractiveObject = _track.interactiveObject as InteractiveObject;
			var handle:DisplayObject = _handle.interactiveObject as DisplayObject;
			var pageRatio:Number;
			if( _isHorizontal ) {
				pageRatio = (track.width - _trackOffset) / _content.getBounds(_content).right;
				if( track.mouseX < handle.x ) {
					nudge(-pageRatio);
				} else {
					nudge(pageRatio);
				}
			} else {
				pageRatio = (track.height - _trackOffset) / _content.getBounds(_content).bottom;
				if( track.mouseY < handle.y ) {
					nudge(-pageRatio);
				} else {
					nudge(pageRatio);
				}
			}
		}

		
		
		private function nudge( n:Number ):void {
			position = Math.max(0, Math.min(1, n + position));
		}

		
		
		private function handlePressRelease( message:Message ):void {
			handleMouseMove(null);
			var handle:DisplayObject = _handle.interactiveObject as DisplayObject;
			handle.stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}

		
		
		private function handlePressHandle( message:Message ):void {
			var handle:DisplayObject = _handle.interactiveObject as DisplayObject;
			_offsetPx = _isHorizontal ? handle.mouseX : handle.mouseY;
			handle.stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove, false, 0, true);
		}

		
		
		private function handleMouseMove(event:MouseEvent):void {
			var track:InteractiveObject = _track.interactiveObject as InteractiveObject;			var handle:InteractiveObject = _handle.interactiveObject as InteractiveObject;
			position = Math.max(0, Math.min(1, _isHorizontal ? ( track.mouseX - _offsetPx ) / (track.width - handle.width - _trackOffset) : ( track.mouseY - _offsetPx ) / (track.height - handle.height - _trackOffset)));
			if ( event ) event.updateAfterEvent();
		}

		
		
		public function render():void {
			var handle:InteractiveObject = _handle.interactiveObject;			var track:InteractiveObject = _track.interactiveObject;
			_contentLength = _isHorizontal ? (_content.width > 0 ? _content.getBounds(_content).right : 0 ) : ( _content.height > 0 ? _content.getBounds(_content).bottom : 0 );
			_viewableZoneLength = _isHorizontal ? _scrollMask.width - _trackOffset : _scrollMask.height - _trackOffset;
			if( _viewableZoneLength == 0 ) return;
			_isHorizontal ? track.width = _viewableZoneLength : track.height = _viewableZoneLength;
			_scrollableContentLength = Math.max(0, _contentLength - _viewableZoneLength);
			var handleLengthRatio:Number = Math.min(1, Math.max(0, _minHandleLength != -1 ? Math.max(_minHandleLength / _viewableZoneLength, _viewableZoneLength / _contentLength) : _viewableZoneLength / _contentLength));
			var handleLength:Number = _viewableZoneLength * handleLengthRatio;
			_isHorizontal ? handle.width = handleLength : handle.height = handleLength;			var scrollAvailable:Boolean = _scrollableContentLength > 0;
			if( _isHorizontal ) {
				handle.y = Math.ceil(_scrollMask.height - track.height / 2 - handle.height / 2);				track.y = Math.ceil(_scrollMask.height - track.height);
			} else {
				handle.x = int(_scrollMask.width - track.width / 2 - handle.width / 2);
				track.x = _scrollMask.width - track.width;
			}
			if( scrollAvailable ) {
				handle.mouseEnabled = true;				track.mouseEnabled = true;
				track.visible = true;
				handle.visible = true;
			} else {
				handle.mouseEnabled = false;
				track.mouseEnabled = false;
				if( _autoHideTrack ) {
					track.visible = false;
				} else {
					track.visible = true;
				}
				if( _autoHideHandle ) {
					handle.visible = false;
				} else {
					handle.visible = true;
				}
			}
			var lastMax:Number = _maxAvailableSize;
			if( track.visible ) {
				_maxAvailableSize = _isHorizontal ? _scrollMask.height - track.height - _trackOffset : _scrollMask.width - track.width - _trackOffset;
			} else {
				_maxAvailableSize = _isHorizontal ? _scrollMask.height - _trackOffset : _scrollMask.width - _trackOffset;
			}
			
			if( lastMax != _maxAvailableSize ) _onUpdateAvailableSize.dispatch();
			if( _scrollAvailable != scrollAvailable ) {
				_onUpdateAvailableSize.dispatch();
				_scrollAvailable = scrollAvailable;
			}
			
			var trackPosition:Number = trackLength * _position;
			if ( _isHorizontal ) {
				handle.x = track.x + trackPosition;
			} else {
				handle.y = track.y + trackPosition;
			}
			_isHorizontal ? _content.x = -_position * _scrollableContentLength : _content.y = -_position * _scrollableContentLength;
		}

		
		
		private function get trackLength():Number {
			return _isHorizontal ? ( _track.interactiveObject as DisplayObject ).width - handleLength : ( _track.interactiveObject as DisplayObject ).height - handleLength;
		}

		
		
		private function get handleLength():Number {
			return _isHorizontal ? ( _handle.interactiveObject as DisplayObject ).width : ( _handle.interactiveObject as DisplayObject ).height;
		}

		
		
		public function set minHandleLength(minHandleLength:Number):void {
			_minHandleLength = minHandleLength;
		}

		
		
		public function get position():Number {
			return _position;
		}

		
		
		public function set position(position:Number):void {
			_position = Math.min(1, Math.max(0, position));
			_onChangePosition.dispatch(new NumberMessage(_position));
			render();
		}

		
		
		public function set autoHideTrack(autoHideTrack:Boolean):void {
			_autoHideTrack = autoHideTrack;
			render();
		}

		
		
		public function set autoHideHandle(autoHideHandle:Boolean):void {
			_autoHideHandle = autoHideHandle;			render();
		}

		
		
		public function get autoHideTrack():Boolean {
			return _autoHideTrack;
		}

		
		
		public function get autoHideHandle():Boolean {
			return _autoHideHandle;
		}

		
		
		public function get onUpdateAvailableSize():Dispatcher {
			return _onUpdateAvailableSize;
		}

		
		
		public function get maxAvailableSize():Number {
			return _maxAvailableSize;
		}

		
		
		private function onScrollWheel( event:MouseEvent ):void {
			var n:Number = event.delta * _scrollWheelNudge / (_isHorizontal ? _content.getBounds(_content).right : _content.getBounds(_content).bottom);
			position = Math.min(1, Math.max(0, position - n));
		}

		
		
		public function get scrollWheelNudge():Number {
			return _scrollWheelNudge;
		}

		
		
		public function set scrollWheelNudge(scrollWheelNudge:Number):void {
			_scrollWheelNudge = scrollWheelNudge;
		}

		
		
		public function get scrollWheelEnabled():Boolean {
			return _scrollWheelEnabled;
		}

		
		
		public function set scrollWheelEnabled(scrollWheelEnabled:Boolean):void {
			if( scrollWheelEnabled && !_scrollWheelEnabled ) _content.addEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel, false, 0, true);
			if( !scrollWheelEnabled && _scrollWheelEnabled) _content.removeEventListener(MouseEvent.MOUSE_WHEEL, onScrollWheel, false);
			_scrollWheelEnabled = scrollWheelEnabled;
		}

		
		
		public function get scrollBarVisible():Boolean {
			return (_track.interactiveObject as DisplayObject ).visible;
		}

		
		
		public function get trackOffset():Number {
			return _trackOffset;
		}

		
		
		public function set trackOffset(trackOffset:Number):void {
			_trackOffset = trackOffset;
			render();
		}

		
		
		public function get contentLength():Number {
			return _contentLength;
		}

		
		
		public function get maskLength():Number {
			return _viewableZoneLength;
		}

		
		
		public function get scrollableContentLength():Number {
			return _scrollableContentLength;
		}

		
		
		public function get viewableZoneLength():Number {
			return _viewableZoneLength;
		}

		
		
		public function get onChangePosition():Dispatcher {
			return _onChangePosition;
		}
	}
}
