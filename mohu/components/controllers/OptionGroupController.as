package mohu.components.controllers {
	import mohu.components.interfaces.IOptionGroup;
	import mohu.components.interfaces.ISelectableButton;
	import mohu.components.messages.ValueChangeMessage;
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	/**
	 * @author Tim Kendrick
	 */
	public class OptionGroupController implements IOptionGroup {

		private var _items:Array;
		private var _selectedItem:ISelectableButton;
		private var _changing:Boolean;

		private var _onChange:Dispatcher;

		public function OptionGroupController( items:Array = null ) {
			super();

			_items = [];

			_onChange = new Dispatcher(this);

			if ( items ) this.items = items;
		}

		
		
		public function addItem( item:ISelectableButton ):ISelectableButton {
			if ( _items.indexOf(item) != -1 ) return item;
			item.onSelect.addListener(onSelectItem);
			item.onDeselect.addListener(onDeselectItem);
			_items.push(item);
			return item;
		}

		
		
		public function removeItem( item:ISelectableButton ):ISelectableButton {
			if ( _items.indexOf(item) == -1 ) return item;
			item.onSelect.removeListener(onSelectItem);
			item.onDeselect.removeListener(onDeselectItem);
			_items.splice(_items.indexOf(item), 1);
			if ( item == _selectedItem ) selectedItem = null;
			return item;
		}

		
		
		public function getItemIndex( item:ISelectableButton ):int {
			return _items.indexOf(item);
		}

		
		
		public function getItemAt( index:int ):ISelectableButton {
			return _items[ index ];
		}

		
		
		private function onSelectItem( message:Message ):void {
			selectedItem = message.currentTarget;
		}

		
		
		private function onDeselectItem( message:Message ):void {
			selectedItem = null;
		}

		
		
		public function get items():Array {
			return _items.concat();
		}

		
		
		public function get numItems():int {
			return _items.length;
		}

		
		
		public function get selectedItem():ISelectableButton {
			return _selectedItem;
		}

		
		
		public function set selectedItem( value:ISelectableButton ):void {
			if ( _changing ) return;
			_changing = true;
			if ( value && _items.indexOf(value) == -1 ) throw new ArgumentError("Specified item does not belong to this ItemGroup");
			if ( _selectedItem == value ) return;
			if ( _selectedItem ) _selectedItem.selected = false;
			var oldValue:int = selectedIndex;
			_selectedItem = value;
			if ( value && !value.selected ) _selectedItem.selected = true;
			_changing = false;
			_onChange.dispatch(new ValueChangeMessage(oldValue, selectedIndex));
		}

		
		
		public function set items( value:Array ):void {
			for each ( var item : ISelectableButton in _items ) removeItem(item);
			for each ( item in value ) addItem(item);
		}

		
		
		public function get onChange():Dispatcher {
			return _onChange;
		}

		
		
		public function get selectedIndex():int {
			return _items.indexOf(_selectedItem);
		}

		
		
		public function set selectedIndex( value:int ):void {
			if ( ( value < -1 ) || ( value >= _items.length ) ) throw new RangeError("Unable to set selectedIndex to " + value + " (out of range)");
			selectedItem = _items[ value ];
		}
	}
}
