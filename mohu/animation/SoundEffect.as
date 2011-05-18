package mohu.animation {	import flash.media.SoundTransform;	public class SoundEffect extends Animation {		private static const SOUND_TRANSFORM_PROPERTIES:Array = ["leftToLeft", "leftToRight", "pan", "rightToLeft", "rightToRight", "volume"];				private static const PROPERTY_PREFIX:String = "soundTransform.";
		private var _currentTransform:SoundTransform;
		public function SoundEffect(target:Object, soundTransform:SoundTransform, frames:uint, easing:Function = null) {			if (target.soundTransform != null) {				var properties:Object = {};				for each (var property:String in SOUND_TRANSFORM_PROPERTIES) properties[PROPERTY_PREFIX + property] = soundTransform[property];				super(target, properties, frames, easing);				_currentTransform = new SoundTransform();			} else {				throw new ArgumentError("Target must have a soundTransform property");			}		}		override protected function _applyChange(property:String, value:Number, finalProperty:Boolean):void {			_currentTransform[property.substr(PROPERTY_PREFIX.length)] = value;			if (finalProperty) target.soundTransform = _currentTransform;		}		override protected function _getInitialValue(property:String):Number {			return target.soundTransform[property.substr(PROPERTY_PREFIX.length)];		}	}}