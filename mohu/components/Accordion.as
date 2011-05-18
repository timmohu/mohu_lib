package mohu.components {
	import mohu.components.controllers.AccordionController;
	import mohu.components.interfaces.IAccordion;
	import mohu.components.interfaces.IAccordionTab;
	import mohu.messages.Dispatcher;

	import flash.display.Sprite;

	/**
	 * @author Tim Kendrick
	 */
	public class Accordion extends Sprite implements IAccordion {

		private var _controller:AccordionController;

		private var _onChangeTab:Dispatcher;

		public function Accordion( tabs:Vector.<IAccordionTab> = null ) {
			super();
			
			_onChangeTab = new Dispatcher(this);
			
			_controller = new AccordionController(this, tabs);
			
			_controller.onChangeTab.addListener(_onChangeTab.dispatch);
		}

		
		
		public function addTab( tab:IAccordionTab ):IAccordionTab {
			return _controller.addTab(tab);
		}

		
		
		public function removeTab( tab:IAccordionTab ):IAccordionTab {
			return _controller.removeTab(tab);
		}

		
		
		public function get tabs():Vector.<IAccordionTab> {
			return _controller.tabs;
		}

		
		
		public function set tabs( value:Vector.<IAccordionTab> ):void {
			_controller.tabs = value;
		}

		
		
		public function get numTabs():int {
			return _controller.numTabs;
		}

		
		
		public function get selectedTab():IAccordionTab {
			return _controller.selectedTab;
		}

		
		
		public function set selectedTab( value:IAccordionTab ):void {
			_controller.selectedTab = value;
		}

		
		
		public function set selectedIndex( value:int ):void {
			_controller.selectedIndex = value;
		}

		
		
		public function get selectedIndex():int {
			return _controller.selectedIndex;
		}

		
		
		public function get onChangeTab():Dispatcher {
			return _onChangeTab;
		}
	}
}
