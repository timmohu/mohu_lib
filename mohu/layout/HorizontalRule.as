package mohu.layout {

	/**
	 * @author Tim Kendrick
	 */
	public class HorizontalRule extends LayoutComponent {

		private var _colour:uint = 0xFF000000;

		public function HorizontalRule() {
			super();
			relativeWidth = 1;
			absoluteHeight = 1;
		}

		
		
		override public function render():void {
			super.render();
			if ( isNaN(_measuredWidth) || isNaN(_measuredHeight) ) return;
			graphics.clear();
			graphics.beginFill(_colour & 0x00FFFFFF, ( _colour >>> 24 ) / 0xFF);
			graphics.drawRect(0, 0, _measuredWidth, _measuredHeight);
			graphics.endFill();
		}

		
		
		public function get colour():uint {
			return _colour;
		}

		
		
		public function set colour( value:uint ):void {
			_colour = value;
			render();
		}
	}
}
