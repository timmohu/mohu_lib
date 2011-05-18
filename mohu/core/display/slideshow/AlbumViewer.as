package mohu.core.display.slideshow {
	import mohu.messages.Dispatcher;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	/**
	 * @author Tim Kendrick
	 */
	public class AlbumViewer extends Sprite {

		private var _images:Vector.<URLRequest>;
		private var _loader:Loader;
		private var _currentImage:DisplayObject;

		private var _selectedIndex:int;
		private var _reverseTransition:Boolean;

		private var _loading:Boolean;

		private var _onLoadStart:Dispatcher;
		private var _onLoadComplete:Dispatcher;
		private var _onLoadFail:Dispatcher;

		public function AlbumViewer() {
			super();
			
			_onLoadStart = new Dispatcher(this);
			_onLoadComplete = new Dispatcher(this);
			_onLoadFail = new Dispatcher(this);
			
			_images = new Vector.<URLRequest>();
			
			_selectedIndex = -1;
			
			_loader = new Loader();
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleLoadError, false, 0, true);
		}

		
		
		private function handleLoadComplete( event:Event ):void {
			var oldImage:DisplayObject = _currentImage;
			_currentImage = _loader.content;
			_loading = false;
			_onLoadComplete.dispatch();
			if ( oldImage ) swapImages(oldImage, _currentImage, _reverseTransition); else showImage(_currentImage);
		}

		
		
		private function handleLoadError( event:IOErrorEvent ):void {
			_loading = false;
			_onLoadFail.dispatch();
		}

		
		
		protected function showImage( newImage:DisplayObject ):void {
			addChild(newImage);
		}

		
		
		protected function hideImage( oldImage:DisplayObject ):void {
			removeChild(oldImage);
		}

		
		
		protected function swapImages( oldImage:DisplayObject , newImage:DisplayObject , reverse:Boolean ):void {
			reverse;
			addChild(newImage);
			removeChild(oldImage);
		}

		
		
		public function get images():Vector.<URLRequest> {
			return _images;
		}

		
		
		public function set images( value:Vector.<URLRequest> ):void {
			if ( _images == value ) return;
			selectedIndex = -1;
			_images = value;
			if  ( value && ( value.length > 0 ) ) selectedIndex = 0;
		}

		
		
		public function get numImages( ):int {
			return _images.length;
		}

		
		
		public function get selectedIndex():int {
			return _selectedIndex;
		}

		
		
		public function set selectedIndex( value:int ):void {
			if ( _selectedIndex == value ) return;
			if ( ( value < -1 ) || ( value > _images.length - 1 ) ) throw new RangeError("Specified index " + value + " is out of range (max value: " + ( _images.length - 1 ) + ")");
			_reverseTransition = ( value < _selectedIndex );
			_selectedIndex = value;
			if ( _selectedIndex == -1 ) {
				_loader.unload();
				hideImage(_currentImage);
				return;
			}
			_loading = true;
			_onLoadStart.dispatch();
			_loader.load(_images[ _selectedIndex ], new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
		}

		
		
		public function get loading():Boolean {
			return _loading;
		}

		
		
		public function get onLoadStart():Dispatcher {
			return _onLoadStart;
		}

		
		
		public function get onLoadComplete():Dispatcher {
			return _onLoadComplete;
		}

		
		
		public function get onLoadFail():Dispatcher {
			return _onLoadFail;
		}
	}
}
