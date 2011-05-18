package mohu.core.display.text {
	import mohu.core.util.htmlEncode;

	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Tim Kendrick
	 */
	public class StyledTextField extends TextField {

		private var _styleSheetClass:String;
		private var _styleSheet:StyleSheet;
		private var _htmlText:String;
		private var _textFormat:TextFormat;

		public function StyledTextField( styleSheet:StyleSheet = null , styleSheetClass:String = null ) {
			super();
			
			autoSize = TextFieldAutoSize.LEFT;
			
			if ( styleSheet ) this.styleSheet = styleSheet;
			if ( styleSheetClass ) this.styleSheetClass = styleSheetClass;
		}

		
		
		
		
		public function get textFormat():TextFormat {
			return _textFormat;
		}

		
		
		public function set textFormat( value:TextFormat ):void {
			_textFormat = value;
			if ( _textFormat is AdvancedTextFormat ) {
				( _textFormat as AdvancedTextFormat ).apply(this);
			} else {
				setTextFormat(value);
				defaultTextFormat = value;
			}
		}

		
		override public function get styleSheet():StyleSheet { 
			return _styleSheet; 
		}

		
		
		override public function set styleSheet( value:StyleSheet ):void { 
			_styleSheet = value;
			updateStyleSheet();
		}

		
		
		public function get styleSheetClass( ):String {
			return _styleSheetClass;
		}

		
		
		public function set styleSheetClass( value:String ):void {
			_styleSheetClass = value;
			updateStyleSheet();
			if ( _htmlText != null ) htmlText = _htmlText; else text = super.text;
		}

		
		
		private function updateStyleSheet():void {
			if ( !_styleSheet ) {
				super.styleSheet = null;
				return;
			}
			
			var textFieldStyleSheet:StyleSheet = new StyleSheet();
			var styleName:String;
			var propertyName:String;
			for each ( styleName in _styleSheet.styleNames ) textFieldStyleSheet.setStyle(styleName, _styleSheet.getStyle(styleName));
			
			if ( _styleSheetClass ) {
				var selectedStyle:Object = textFieldStyleSheet.getStyle("." + _styleSheetClass);
				for ( propertyName in selectedStyle ) {
					if ( selectedStyle[ propertyName ].constructor != Object ) continue;
					var overridingStyle:Object = selectedStyle[ propertyName ];
					var overriddenStyle:Object = textFieldStyleSheet.getStyle(propertyName);
					for ( var overridingPropertyName : String in overridingStyle ) overriddenStyle[ overridingPropertyName ] = overridingStyle[ overridingPropertyName ];
					textFieldStyleSheet.setStyle(propertyName, overriddenStyle);
				}
				// TODO: need to give default values to the properties below when selected style does not have them or values such as textfield properties like backgroundColor will persist unless explicitely overriden
				for each ( propertyName in AdvancedTextFormat.ADVANCED_STYLESHEET_PROPERTIES ) if ( selectedStyle.hasOwnProperty(propertyName) ) this[ propertyName ] = selectedStyle[ propertyName ];
			}
			
			super.styleSheet = textFieldStyleSheet;
		}

		
		
		override public function set text( value:String ):void {
			_htmlText = null;
			if ( _styleSheetClass ) super.htmlText = "<span class=\"" + _styleSheetClass + "\">" + htmlEncode(value || "") + "</span>"; else super.text = value;
		}

		
		
		
		override public function get htmlText():String { 
			return _htmlText; 
		}

		
		override public function set htmlText( value:String ):void { 
			_htmlText = value;
			if ( _styleSheetClass ) super.htmlText = "<span class=\"" + _styleSheetClass + "\">" + ( _htmlText || "" ) + "</span>"; else super.htmlText = value;
		}
	}
}
