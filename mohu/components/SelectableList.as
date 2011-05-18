package mohu.components {
	import mohu.components.controllers.OptionGroupController;
	import mohu.components.interfaces.IOptionGroup;
	import mohu.components.interfaces.ISelectableButton;
	import mohu.messages.Dispatcher;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * @author Tim Kendrick
	 */
	public class SelectableList extends ListBase implements IOptionGroup {

		private var _optionGroup:OptionGroupController;
		private var _onChange:Dispatcher;

		public function SelectableList( vertical:Boolean = true , inverted:Boolean = false ) {
			super(vertical, inverted);

			_onChange = new Dispatcher(this);

			_optionGroup = new OptionGroupController();
			_optionGroup.onChange.addListener(_onChange.dispatch);
		}

		
		
		override public function addChild(child:DisplayObject):DisplayObject {
			if ( !( child is ISelectableButton ) ) throw new ArgumentError("Specified child is not an ISelectableButton");
			super.addChild(child);
			_optionGroup.addItem(child as ISelectableButton);
			child.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
			return child;
		}

		
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			if ( !( child is ISelectableButton ) ) throw new ArgumentError("Specified child is not an ISelectableButton");
			super.addChildAt(child, index);
			_optionGroup.addItem(child as ISelectableButton);
			child.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
			return child;
		}

		
		
		private function onRemoved(event:Event):void {
			if ( parent ) return;
			event.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			_optionGroup.removeItem(event.currentTarget as ISelectableButton);
		}

		
		
		public function addItem( item:ISelectableButton ):ISelectableButton {
			return addChild(item as DisplayObject) as ISelectableButton;
		}

		
		
		public function removeItem( item:ISelectableButton ):ISelectableButton {
			return removeChild(item as DisplayObject) as ISelectableButton;
		}

		
		
		public function get selectedItem():ISelectableButton {
			return _optionGroup.selectedItem;
		}

		
		
		public function set selectedItem( value:ISelectableButton ):void {
			_optionGroup.selectedItem = value;
		}

		
		
		public function get selectedIndex():int {
			return _optionGroup.selectedIndex;
		}

		
		
		public function set selectedIndex( value:int ):void {
			_optionGroup.selectedIndex = value;
		}

		
		
		public function get onChange( ):Dispatcher {
			return _onChange;
		}
	}
}
