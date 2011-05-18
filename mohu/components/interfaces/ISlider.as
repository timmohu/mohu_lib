package mohu.components.interfaces {
	import mohu.messages.Dispatcher;

	/**
	 * @author Tim Kendrick
	 */
	public interface ISlider {		

		function get snap():Number;

		
		
		function set snap( value:Number ):void;

		
		
		function get keyboardNudge():Number;

		
		
		function set keyboardNudge( value:Number ):void;

		
		
		function get liveUpdate():Boolean;

		
		
		function set liveUpdate( value:Boolean ):void;

		
		
		function get position():Number;

		
		
		function set position( value:Number ):void;

		
		
		function get sliding():Boolean;

		
		
		function get onChange():Dispatcher;

		
		
		function get onDragStart():Dispatcher;

		
		
		function get onDragStop():Dispatcher;
	}
}
