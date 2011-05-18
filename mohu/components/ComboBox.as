package mohu.components {
	import mohu.components.interfaces.IOptionGroup;
	import mohu.components.interfaces.ISelectableButton;
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	/**
	 * @author Tim Kendrick
	 */

	[DefaultProperty("items")]

	public class ComboBox extends Sprite implements IOptionGroup {

		protected var _header:ISelectableButton;
		protected var _list:IOptionGroup;

		private var _onExpand:Dispatcher;
		private var _onContract:Dispatcher;
		private var _onChange:Dispatcher;
		private var _expanded:Boolean;

		public function ComboBox( header:ISelectableButton , list:IOptionGroup ) {
			super();

			_header = header;
			_list = list;

			( _list as DisplayObjectContainer ).tabChildren = false;

			_onExpand = new Dispatcher(this);
			_onContract = new Dispatcher(this);
			_onChange = new Dispatcher(this);

			_header.onPress.addListener(onPressHeader);
			_list.onChange.addListener(onChangeList);

			addEventListener(FocusEvent.FOCUS_IN, onFocusIn, false, 0, true);
			addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
			addEventListener(FocusEvent.KEY_FOCUS_CHANGE, onFocusChange, false, 0, true);
		}

		
		
		private function onFocusChange(event:FocusEvent):void {
			if ( ( event.keyCode == Keyboard.UP ) || ( event.keyCode == Keyboard.DOWN ) ) event.preventDefault(); else expanded = false;
		}

		
		
		private function onPressHeader( message:Message ):void {
			expanded = !expanded;
		}

		
		
		private function onChangeList( message:Message ):void {
			expanded = false;
			_onChange.dispatch();
		}

		
		
		private function onFocusIn(event:FocusEvent):void {
			event.currentTarget.stage.addEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
		}

		
		
		private function onFocusOut(event:FocusEvent):void {
			event.currentTarget.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onPressKey);
		}

		
		
		private function onPressKey(event:KeyboardEvent):void {
			switch ( event.keyCode ) {
				case Keyboard.UP:
					_list.selectedIndex = Math.max(0, _list.selectedIndex - 1);
					break;
				case Keyboard.DOWN:
					_list.selectedIndex = Math.min(_list.numItems - 1, _list.selectedIndex + 1);
					break;
				case Keyboard.SPACE:
					expanded = !expanded;
					break;
			}
		}

		
		
		public function set expanded( value:Boolean ):void {
			if ( _expanded == value ) return;
			_expanded = value;
			_header.selected = value;

			if ( value ) {
				_onExpand.dispatch();
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			} else {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				_onContract.dispatch();
			}
		}

		
		
		private function onMouseDown( event:MouseEvent ):void {
			if ( ( this.contains(event.target as DisplayObject) ) || ( ( _list as DisplayObjectContainer ).contains(event.target as DisplayObject) ) ) return;
			expanded = false;
		}

		
		
		public function get onExpand():Dispatcher {
			return _onExpand;
		}

		
		
		public function get onContract():Dispatcher {
			return _onContract;
		}

		
		
		public function get onChange():Dispatcher {
			return _onChange;
		}

		
		
		
		
		public function addItem( item:ISelectableButton ):ISelectableButton {
			return _list.addItem(item);
		}

		
		
		public function removeItem(item:ISelectableButton):ISelectableButton {
			return _list.removeItem(item);
		}

		
		
		public function get items():Array {
			return _list.items;
		}

		
		
		public function set items( value:Array ):void {
			_list.items = value;
		}

		
		
		public function get numItems():int {
			return _list.numItems;
		}

		
		
		public function get selectedItem():ISelectableButton {
			return _list.selectedItem;
		}

		
		
		public function set selectedItem( value:ISelectableButton ):void {
			_list.selectedItem = value;
		}

		
		
		public function get selectedIndex():int {
			return _list.selectedIndex;
		}

		
		
		public function set selectedIndex( value:int ):void {
			_list.selectedIndex = value;
		}

		
		
		public function get expanded():Boolean {
			return _expanded;
		}
	}
}
