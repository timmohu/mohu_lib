package mohu.layout {
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * @author Tim Kendrick
	 */
	public class ImageLoaderComponent extends LayoutComponent {

		private var _loader:Loader;
		private var _source:String;

		public function ImageLoaderComponent() {
			super();
			
			_loader = new Loader();
			
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoad, false, 0, true);
		}

		
		
		private function onCompleteLoad( event:Event ):void {
			updateWidth();
			updateHeight();
			render();
		}

		
		override public function render():void {
			super.render();
			if ( _loader.content ) {
				if ( !isNaN(relativeWidth) || !isNaN(absoluteWidth) ) _loader.content.width = _measuredWidth; else _loader.content.scaleX = 1;
				if ( !isNaN(relativeHeight) || !isNaN(absoluteHeight) ) _loader.content.height = _measuredHeight; else _loader.content.scaleY = 1;
			}
		}

		
		
		public function get source( ):String {
			return _source;
		}

		
		
		public function set source( value:String ):void {
			if ( _source == value ) return;
			_source = value;
			if ( _source ) {
				addChild(_loader);
				_loader.load(new URLRequest(value));
			} else {
				_loader.unload();
				if ( _loader.parent == this ) removeChild(_loader);
			}
		}
	}
}
