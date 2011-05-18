package mohu.components.interfaces {
	import mohu.messages.Dispatcher;

	/**
	 * @author Tim Kendrick
	 */

	public interface ISelectable {

		function get selected():Boolean;

		
		
		function set selected( value:Boolean ):void;

		
		
		function get onChange( ):Dispatcher;

		
		
		function get onSelect( ):Dispatcher;

		
		
		function get onDeselect( ):Dispatcher;
	}
}
