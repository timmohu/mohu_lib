package mohu.layout.styled {
	import mohu.layout.LayoutContainer;

	import flash.display.GradientType;
	import flash.geom.Matrix;

	/**
	 * @author Arthur Comben
	 */
	public class GradientLayoutContainer extends LayoutContainer {

		private var _colours:Array;		private var _alphas:Array;		private var _ratios:Array;
		private var _isHorizontal:Boolean;

		public function GradientLayoutContainer( isHorizontal:Boolean = false ) {
			_colours = [0xffffffff,0xff111111];
			_alphas = [1,1];
			_ratios = [0, 255];
			_isHorizontal = isHorizontal;
			super();
		}

		
		
		override public function render():void {
			super.render();
			graphics.clear();
			if ( isNaN(_measuredWidth) || isNaN(_measuredHeight) ) return;
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(_isHorizontal ? _measuredWidth : _measuredHeight, _isHorizontal ? _measuredHeight : _measuredWidth);
			if( !_isHorizontal ) matrix.rotate(Math.PI * .5);
			graphics.beginGradientFill(GradientType.LINEAR, _colours, _alphas, _ratios, matrix);
			graphics.drawRect(0, 0, _measuredWidth, _measuredHeight);
			graphics.endFill();
		}

		
		
		public function get colours():Array {
			return _colours;
		}

		
		
		public function set colours(colours:Array):void {
			_colours = colours;
			render();
		}

		
		
		public function get isHorizontal():Boolean {
			return _isHorizontal;
		}

		
		
		public function set isHorizontal(isHorizontal:Boolean):void {
			_isHorizontal = isHorizontal;
			render();
		}

		
		
		public function get alphas():Array {
			return _alphas;
		}

		
		
		public function set alphas(alphas:Array):void {
			_alphas = alphas;
			render();
		}

		
		
		public function get ratios():Array {
			return _ratios;
		}

		
		
		public function set ratios(ratios:Array):void {
			_ratios = ratios;
			render();
		}
	}
}
