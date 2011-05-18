package mohu.components.interfaces {
	import mohu.messages.Dispatcher;

	import flash.display.InteractiveObject;

	/**
	 * @author Tim Kendrick
	 */
	public interface IButton {

		function get trackAsMenu():Boolean;

		
		
		function set trackAsMenu( value:Boolean ):void;

		
		
		function set interactiveObject( interactiveObject:InteractiveObject ):void;

		
		
		function get interactiveObject( ):InteractiveObject;

		
		
		function get onFocusIn():Dispatcher;

		
		
		function get onFocusOut():Dispatcher;

		
		
		function get onRollOver():Dispatcher;

		
		
		function get onRollOut():Dispatcher;

		
		
		function get onPress():Dispatcher;

		
		
		function get onRelease():Dispatcher;

		
		
		function get onReleaseOutside():Dispatcher;

		
		
		function get rolledOver():Boolean;

		
		
		function get pressed():Boolean;
	}
}
