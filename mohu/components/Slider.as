package mohu.components {
	import mohu.components.controllers.SliderController;
	import mohu.components.interfaces.IButton;
	import mohu.components.interfaces.ISlider;
	import mohu.components.messages.ValueChangeMessage;
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Tim Kendrick
	 */
	public class Slider extends Sprite implements ISlider {

		private var _controller:SliderController;

		private var _onChange:Dispatcher;
		private var _onDragStart:Dispatcher;
		private var _onDragStop:Dispatcher;

		public function Slider( horizontal:Boolean = false , track:IButton = null , handle:IButton = null , fill:DisplayObject = null , invertAxis:Boolean = false , liveUpdate:Boolean = true , snap:Number = 0 , handleLength:Number = NaN , keyboardNudge:Number = 0.1 ) {
			_controller = new SliderController(horizontal, track, handle, fill, invertAxis, liveUpdate, snap, handleLength, keyboardNudge);
			
			_onChange = new Dispatcher(this);
			_onDragStart = new Dispatcher(this);
			_onDragStop = new Dispatcher(this);
			
			_controller.onChange.addListener(onControllerChange);
			_controller.onDragStart.addListener(onControllerDragStart);
			_controller.onDragStop.addListener(onControllerDragStop);
		}

		public function updateAppearance():void {
			_controller.updateAppearance();
		}

		
		
		private function onControllerChange( message:ValueChangeMessage ):void {
			_onChange.dispatch(message, this);
		}

		
		
		private function onControllerDragStart( message:Message ):void {
			_onDragStart.dispatch(message, this);
		}

		
		
		private function onControllerDragStop( message:Message ):void {
			_onDragStop.dispatch(message, this);
		}

		
		
		public function get snap():Number {
			return _controller.snap; 
		}

		
		
		public function set snap( value:Number ):void { 
			_controller.snap = value; 
		}

		
		
		public function get keyboardNudge():Number { 
			return _controller.keyboardNudge; 
		}

		
		
		public function set keyboardNudge( value:Number ):void { 
			_controller.keyboardNudge = value; 
		}

		
		
		public function get liveUpdate():Boolean { 
			return _controller.liveUpdate; 
		}

		
		
		public function set liveUpdate( value:Boolean ):void { 
			_controller.liveUpdate = value; 
		}

		
		
		public function get position():Number { 
			return _controller.position; 
		}

		
		
		public function set position( value:Number ):void { 
			_controller.position = value; 
		}

		
		
		public function get sliding():Boolean { 
			return _controller.sliding; 
		}

		
		
		public function get onChange():Dispatcher { 
			return _onChange; 
		}

		
		
		public function get onDragStart():Dispatcher { 
			return _onDragStart; 
		}

		
		
		public function get onDragStop():Dispatcher { 
			return _onDragStop; 
		}
	}
}
