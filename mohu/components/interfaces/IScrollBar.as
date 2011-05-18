package mohu.components.interfaces {
	import mohu.messages.Dispatcher;

	import flash.display.DisplayObject;

	/**
	 * @author Tim Kendrick
	 */
	public interface IScrollBar extends ISlider {	

		
		function get slider():ISlider;

		
		
		function set slider( value:ISlider ):void;

		
		
		function get content():DisplayObject;

		
		
		function set content( value:DisplayObject ):void;

		
		
		function get scrollMask():DisplayObject;

		
		
		function set scrollMask( value:DisplayObject ):void;

		
		
		function get upArrow():IButton;

		
		
		function set upArrow( value:IButton ):void;

		
		
		function get downArrow():IButton;

		
		
		function set downArrow( value:IButton ):void;

		
		
		function get offset():Number;

		
		
		function set offset( value:Number ):void;

		
		
		function get scrollable():Boolean;

		
		
		function get scrollLength():Number;

		
		
		function get maxScroll():Number;

		
		
		function get pageLength():Number;

		
		
		function get onScrollEnabled( ):Dispatcher;

		
		
		function get onScrollDisabled( ):Dispatcher;
	}
}
