package mohu.animation {
	import mohu.messages.Message;

	public class Animation extends Delay {

		public var target:Object;
		public var easing:Function;
		public var roundValues:Boolean;

		private var _propertiesArray:Array;
		private var _currentValue:Number;

		private static const DEFAULT_EASING:Function = Easing.EASE_OUT;

		public function Animation(target:Object, properties:Object, frames:int, easing:Function = null, roundValues:Boolean = false) {
			super(frames);

			if (!target) throw new ArgumentError("No target object specified");
			if (!properties) throw new ArgumentError("No properties specified");

			this.target = target;
			this.easing = easing || DEFAULT_EASING;
			this.roundValues = roundValues;

			_currentValue = 0;
			_propertiesArray = [];

			for (var property:String in properties) {
				if (!(properties[property] is Number) || isNaN(properties[property])) throw new ArgumentError("Specified property '" + property + "' is not numeric");
				_propertiesArray.push([property, null, properties[property]]);
			}
			
			onStart.addListener(_handleStart);
		}

		private function _handleStart(message:Message):void {
			for each (var property:Array in _propertiesArray) {
				if (property[1] !== null) continue; 
				var initialValue:Number = _getInitialValue(property[0]);
				if (isNaN(initialValue)) throw new ArgumentError("Initial value for property '" + property[0] + "' is not numeric");
				property[1] = initialValue;
			}
		}

		protected function _getInitialValue(property:String):Number {
			return target[property];
		}

		protected function _applyChange(property:String, value:Number, finalProperty:Boolean):void {
			finalProperty;
			target[property] = (roundValues ? int(value) : value);
		}

		override internal function _overwrite(delay:Delay):Boolean {
			if (!(delay is Animation)) return false;
			if (delay == this) return true;

			var animation:Animation = (delay as Animation);
			if (animation.target != this.target) return false;

			for each (var property:Array in animation._propertiesArray) {
				var l:int = _propertiesArray.length;
				for ( var i:int = 0;i < l;i++ ) if (_propertiesArray[i][0] == property[0]) break;
				if (i == l) continue;
				_propertiesArray.splice(i, 1);
				if (l == 1) return true;
			}

			return false;
		}

		public function clearProperty(property:String):Boolean {
			var l:int = _propertiesArray.length;
			for (var i:int = 0;i < l;i++) if (_propertiesArray[i][0] == property) break;
			if (i == l) return false;
			_propertiesArray.splice(i, 1);
			return (l == 1);
		}

		public function get currentValue():Number {
			return _currentValue;
		}

		override public function set currentFrame(value:int):void {
			super.currentFrame = value;
			_currentValue = easing(value / duration);
			var finalProperty:Array = _propertiesArray[_propertiesArray.length - 1];
			for each (var property:Array in _propertiesArray) _applyChange(property[0], property[1] + _currentValue * (property[2] - property[1]), property == finalProperty);
		}

		public function get properties():Object {
			var properties:Object = {};
			for each (var property:Array in _propertiesArray) properties[property[0]] = {start: property[1], end: property[2], currentValue: (property[1] + _currentValue * (property[2] - property[1]))};
			return properties;
		}

		public function toString():String {
			return "[object Animation] (target: " + target + ", properties: " + _propertiesArray + ", Current value: " + _currentValue + ", Easing: " + easing + ", Children: " + children.length + ")";
		}
	}
}