package mohu.core.data.preloader.datatypes {
	import mohu.core.data.preloader.IPreloaderAsset;
	import mohu.messages.Dispatcher;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;

	/**
	 * @author Tim Kendrick
	 */

	public class PreloaderBitmapAsset implements IPreloaderAsset {

		private var _url:URLRequest;
		private var _loader:Loader;

		private var _onProgress:Dispatcher;
		private var _onComplete:Dispatcher;
		private var _onError:Dispatcher;

		public function PreloaderBitmapAsset( url:URLRequest ) {
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
			_loader.load(_url);
		}

		
		
		public function get data():* {
			return ( _loader.content as Bitmap ).bitmapData;
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

		
		
		public function get bitmapData():BitmapData {
			return ( _loader.content as Bitmap ).bitmapData;
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
