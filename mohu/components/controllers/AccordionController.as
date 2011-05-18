package mohu.components.controllers {
	import mohu.components.interfaces.IAccordion;
	import mohu.components.interfaces.IAccordionTab;
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Tim Kendrick
	 */
	public class AccordionController implements IAccordion {

		private var _container:DisplayObjectContainer;
		private var _tabs:Vector.<IAccordionTab>;
		private var _selectedTab:IAccordionTab;
		private var _selecting:Boolean;
		private var _sizing:Boolean;

		private var _onChangeTab:Dispatcher;

		public function AccordionController( container:DisplayObjectContainer = null , tabs:Vector.<IAccordionTab> = null ) {
			_container = container;
			
			_tabs = new Vector.<IAccordionTab>();
			
			_onChangeTab = new Dispatcher(this);
			
			for each ( var tab : IAccordionTab in tabs ) addTab(tab);
			
			updateAppearance();
		}

		
		
		public function addTab( tab:IAccordionTab ):IAccordionTab {
			if ( _tabs.indexOf(tab) != -1 ) removeTab(tab);
			
			_tabs.push(tab);
			
			tab.onSelect.addListener(onSelectTab);
			tab.onDeselect.addListener(onDeselectTab);
			tab.onChangeSize.addListener(onChangeTabSize);
			
			var previousTab:IAccordionTab;
			if ( _tabs.length > 1 ) previousTab = _tabs[ _tabs.length - 2 ];
			if ( previousTab ) tab.position = previousTab.position + previousTab.size;
			
			if ( _container && ( tab is DisplayObject ) ) _container.addChild(tab as DisplayObject);
			
			return tab;
		}

		
		
		public function removeTab( tab:IAccordionTab ):IAccordionTab { 
			var index:int = _tabs.indexOf(tab);
			if ( index == -1 ) throw new ArgumentError("Specified tab does not belong to this Accordion");
			
			if ( tab == _selectedTab ) selectedTab = null;
			
			_tabs.splice(index, 1)[ 0 ];
			
			tab.onSelect.removeListener(onSelectTab);
			tab.onDeselect.removeListener(onDeselectTab);
			tab.onChangeSize.removeListener(onChangeTabSize);
			
			if ( _container && ( tab is DisplayObject ) && ( ( tab as DisplayObject ).parent == _container ) ) _container.removeChild(tab as DisplayObject);
			return tab;
		}

		
		
		private function onSelectTab( message:Message ):void {
			selectedTab = message.currentTarget;
		}

		
		
		private function onDeselectTab( message:Message ):void {
			selectedTab = null;
		}

		
		
		private function onChangeTabSize( message:Message ):void {
			updateAppearance();
		}

		
		
		protected function updateAppearance():void {
			if ( _sizing ) return;
			_sizing = true;
			
			var tab:IAccordionTab;
			var tabOverlap:Number = 0;
			var autoSizeTabCount:int = 0;
			for each ( tab in _tabs ) {
				tabOverlap += tab.size - ( tab.selected ? tab.selectedSize : tab.unselectedSize );
				if ( tab.autoSize ) autoSizeTabCount++;
			}
			tabOverlap /= autoSizeTabCount;
			for each ( tab in _tabs ) if ( tab.autoSize ) tab.size -= tabOverlap;
			var previousTab:IAccordionTab;
			for each ( tab in _tabs ) {
				if ( previousTab ) tab.position = previousTab.position + previousTab.size;
				previousTab = tab;
			}
			_sizing = false;
		}

		
		
		public function get tabs( ):Vector.<IAccordionTab> { 
			return _tabs.concat(); 
		}

		
		
		public function set tabs( value:Vector.<IAccordionTab> ):void { 
			for each ( var tab : IAccordionTab in value ) addTab(tab);
		}

		
		
		public function get numTabs():int { 
			return _tabs.length; 
		}

		
		
		public function get selectedTab():IAccordionTab { 
			return _selectedTab; 
		}

		
		
		public function set selectedTab( value:IAccordionTab ):void { 
			if ( _selectedTab == value ) return;
			if ( value && ( _tabs.indexOf(value) == -1 ) ) throw new ArgumentError("Specified tab does not belong to this Accordion");
			if ( _selecting ) return;
			_selecting = true;
			if ( _selectedTab ) _selectedTab.selected = false;
			_selectedTab = value;
			if ( _selectedTab ) _selectedTab.selected = true;
			_selecting = false;
		}

		
		
		public function get selectedIndex():int { 
			return _tabs.indexOf(_selectedTab); 
		}

		
		
		public function set selectedIndex( value:int ):void { 
			if ( value >= _tabs.length ) throw new RangeError("Specified index is out of range");
			selectedTab = _tabs[ value ]; 
		}

		
		
		public function get container():DisplayObjectContainer {
			return _container;
		}

		
		
		public function set container( value:DisplayObjectContainer ):void {
			if ( _container == value ) return;
			if ( _container ) for each ( var oldTab : IAccordionTab in _tabs ) if ( ( oldTab is DisplayObject ) && ( ( oldTab as DisplayObject ).parent == _container ) ) _container.removeChild(oldTab as DisplayObject);
			_container = container;
			if ( _container ) for each ( var tab : IAccordionTab in _tabs ) if ( tab is DisplayObject ) _container.addChild(tab as DisplayObject);
		}

		
		
		public function get onChangeTab():Dispatcher { 
			return _onChangeTab; 
		}
	}
}
