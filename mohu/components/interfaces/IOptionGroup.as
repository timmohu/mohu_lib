package mohu.components.interfaces {
	import mohu.messages.Dispatcher;

	/**
	 * @author Tim Kendrick
	 */
	public interface IOptionGroup {

		function addItem( item:ISelectableButton ):ISelectableButton;

		
		
		function removeItem( item:ISelectableButton ):ISelectableButton;

		
		
		function get items():Array;

		
		
		function set items( value:Array ):void;

		
		
		function get numItems():int;

		
		
		function get selectedItem():ISelectableButton;

		
		
		function set selectedItem( value:ISelectableButton ):void;

		
		
		function get selectedIndex():int;

		
		
		function set selectedIndex( value:int ):void;

		
		
		function get onChange():Dispatcher;
	}
}
