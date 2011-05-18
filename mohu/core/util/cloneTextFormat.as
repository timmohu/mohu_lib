package mohu.core.util {
	import flash.text.TextFormat;

	public function cloneTextFormat( textFormat:TextFormat ):TextFormat {
		var newTextFormat:TextFormat = new TextFormat();
		newTextFormat.align = textFormat.align;
		newTextFormat.blockIndent = textFormat.blockIndent;
		newTextFormat.bold = textFormat.bold;
		newTextFormat.bullet = textFormat.bullet;
		newTextFormat.color = textFormat.color;
		newTextFormat.font = textFormat.font;
		newTextFormat.indent = textFormat.indent;
		newTextFormat.italic = textFormat.italic;
		newTextFormat.kerning = textFormat.kerning;
		newTextFormat.leading = textFormat.leading;
		newTextFormat.leftMargin = textFormat.leftMargin;
		newTextFormat.letterSpacing = textFormat.letterSpacing;
		newTextFormat.rightMargin = textFormat.rightMargin;
		newTextFormat.size = textFormat.size;
		newTextFormat.tabStops = textFormat.tabStops;
		newTextFormat.target = textFormat.target;
		newTextFormat.underline = textFormat.underline;
		newTextFormat.url = textFormat.url;
		return newTextFormat;
	}
}
