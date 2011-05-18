package mohu.components {
	import mohu.components.messages.MouseMessage;

	/**
	 * @author Tim Kendrick
	 */
	public class ToggleButton extends SelectableButton {

		private var _autoToggle:Boolean;
		private var _allowDeselect:Boolean;

		public function ToggleButton( autoToggle:Boolean = true , allowDeselect:Boolean = true ) {
			_autoToggle = autoToggle;
			_allowDeselect = allowDeselect;

			super();

			onRelease.addListener(onReleaseMessage);
		}

		
		
		
		private function onReleaseMessage( message:MouseMessage ):void {
			if ( !_autoToggle || ( !_allowDeselect && selected) ) return;
			selected = !selected;
		}

		
		
		public function get autoToggle():Boolean {
			return _autoToggle;
		}

		
		
		public function set autoToggle( value:Boolean):void {
			_autoToggle = value;
		}

		
		
		public function get allowDeselect():Boolean {
			return _allowDeselect;
		}

		
		
		public function set allowDeselect( value:Boolean ):void {
			_allowDeselect = value;
		}
	}
}
