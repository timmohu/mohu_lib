package mohu.core.display.effects {	import flash.display.DisplayObject;	import flash.display.Sprite;	public class LCDContainer extends Sprite {		private static const CONTENT:String = "content";		private var _lcd:LCD;		private var _content:DisplayObject;		public function LCDContainer(transparent:Boolean = true, smoothing:Boolean = false, pixelSnapping:String = "auto", backgroundColour:uint = 0x00000000) {			super();			_content = getChildByName(CONTENT);			_lcd = new LCD(content, transparent, smoothing, pixelSnapping, backgroundColour);			lcd.x = content.x;			lcd.y = content.y;			addChildAt(lcd, getChildIndex(content));			removeChild(content);		}						public function get lcd():LCD {			return _lcd;		}						public function get content():DisplayObject {			return _content;		}						public function redraw():void { 			lcd.redraw(); 		}						public function get source():DisplayObject { 			return lcd.source; 		}						public function get transparent():Boolean { 			return lcd.transparent; 		}						public function get backgroundColour():uint { 			return lcd.backgroundColour; 		}						public function set source(value:DisplayObject):void { 			lcd.source = value; 		}						public function set transparent(value:Boolean):void { 			lcd.transparent = value; 		}						public function set backgroundColour(value:uint):void { 			lcd.backgroundColour = value; 		}	}}