package mohu.core.display.text {
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Tim Kendrick
	 */
	public class AdvancedTextFormat extends TextFormat {

		public static const ANTI_ALIAS_TYPE:String = "antiAliasType";
		public static const BACKGROUND:String = "background";
		public static const BACKGROUND_COLOR:String = "backgroundColor";
		public static const BORDER:String = "border";
		public static const BORDER_COLOR:String = "borderColor";
		public static const EMBED_FONTS:String = "embedFonts";
		public static const GRID_FIT_TYPE:String = "gridFitType";
		public static const SHARPNESS:String = "sharpness";
		public static const THICKNESS:String = "thickness";

		public static const ADVANCED_STYLESHEET_PROPERTIES:Array = [ANTI_ALIAS_TYPE,
			BACKGROUND,
			BACKGROUND_COLOR,
			BORDER,
			BORDER_COLOR,
			EMBED_FONTS,
			GRID_FIT_TYPE,
			SHARPNESS,
			THICKNESS];

		public var embedFonts:Boolean;
		public var antiAliasType:String;
		public var sharpness:Number;
		public var thickness:Number;
		private var _gridFitType:String;
		public var background:Boolean;
		public var backgroundColor:uint;
		public var border:Boolean;
		public var borderColor:uint;

		public function AdvancedTextFormat( font:String = null, embedFonts:Boolean = false , size:Number = 12 , color:int = 0x000000 , bold:Boolean = false , italic:Boolean = false , underline:Boolean = false , leading:uint = 0 , letterSpacing:Number = 0 , leftMargin:Number = 0 , rightMargin:Number = 0 , indent:Number = 0 , kerning:Boolean = false , align:String = "left" , background:Boolean = false , backgroundColor:uint = 0xFFFFFF , border:Boolean = false , borderColor:uint = 0x000000 , antiAliasType:String = "advanced" , sharpness:Number = 0 , thickness:Number = 0 , gridFitType:String = "pixel" ) {
			this.embedFonts = embedFonts;
			this.background = background;
			this.backgroundColor = backgroundColor;
			this.border = border;
			this.borderColor = borderColor;
			this.antiAliasType = antiAliasType;
			this.sharpness = sharpness;
			this.thickness = thickness;
			this.gridFitType = gridFitType;
			super(font, size, color, bold, italic, underline, null, null, align, leftMargin, rightMargin, indent, leading);
			this.letterSpacing = letterSpacing;
			this.kerning = kerning;
		}

		
		
		public function apply( textField:TextField ):TextField {
			textField.setTextFormat(this);
			textField.defaultTextFormat = this;

			textField.embedFonts = embedFonts;
			textField.background = background;
			textField.backgroundColor = backgroundColor;
			textField.border = border;
			textField.borderColor = borderColor;
			textField.antiAliasType = antiAliasType;
			textField.sharpness = sharpness;
			textField.thickness = thickness;
			textField.gridFitType = gridFitType;

			return textField;
		}

		public static function advanceTextFormatFromStyle( style:Object):AdvancedTextFormat {
			var format:AdvancedTextFormat = new AdvancedTextFormat();
			format.align = style.align;
			format.blockIndent = style.blockIndent;
			format.bold = style.bold;
			format.bullet = style.bullet;
			format.color = style.color;
			if (style.fontFamily)
				format.font = style.fontFamily;
			else
				format.font = style.font;
			format.indent = style.indent;
			format.italic = style.italic;
			format.kerning = style.kerning;
			format.leading = style.leading;
			if (style.marginLeft)
				format.leftMargin = style.marginLeft;
			else
				format.leftMargin = style.leftMargin;
			format.letterSpacing = style.letterSpacing;
			format.rightMargin = style.rightMargin;
			if (style.fontSize)
				format.size = style.fontSize;
			else
				format.size = style.size;
			format.tabStops = style.tabStops;
			format.target = style.target;
			format.underline = style.underline;
			format.url = style.url;
			for each (var propertyName : String in ADVANCED_STYLESHEET_PROPERTIES) {
				if (style[propertyName])
					format[propertyName] = style[propertyName];
			}
			return format;
		}

		public function get gridFitType():String {
			return _gridFitType;
		}

		public function set gridFitType(gridFitType:String):void {
			_gridFitType = gridFitType || GridFitType.PIXEL;
		}
	}
}
