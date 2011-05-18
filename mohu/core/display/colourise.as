package mohu.core.display {
	import flash.filters.ColorMatrixFilter;

	public function colourise(_colour:int):ColorMatrixFilter {
		var LUMA_R:Number = 0.212671;
		var LUMA_G:Number = 0.71516;
		var LUMA_B:Number = 0.072169;
		
		var r:Number = (((_colour >> 16) & 0xFF) / 0xFF);
		var g:Number = (((_colour >> 8) & 0xFF) / 0xFF);
		var b:Number = ((_colour & 0xFF) / 0xFF);
	    
		return new ColorMatrixFilter([r * LUMA_R, r * LUMA_G, r * LUMA_B, 0, 0, 
			g * LUMA_R, g * LUMA_G, g * LUMA_B, 0, 0, 
			b * LUMA_R, b * LUMA_G, b * LUMA_B, 0, 0, 
			0, 0, 0, 1, 0]);
	}
}
