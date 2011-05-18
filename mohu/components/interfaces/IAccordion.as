package mohu.components.interfaces {
	import mohu.messages.Dispatcher;

	/**
	 * @author Tim Kendrick
	 */
	public interface IAccordion {

		function addTab( tab:IAccordionTab ):IAccordionTab;

		
		
		function removeTab( tab:IAccordionTab ):IAccordionTab;

		
		
		function get tabs():Vector.<IAccordionTab>;

		
		
		function set tabs( value:Vector.<IAccordionTab> ):void;

		
		
		function get numTabs():int;

		
		
		function get selectedTab():IAccordionTab;

		
		
		function set selectedTab( value:IAccordionTab ):void;

		
		
		function get selectedIndex():int;

		
		
		function set selectedIndex( value:int ):void;

		
		
		function get onChangeTab():Dispatcher;
	}
}
