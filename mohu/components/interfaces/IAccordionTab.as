package mohu.components.interfaces {
	import mohu.messages.Dispatcher;

	/**
	 * @author Tim Kendrick
	 */
	public interface IAccordionTab extends ISelectable {

		function get position():Number;

		
		
		function set position( value:Number ):void;

		
		
		function get size():Number;

		
		
		function set size( value:Number ):void;

		
		
		function get autoSize():Boolean;

		
		
		function get unselectedSize():Number;

		
		
		function get selectedSize():Number;

		
		
		function get onChangeSize( ):Dispatcher;
	}
}
