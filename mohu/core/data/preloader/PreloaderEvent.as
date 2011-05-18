package mohu.core.data.preloader {
	import flash.events.Event;

	public class PreloaderEvent extends Event {

		public static const PRELOADER_PROGRESS:String = "PRELOADER_PROGRESS";
		public static const PRELOADER_ASSET_LOADED:String = "PRELOADER_ASSET_LOADED";
		public static const PRELOADER_LOAD_COMPLETE:String = "PRELOADER_LOAD_COMPLETE";

		public var asset:IPreloaderAsset;
		public var progress:Number;

		public function PreloaderEvent(type:String, asset:IPreloaderAsset , progress:Number ) {
			super(type);
			this.asset = asset;
			this.progress = progress;
		}

		
		
		override public function clone():Event {
			return new PreloaderEvent(type, asset, progress);
		}
	}
}