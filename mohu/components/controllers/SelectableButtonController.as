package mohu.components.controllers {
	import mohu.components.interfaces.ISelectableButton;
	import mohu.messages.Dispatcher;

	import flash.display.InteractiveObject;

	/**
	 * @author Tim Kendrick
	 */
	public class SelectableButtonController extends ButtonController implements ISelectableButton {

		private var _selected:Boolean;

		private var _onChange:Dispatcher;
		private var _onSelect:Dispatcher;
		private var _onDeselect:Dispatcher;

		public function SelectableButtonController( target:InteractiveObject = null ) {
			super(target);

			_onChange = new Dispatcher(this);
			_onSelect = new Dispatcher(this);
			_onDeselect = new Dispatcher(this);
		}

		
		public function get selected():Boolean {
			return _selected;
		}

		
		
		public function set selected( value:Boolean ):void {
			if ( _selected == value ) return;
			_selected = value;
			if ( value ) _onSelect.dispatch(); else _onDeselect.dispatch();
			_onChange.dispatch();
		}

		
		
		public function get onChange():Dispatcher {
			return _onChange;
		}

		
		
		public function get onSelect():Dispatcher {
			return _onSelect;
		}

		
		
		public function get onDeselect():Dispatcher {
			return _onDeselect;
		}
	}
}
