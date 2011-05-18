package mohu.core.data.preloader.datatypes {
	import mohu.core.data.preloader.IPreloaderAsset;
	import mohu.messages.Dispatcher;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	/**
	 * @author Tim Kendrick
	 */
	public class PreloaderSpriteAsset implements IPreloaderAsset {

		private var _url:URLRequest;
		private var _loader:Loader;
		private var _onProgress:Dispatcher;
		private var _onComplete:Dispatcher;
		private var _onError:Dispatcher;

		public function PreloaderSpriteAsset( url:URLRequest ) {
			_onProgress = new Dispatcher(this);
			_onComplete = new Dispatcher(this);
			_onError = new Dispatcher(this);
			
			_url = url;

			_loader = new Loader();

			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleProgress, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete, false, 0, true);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleError, false, 0, true);
		}

		
		
		private function handleProgress( event:Event ):void {
			_onProgress.dispatch();
		}

		
		
		private function handleComplete( event:Event ):void {
			_onComplete.dispatch();
		}

		
		
		private function handleError( event:Event ):void {
			_onError.dispatch();
		}

		
		
		public function load():void {
			_loader.load(_url, new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
		}

		
		
		public function get data():* {
			return _loader.content;
		}

		
		
		public function get url():URLRequest {
			return _url;
		}

		
		
		public function get bytesLoaded():int {
			return _loader.contentLoaderInfo.bytesLoaded;
		}

		
		
		public function get bytesTotal():int {
			return _loader.contentLoaderInfo.bytesTotal;
		}

		
		
		public function get progress():Number {
			return ( _loader.contentLoaderInfo.bytesLoaded / _loader.contentLoaderInfo.bytesTotal );
		}

		
		
		public function get sprite():Sprite {
			return _loader.content as Sprite;
		}

		
		
		public function get onProgress():Dispatcher {
			return _onProgress;
		}

		
		
		public function get onComplete():Dispatcher {
			return _onComplete;
		}

		
		
		public function get onError():Dispatcher {
			return _onError;
		}
	}
}
