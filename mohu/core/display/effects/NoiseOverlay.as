package mohu.core.display.effects {	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.BitmapDataChannel;	import flash.display.PixelSnapping;	public class NoiseOverlay extends Bitmap {		private var _scale:Number;		public function NoiseOverlay( width:uint, height:uint, alpha:Number = 0.1, scale:Number = 2, blendMode:String = "overlay" ) {			super(getNoise(width, height, scale), PixelSnapping.AUTO, true);			width = width;			height = height;			alpha = alpha;			blendMode = blendMode;		}						public function redraw():void {			drawNoise(bitmapData);		}						private function getNoise( width:Number, height:Number, scale:Number ):BitmapData {			var bd:BitmapData = new BitmapData(width / scale, height / scale, false);			drawNoise(bd);			return bd;		}						private function drawNoise( bd:BitmapData ):void {			bd.lock();			bd.noise(Math.round(Math.random() * int.MAX_VALUE), 0, 255, BitmapDataChannel.RED | BitmapDataChannel.GREEN | BitmapDataChannel.BLUE, true);			bd.unlock();		}						public function get scale():Number {			return _scale;		}						public function set scale( value:Number ):void {			_scale = value;			var old:BitmapData = bitmapData;			bitmapData = getNoise(width / scaleX, height / scaleY, scale);			old.dispose();		}	}}