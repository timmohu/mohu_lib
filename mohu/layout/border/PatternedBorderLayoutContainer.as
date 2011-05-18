package mohu.layout.border {
	import mohu.layout.LayoutContainer;

	import flash.display.BitmapData;

	/**
	 * @author Tim Kendrick
	 */
	public class PatternedBorderLayoutContainer extends LayoutContainer {

		private var _borderPattern:BitmapData;
		private var _border:int;

		public function PatternedBorderLayoutContainer( borderPattern:BitmapData = null , border:int = 0 ) {
			_borderPattern = borderPattern;
			_border = border;

			super();
		}

		
		
		override public function render():void {
			super.render();
			if ( isNaN(_measuredWidth) || isNaN(_measuredHeight) ) return;
			graphics.clear();
			if ( !_borderPattern ) return;
			graphics.beginBitmapFill(_borderPattern);
			graphics.drawRect(0, 0, _measuredWidth - _border, _border);
			graphics.drawRect(_measuredWidth - _border, 0, _border, _measuredHeight - _border);
			graphics.drawRect(_border, _measuredHeight - _border, _measuredWidth - _border, _border);
			graphics.drawRect(0, _border, _border, _measuredHeight - _border);
			graphics.endFill();
		}

		
		
		public function get borderPattern( ):BitmapData {
			return _borderPattern;
		}

		
		
		public function set borderPattern( value:BitmapData ):void {
			_borderPattern = value;
			render();
		}

		
		
		public function get border( ):int {
			return _border;
		}

		
		
		public function set border( value:int ):void {
			_border = value;
			render();
		}
	}
}
