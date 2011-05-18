package mohu.components {
	import mohu.components.controllers.ScrollBarController;
	import mohu.components.interfaces.IButton;
	import mohu.components.interfaces.IScrollBar;
	import mohu.components.interfaces.ISlider;
	import mohu.components.messages.ValueChangeMessage;
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * @author Tim Kendrick
	 */
	public class ScrollBar extends Sprite implements IScrollBar {

		private var _controller:ScrollBarController;

		private var _onChange:Dispatcher;
		private var _onDragStart:Dispatcher;
		private var _onDragStop:Dispatcher;
		private var _onScrollEnabled:Dispatcher;
		private var _onScrollDisabled:Dispatcher;

		public function ScrollBar( horizontal:Boolean = false , content:DisplayObject = null , scrollMask:DisplayObject = null , slider:ISlider = null , upArrow:IButton = null , downArrow:IButton = null , keyboardNudge:Number = 16 , snap:Number = 0 ) {
			_controller = new ScrollBarController(horizontal, content, scrollMask, slider, upArrow, downArrow, keyboardNudge, snap);
			
			_onChange = new Dispatcher(this);
			_onDragStart = new Dispatcher(this);
			_onDragStop = new Dispatcher(this);
			_onScrollEnabled = new Dispatcher(this);
			_onScrollDisabled = new Dispatcher(this);
			
			_controller.onChange.addListener(onControllerChange);
			_controller.onDragStart.addListener(onControllerDragStart);
			_controller.onDragStop.addListener(onControllerDragStop);
			_controller.onScrollEnabled.addListener(onControllerScrollEnabled);
			_controller.onScrollDisabled.addListener(onControllerScrollDisabled);
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

		
		
		private function onControllerScrollEnabled( message:Message ):void {
			_onScrollEnabled.dispatch(message, this);
		}

		
		
		private function onControllerScrollDisabled( message:Message ):void {
			_onScrollDisabled.dispatch(message, this);
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

		
		
		public function get slider():ISlider { 
			return _controller.slider; 
		}

		
		
		public function set slider( value:ISlider ):void { 
			_controller.slider = value; 
		}

		
		
		public function get content():DisplayObject { 
			return _controller.content; 
		}

		
		
		public function set content( value:DisplayObject ):void { 
			_controller.content = value; 
		}

		
		
		public function get scrollMask():DisplayObject { 
			return _controller.scrollMask; 
		}

		
		
		public function set scrollMask( value:DisplayObject ):void { 
			_controller.scrollMask = value; 
		}

		
		
		public function get upArrow():IButton { 
			return _controller.upArrow; 
		}

		
		
		public function set upArrow( value:IButton ):void { 
			_controller.upArrow = value; 
		}

		
		
		public function get downArrow():IButton { 
			return _controller.downArrow; 
		}

		
		
		public function set downArrow( value:IButton ):void { 
			_controller.downArrow = value; 
		}

		
		
		public function get offset():Number { 
			return _controller.offset; 
		}

		
		
		public function set offset( value:Number ):void { 
			_controller.offset = value; 
		}

		
		
		public function get scrollable():Boolean { 
			return _controller.scrollable; 
		}

		
		
		public function get scrollLength():Number { 
			return _controller.scrollLength; 
		}

		
		
		public function get maxScroll():Number { 
			return _controller.maxScroll; 
		}

		
		
		public function get pageLength():Number { 
			return _controller.pageLength; 
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

		
		
		public function get onScrollEnabled( ):Dispatcher { 
			return _onScrollEnabled; 
		}

		
		
		public function get onScrollDisabled( ):Dispatcher { 
			return _onScrollDisabled; 
		}
	}
}
