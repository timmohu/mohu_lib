package mohu.core.data.preloader {
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.errors.IllegalOperationError;

	public class Preloader {

		private var _assets:Vector.<IPreloaderAsset>;
		private var _currentAssetIndex:int;
		private var _loading:Boolean;
		private var _progress:Number;

		private var _onProgress:Dispatcher;
		private var _onLoadAsset:Object;
		private var _onComplete:Dispatcher;
		private var _onError:Object;

		public function Preloader() {
			super();
			
			_assets = new Vector.<IPreloaderAsset>();
			_currentAssetIndex = -1;
			
			_onProgress = new Dispatcher(this);
			_onLoadAsset = new Dispatcher(this);
			_onComplete = new Dispatcher(this);
			_onError = new Dispatcher(this);
		}

		
		
		public function load( assets:Array ):void {
			if ( _loading ) throw new IllegalOperationError("Preloader is already loading");
			for each (var asset : IPreloaderAsset in assets) if ( _assets.indexOf(asset) == -1 ) _assets.push(asset);
			_progress = 0;
			_loading = true;
			loadNextItem();
		}	

		
		
		private function loadNextItem( ):void {
			if (_currentAssetIndex == _assets.length - 1) {
				_assets.length = 0;
				_currentAssetIndex = -1;
				_loading = false;
				_onComplete.dispatch();
				return;
			}
			var asset:IPreloaderAsset = _assets[ ++_currentAssetIndex ];
			asset.onProgress.addListener(handleAssetProgress);
			asset.onComplete.addListener(handleAssetComplete);
			asset.onError.addListener(handleAssetError);
			asset.load();
		}

		
		
		private function handleAssetProgress( message:Message ):void {
			_progress = ( _currentAssetIndex + ( message.currentTarget as IPreloaderAsset ).progress) / ( _assets.length ) ;
			_onProgress.dispatch();
		}

		
		
		private function handleAssetError( message:Message ):void {
			_onError.dispatch();
		}

		
		
		private function handleAssetComplete( message:Message ):void {
			var asset:IPreloaderAsset = message.currentTarget as IPreloaderAsset;
			asset.onProgress.removeListener(handleAssetProgress);
			asset.onComplete.removeListener(handleAssetComplete);
			asset.onError.removeListener(handleAssetError);

			_onLoadAsset.dispatch();
			
			_progress = ( _currentAssetIndex + 1 / ( _assets.length ) );
			
			loadNextItem();
		}

		
		
		public function get loading():Boolean {
			return _loading;
		}

		
		
		public function get progress( ):Number {
			return _progress;
		}

		
		
		public function get onProgress():Dispatcher {
			return _onProgress;
		}

		
		
		public function get onComplete():Dispatcher {
			return _onComplete;
		}

		
		
		public function get onLoadAsset():Object {
			return _onLoadAsset;
		}

		
		
		public function get onError():Object {
			return _onError;
		}	
	}
}