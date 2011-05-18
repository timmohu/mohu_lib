package mohu.layout {
	import mohu.core.display.text.AdvancedTextFormat;
	import mohu.core.display.text.StyledTextField;

	import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Tim Kendrick
	 */
	public class TextLayoutComponent extends LayoutComponent {

		private static const HORIZONTAL_ALIGN_ALLOWED_VALUES:Array = [HorizontalAlign.LEFT , HorizontalAlign.CENTRE , HorizontalAlign.RIGHT];
		private static const VERTICAL_ALIGN_ALLOWED_VALUES:Array = [VerticalAlign.TOP , VerticalAlign.MIDDLE , VerticalAlign.BOTTOM];

		private var _textField:StyledTextField;
		private var _horizontalAlign:String;
		private var _verticalAlign:String;
		private var _textFormat:TextFormat;
		private var _paddingLeft:Number;
		private var _paddingRight:Number;
		private var _paddingTop:Number;
		private var _paddingBottom:Number;

		public function TextLayoutComponent() {
			super();
			
			_paddingLeft = 0;
			_paddingRight = 0;
			_paddingTop = 0;
			_paddingBottom = 0;
			
			_horizontalAlign = HorizontalAlign.LEFT;
			_verticalAlign = VerticalAlign.TOP;

			_textField = new StyledTextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			
			_textField.addEventListener(Event.CHANGE, onChange, false, 0, true);
			addChild(_textField);
		}

		
		
		private function onChange(event:Event):void {
			updateWidth();
			updateHeight();
			render();
		}

		
		
		public function get horizontalAlign():String {
			return _horizontalAlign;
		}

		
		
		public function set horizontalAlign( value:String ):void {
			if ( HORIZONTAL_ALIGN_ALLOWED_VALUES.indexOf(value) == -1 ) throw new ArgumentError("Specified horizontalAlign '" + value + "' is not valid ( allowed values : " + HORIZONTAL_ALIGN_ALLOWED_VALUES.join(", ") + " )");
			_horizontalAlign = value;
			render();
		}

		
		
		public function get verticalAlign():String {
			return _verticalAlign;
		}

		
		
		public function set verticalAlign( value:String ):void {
			if ( VERTICAL_ALIGN_ALLOWED_VALUES.indexOf(value) == -1 ) throw new ArgumentError("Specified verticalAlign '" + value + "' is not valid ( allowed values : " + VERTICAL_ALIGN_ALLOWED_VALUES.join(", ") + " )");
			_verticalAlign = value;
			render();
		}

		
		
		public function get textFormat():TextFormat {
			return _textFormat;
		}

		
		
		public function set textFormat( value:TextFormat ):void {
			_textFormat = value;
			if ( _textFormat is AdvancedTextFormat ) {
				( _textFormat as AdvancedTextFormat ).apply(_textField);
			} else {
				_textField.setTextFormat(value);
				_textField.defaultTextFormat = value;
			}
		}

		
		
		
		
		public function get styleSheet():StyleSheet { 
			return _textField.styleSheet; 
		}

		
		
		public function set styleSheet( value:StyleSheet ):void { 
			_textField.styleSheet = value;
		}

		
		
		public function get styleSheetClass( ):String {
			return _textField.styleSheetClass;
		}

		
		
		public function set styleSheetClass( value:String ):void {
			_textField.styleSheetClass = value;
		}

		protected function renderComputeVerticalAlign():void {
			switch ( _verticalAlign ) {
				case VerticalAlign.MIDDLE:
					y += ( _measuredHeight - _textField.height ) / 2;
					break;
				case TextFieldAutoSize.RIGHT:
					y += _measuredHeight - _textField.height;
					break;
			}
		}

		override public function render():void {
			_textField.x = _paddingLeft;
			_textField.y = _paddingTop;
			if ( !isNaN(absoluteWidth) || !isNaN(relativeWidth) ) _textField.width = _measuredWidth - _paddingLeft - _paddingRight;
			
			var x:Number = _measuredX;
			var y:Number = _measuredY;
			switch ( _horizontalAlign ) {
				case HorizontalAlign.CENTRE:
					x += ( _measuredWidth - _textField.width ) / 2;
					break;
				case HorizontalAlign.RIGHT:
					x += _measuredWidth - _textField.width;
					break;
			}
			renderComputeVerticalAlign();
			if ( pixelSnap ) {
				x = Math.round(x);
				y = Math.round(y);
			}
			if ( this.x != x ) this.x = x;
			if ( this.y != y ) this.y = y;
			graphics.clear();
			var backgroundColour:uint = this.backgroundColour;
			if ( !backgroundColour ) return;
			graphics.beginFill(backgroundColour & 0x00FFFFFF, ( backgroundColour >>> 24 ) / 0xFF);
			graphics.drawRect(0, 0, _measuredWidth, _measuredHeight);
			graphics.endFill();
		}

		
		
		override public function get contentWidth( ):Number {
			return _paddingLeft + _textField.width + _paddingRight;
		}

		
		
		override public function get contentHeight( ):Number {
			return _paddingTop + _textField.height + _paddingBottom;
		}

		
		
		public function get textField():StyledTextField {
			return _textField;
		}

		
		
		public function set text( value:String ):void {
			_textField.text = value;
			updateWidth();
			updateHeight();
			render();
		}

		
		
		
		public function get htmlText():String { 
			return _textField.htmlText; 
		}

		
		public function set htmlText( value:String ):void { 
			_textField.htmlText = value;
			updateWidth();
			updateHeight();
			render();
		}

		
		
		public function get alwaysShowSelection():Boolean { 
			return _textField.alwaysShowSelection; 
		}

		
		
		public function set alwaysShowSelection(value:Boolean):void { 
			_textField.alwaysShowSelection = value; 
		}

		
		
		public function get antiAliasType():String { 
			return _textField.antiAliasType; 
		}

		
		
		public function set antiAliasType(antiAliasType:String):void { 
			_textField.antiAliasType = antiAliasType; 
		}

		
		
		public function get background():Boolean { 
			return _textField.background; 
		}

		
		
		public function set background(value:Boolean):void { 
			_textField.background = value; 
		}

		
		
		public function get backgroundColor():uint { 
			return _textField.backgroundColor; 
		}

		
		
		public function set backgroundColor(value:uint):void { 
			_textField.backgroundColor = value; 
		}

		
		
		public function get border():Boolean { 
			return _textField.border; 
		}

		
		
		public function set border(value:Boolean):void { 
			_textField.border = value; 
		}

		
		
		public function get borderColor():uint { 
			return _textField.borderColor; 
		}

		
		
		public function set borderColor(value:uint):void { 
			_textField.borderColor = value; 
		}

		
		
		public function get bottomScrollV():int { 
			return _textField.bottomScrollV; 
		}

		
		
		public function get caretIndex():int { 
			return _textField.caretIndex; 
		}

		
		
		public function get condenseWhite():Boolean { 
			return _textField.condenseWhite; 
		}

		
		
		public function set condenseWhite(value:Boolean):void { 
			_textField.condenseWhite = value; 
		}

		
		
		public function get defaultTextFormat():TextFormat { 
			return _textField.defaultTextFormat; 
		}

		
		
		public function set defaultTextFormat(format:TextFormat):void { 
			_textField.defaultTextFormat = format; 
		}

		
		
		public function get displayAsPassword():Boolean { 
			return _textField.displayAsPassword; 
		}

		
		
		public function set displayAsPassword(value:Boolean):void { 
			_textField.displayAsPassword = value; 
		}

		
		
		public function get embedFonts():Boolean { 
			return _textField.embedFonts; 
		}

		
		
		public function set embedFonts(value:Boolean):void { 
			_textField.embedFonts = value; 
		}

		
		
		public function get gridFitType():String { 
			return _textField.gridFitType; 
		}

		
		
		public function set gridFitType(gridFitType:String):void { 
			_textField.gridFitType = gridFitType; 
		}

		
		
		public function get length():int { 
			return _textField.length; 
		}

		
		
		public function get maxChars():int { 
			return _textField.maxChars; 
		}

		
		
		public function set maxChars(value:int):void { 
			_textField.maxChars = value; 
		}

		
		
		public function get maxScrollH():int { 
			return _textField.maxScrollH; 
		}

		
		
		public function get maxScrollV():int { 
			return _textField.maxScrollV; 
		}

		
		
		public function get mouseWheelEnabled():Boolean { 
			return _textField.mouseWheelEnabled; 
		}

		
		
		public function set mouseWheelEnabled(value:Boolean):void { 
			_textField.mouseWheelEnabled = value; 
		}

		
		
		public function get multiline():Boolean { 
			return _textField.multiline; 
		}

		
		
		public function set multiline(value:Boolean):void { 
			_textField.multiline = value; 
		}

		
		
		public function get numLines():int { 
			return _textField.numLines; 
		}

		
		
		public function get restrict():String { 
			return _textField.restrict; 
		}

		
		
		public function set restrict(value:String):void { 
			_textField.restrict = value; 
		}

		
		
		public function get scrollH():int { 
			return _textField.scrollH; 
		}

		
		
		public function set scrollH(value:int):void { 
			_textField.scrollH = value; 
		}

		
		
		public function get scrollV():int { 
			return _textField.scrollV; 
		}

		
		
		public function set scrollV(value:int):void { 
			_textField.scrollV = value; 
		}

		
		
		public function get selectable():Boolean { 
			return _textField.selectable; 
		}

		
		
		public function set selectable(value:Boolean):void { 
			_textField.selectable = value; 
		}

		
		
		public function get selectedText():String { 
			return _textField.selectedText; 
		}

		
		
		public function get selectionBeginIndex():int { 
			return _textField.selectionBeginIndex; 
		}

		
		
		public function get selectionEndIndex():int { 
			return _textField.selectionEndIndex; 
		}

		
		
		public function get sharpness():Number { 
			return _textField.sharpness; 
		}

		
		
		public function set sharpness(value:Number):void { 
			_textField.sharpness = value; 
		}

		
		
		public function get text():String { 
			return _textField.text; 
		}

		
		
		public function get textColor():uint { 
			return _textField.textColor; 
		}

		
		
		public function set textColor(value:uint):void { 
			_textField.textColor = value; 
		}

		
		
		public function get textHeight():Number { 
			return _textField.textHeight; 
		}

		
		
		public function get textWidth():Number { 
			return _textField.textWidth; 
		}

		
		
		public function get thickness():Number { 
			return _textField.thickness; 
		}

		
		
		public function set thickness(value:Number):void { 
			_textField.thickness = value; 
		}

		
		
		public function get type():String { 
			return _textField.type; 
		}

		
		
		public function set type(value:String):void { 
			_textField.type = value; 
		}

		
		
		public function get useRichTextClipboard():Boolean { 
			return _textField.useRichTextClipboard; 
		}

		
		
		public function set useRichTextClipboard(value:Boolean):void { 
			_textField.useRichTextClipboard = value; 
		}

		
		
		public function get wordWrap():Boolean { 
			return _textField.wordWrap; 
		}

		
		
		public function set wordWrap(value:Boolean):void { 
			_textField.wordWrap = value; 
		}

		
		
		public function get paddingLeft():Number {
			return _paddingLeft;
		}

		
		
		public function set paddingLeft( value:Number ):void {
			_paddingLeft = value;
			_textField.x = _paddingLeft;
			if ( !isNaN(absoluteWidth) || !isNaN(relativeWidth) ) _textField.width = _measuredWidth - _paddingLeft - _paddingRight;
			updateWidth();
		}

		
		
		public function get paddingRight():Number {
			return _paddingRight;
		}

		
		
		public function set paddingRight( value:Number ):void {
			_paddingRight = value;
			if ( !isNaN(absoluteWidth) || !isNaN(relativeWidth) ) _textField.width = _measuredWidth - _paddingLeft - _paddingRight;
			updateWidth();
		}

		
		
		public function get paddingTop():Number {
			return _paddingTop;
		}

		
		
		public function set paddingTop( value:Number ):void {
			_paddingTop = value;
			_textField.y = _paddingTop;
			updateHeight();
		}

		
		
		public function get paddingBottom():Number {
			return _paddingBottom;
		}

		
		
		public function set paddingBottom( value:Number ):void {
			_paddingBottom = value;
			updateHeight();
		}
	}
}
