package mohu.animation {	import flash.display.DisplayObject;	import flash.geom.ColorTransform;	public class ColourEffect extends Animation {		private static const COLOUR_TRANSFORM_PROPERTIES:Array = ["redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier", "redOffset", "greenOffset", "blueOffset", "alphaOffset"];		private static const PROPERTY_PREFIX:String = "transform.colorTransform.";		private var _currentTransform:ColorTransform;		public function ColourEffect(target:DisplayObject, colourTransform:ColorTransform, frames:uint, easing:Function = null) {			var properties:Object = {};			for each (var property:String in COLOUR_TRANSFORM_PROPERTIES) properties[PROPERTY_PREFIX + property] = colourTransform[property];			super(target, properties, frames, easing);			_currentTransform = new ColorTransform();		}		override protected function _applyChange(property:String, value:Number, finalProperty:Boolean):void {			_currentTransform[property.substr(PROPERTY_PREFIX.length)] = value;			if (finalProperty) (target as DisplayObject).transform.colorTransform = _currentTransform;		}		override protected function _getInitialValue(property:String):Number {			return (target as DisplayObject).transform.colorTransform[property.substr(PROPERTY_PREFIX.length)];		}	}}