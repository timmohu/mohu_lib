package mohu.core.geom {
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * @author Tim Kendrick
	 */
	public class TransformMatrix extends Matrix {

		
		public function TransformMatrix(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 1, tx:Number = 0, ty:Number = 0) {
			super(a, b, c, d, tx, ty);
		}

		
		
		public function skew(x:Number, y:Number):void {
			concat(new Matrix(1, y, x, 1, 0, 0));
		}

		
		
		override public function clone():Matrix {
			return new TransformMatrix(a, b, c, d, tx, ty);
		}

		
		
		public function get scaleX():Number {
			return Math.sqrt(a * a + b * b);
		}

		
		
		public function get scaleY():Number {
			return Math.sqrt(c * c + d * d);
		}

		
		
		public function set scaleX(value:Number):void {
			scale(value / scaleX, 1);
		}

		
		
		public function set scaleY(value:Number):void {
			scale(1, value / scaleY);
		}

		
		
		public function get skewX():Number {
			var p:Point = deltaTransformPoint(new Point(0, 1));
			return Math.atan2(p.y, p.x) - Math.PI / 2;
		}

		
		
		public function get skewY():Number {
			var p:Point = deltaTransformPoint(new Point(1, 0));
			return Math.atan2(p.y, p.x);
		}

		
		
		public function set skewX(value:Number):void {
			skew(value - skewX, 0);
		}

		
		
		public function set skewY(value:Number):void {
			skew(value - skewX, 0);
		}

		
		
		public function get rotation():Number {
			return skewY;
		}

		
		
		public function set rotation(value:Number):void {
			rotate(value - skewX);
		}
	}
}
