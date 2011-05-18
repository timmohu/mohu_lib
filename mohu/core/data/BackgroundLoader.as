package mohu.core.data {
	import mohu.messages.Dispatcher;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Tim Kendrick
	 */
	public class BackgroundLoader {

		private var _loader:URLLoader;
		private var _queue:Vector.<URLRequest>;

		private var _paused:Boolean;		
		private var _currentItem:URLRequest;

		private var _onLoadItem:Dispatcher;
		private var _onComplete:Dispatcher;
		private var _onLoadError:Dispatcher;

		public function BackgroundLoader( ):void {
			_onLoadItem = new Dispatcher(this);
			_onComplete = new Dispatcher(this);
			_onLoadError = new Dispatcher(this);
			
			_queue = new Vector.<URLRequest>();
			
			_loader = new URLLoader();
			
			_loader.addEventListener(Event.COMPLETE, onCompleteLoad, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleLoadError, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError, false, 0, true);
		}

		
		
		public function load( url:URLRequest ):void {	
			_queue.push(url);
			if ( !_currentItem ) {
				_currentItem = _queue.shift();
				if ( !_paused ) _loader.load(_currentItem);
			}
		}

		
		
		public function stop():void {
			if ( !_currentItem ) return;
			_loader.close();
			_currentItem = null;
			_queue.length = 0;
		}

		
		
		private function onCompleteLoad( event:Event ):void {
			_onLoadItem.dispatch();
			if ( _queue.length == 0 ) {
				_currentItem = null;
				_onComplete.dispatch();
			} else {
				_currentItem = _queue.shift();
				if ( !_paused ) _loader.load(_currentItem);
			}
		}

		
		
		private function handleLoadError( event:ErrorEvent ):void {
			_onLoadError.dispatch();
		}

		
		
		public function get loading():Boolean {
			return ( _currentItem != null );
		}

		
		
		public function get paused():Boolean {
			return _paused;
		}

		
		
		public function set paused( value:Boolean ):void {
			if ( _paused == value ) return;
			_paused = value;
			if ( !_currentItem ) return;
			if ( _paused ) _loader.close(); else _loader.load(_currentItem); 
		}

		
		
		public function get onLoadItem():Dispatcher {
			return _onLoadItem;
		}

		
		
		public function get onComplete():Dispatcher {
			return _onComplete;
		}

		
		
		public function get onLoadError():Dispatcher {
			return _onLoadError;
		}
	}
}
