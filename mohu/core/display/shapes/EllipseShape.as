package mohu.core.display.shapes {
	import flash.display.Shape;

	/**
	 * @author Tim Kendrick
	 */
	public class EllipseShape extends Shape {

		private var _width:Number;
		private var _height:Number;
		private var _colour:uint;

		public function EllipseShape( width:Number = 0 , height:Number = 0 , colour:uint = 0xFF000000 ) {
			super();
			
			_width = ( isNaN(width) ? 0 : width );
			_height = ( isNaN(height) ? 0 : height );
			_colour = colour;
			
			updateAppearance();
		}

		
		
		private function updateAppearance():void {
			graphics.clear();
			if ( !_width || !_height ) return;
			graphics.beginFill(_colour & 0x00FFFFFF, ( _colour >>> 24 ) / 0xFF);
			graphics.drawEllipse(0, 0, _width, _height);
			graphics.endFill();
		}

		
		
		override public function get width():Number {
			return _width;
		}

		
		
		override public function set width( value:Number ):void {
			_width = ( isNaN(value) ? 0 : value );
			updateAppearance();
		}

		
		
		override public function get height():Number {
			return _height;
		}

		
		
		override public function set height( value:Number ):void {
			_height = ( isNaN(value) ? 0 : value );
			updateAppearance();
		}

		
		
		public function get colour():uint {
			return _colour;
		}

		
		
		public function set colour(colour:uint):void {
			_colour = colour;
			updateAppearance();
		}
	}
}
