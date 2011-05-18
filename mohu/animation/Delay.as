package mohu.animation {
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	public class Delay {

		public var duration:int;
		public var paused:Boolean;
		public var children:Vector.<Delay>;

		private var _currentFrame:int;

		private var _onStart:Dispatcher;
		private var _onEnterFrame:Dispatcher;
		private var _onComplete:Dispatcher;

		public function Delay(frames:int) {
			super();

			if (frames < 0) throw new ArgumentError("Duration cannot be negative");

			duration = frames;
			
			_currentFrame = 0;

			children = new Vector.<Delay>();

			_onStart = new Dispatcher(this);
			_onEnterFrame = new Dispatcher(this);
			_onComplete = new Dispatcher(this);
			
			_onComplete.addListener(handleComplete);
		}

		private function handleComplete(message:Message):void {
			_currentFrame = 0;
		}

		public function addChild(child:Delay):Delay {
			if (!child) throw new ArgumentError("No child specified");
			children.push(child);
			return child;
		}

		public function addChildren(children:Array):void {
			if (!children) throw new ArgumentError("No children specified");
			for each (var child:Delay in children) addChild(child);
		}

		public function removeChild(child:Delay):Delay {
			if (!child) return null;
			var index:int = children.indexOf(child);
			if (index == -1) throw new ArgumentError("Specified child is not a child of this Delay");
			return children.splice(index, 1)[0];
		}

		public function pause():void {
			paused = true;
		}

		public function unpause():void {
			paused = false;
		}

		public function togglePause():void {
			paused = !paused;
		}

		internal function _overwrite(otherDelay:Delay):Boolean {
			return otherDelay == this;
		}

		public function get currentFrame():int {
			return _currentFrame;
		}

		public function set currentFrame(value:int):void {
			if ((value < 0) || (value > duration)) throw new RangeError("Cannot set currentFrame to " + value + " (out of range)");
			_currentFrame = value;
		}

		public function get onStart():Dispatcher {
			return _onStart;
		}

		public function get onEnterFrame():Dispatcher {
			return _onEnterFrame;
		}

		public function get onComplete():Dispatcher {
			return _onComplete;
		}
	}
}