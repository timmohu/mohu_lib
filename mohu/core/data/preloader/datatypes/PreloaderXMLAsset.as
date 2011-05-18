package mohu.core.data.preloader.datatypes {
	import mohu.core.data.preloader.IPreloaderAsset;
	import mohu.messages.Dispatcher;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	/**
	 * @author Tim Kendrick
	 */

	public class PreloaderXMLAsset implements IPreloaderAsset {

		private var _url:URLRequest;
		private var _loader:URLLoader;
		private var _xml:XML;

		private var _onProgress:Dispatcher;
		private var _onComplete:Dispatcher;
		private var _onError:Dispatcher;

		public function PreloaderXMLAsset( url:URLRequest ) {
			_onProgress = new Dispatcher(this);
			_onComplete = new Dispatcher(this);
			_onError = new Dispatcher(this);
			
			_url = url;

			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.TEXT;

			_loader.addEventListener(Event.COMPLETE, handleComplete, false, 0, true);
			_loader.addEventListener(ProgressEvent.PROGRESS, handleProgress, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleError, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError, false, 0, true);
		}

		
		
		private function handleProgress( event:Event ):void {
			_onProgress.dispatch();
		}

		
		
		private function handleComplete( event:Event ):void {
			_xml = XML(_loader.data);
			_onComplete.dispatch();
		}

		
		
		private function handleError( event:Event ):void {
			_onError.dispatch();
		}

		
		
		public function load():void {
			_loader.load(_url);
		}

		
		
		public function get data():* {
			return _xml;
		}

		
		
		public function get url():URLRequest {
			return _url;
		}

		
		
		public function get bytesLoaded():int {
			return _loader.bytesLoaded;
		}

		
		
		public function get bytesTotal():int {
			return _loader.bytesTotal;
		}

		
		
		public function get progress():Number {
			return ( _loader.bytesLoaded / _loader.bytesTotal );
		}

		
		
		public function get xml():XML {
			return _xml;
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
