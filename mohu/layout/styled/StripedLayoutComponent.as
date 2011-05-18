package mohu.layout.styled {
	import mohu.layout.LayoutComponent;

	import flash.display.BitmapData;

	/**
	 * @author Tim Kendrick
	 */
	public class StripedLayoutComponent extends LayoutComponent {

		private var _stripePattern:BitmapData;
		private var _stripeSpacing:int;
		private var _backgroundColour:uint;
		private var _stripeColour:uint;
		private var _flipStripes:Boolean;

		public function StripedLayoutComponent( stripeSpacing:int = 3 , backgroundColour:uint = 0x7FCCCCCC , stripeColour:uint = 0xFFFFFFFF , flipStripes:Boolean = false ) {
			_stripeSpacing = stripeSpacing;
			_backgroundColour = backgroundColour;
			_stripeColour = stripeColour;
			_flipStripes = flipStripes;

			updateStripePattern();
			super();
		}

		
		
		override public function render():void {
			super.render();
			if ( isNaN(_measuredWidth) || isNaN(_measuredHeight) ) return;
			graphics.clear();
			graphics.lineStyle(0.5, 0x666666);
			graphics.beginBitmapFill(_stripePattern);
			graphics.drawRect(0, 0, _measuredWidth, _measuredHeight);
			graphics.endFill();
		}

		
		
		private function updateStripePattern():void {
			_stripePattern = getStripePattern(_stripeSpacing, _stripeColour, _backgroundColour, _flipStripes);
		}

		
		
		private function getStripePattern( stripeSpacing:int , stripeColour:uint , backgroundColour:uint , flipStripes:Boolean ):BitmapData {	
			var bitmapData:BitmapData = new BitmapData(stripeSpacing + 1, stripeSpacing + 1, true, backgroundColour);
			for ( var x:int = 0 ;x < stripeSpacing + 1 ;x++ ) bitmapData.setPixel32(x, flipStripes ? x : stripeSpacing - x, stripeColour);
			return bitmapData;
		}

		
		
		public function get stripeSpacing():int {
			return _stripeSpacing;
		}

		
		
		public function set stripeSpacing( value:int ):void {
			_stripeSpacing = value;
			updateStripePattern();
		}

		
		
		override public function get backgroundColour():uint {
			return _backgroundColour;
		}

		
		
		override public function set backgroundColour( value:uint ):void {
			_backgroundColour = value;
			updateStripePattern();
		}

		
		
		public function get stripeColour():uint {
			return _stripeColour;
		}

		
		
		public function set stripeColour( value:uint ):void {
			_stripeColour = value;
			updateStripePattern();
		}

		
		
		public function get flipStripes():Boolean {
			return _flipStripes;
		}

		
		
		public function set flipStripes( value:Boolean ):void {
			_flipStripes = value;
			updateStripePattern();
		}
	}
}
