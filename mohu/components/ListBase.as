package mohu.components {
	import mohu.components.interfaces.IListBase;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Tim Kendrick
	 */

	[DefaultProperty("items")]

	public class ListBase extends Sprite implements IListBase {

		private var _vertical:Boolean;
		private var _inverted:Boolean;
		private var _itemSize:Number;
		private var _itemSpacing:Number;

		private var _updatingChildren:Boolean;

		public function ListBase( vertical:Boolean = true , inverted:Boolean = false ) {
			_vertical = vertical;
			_inverted = inverted;
			_itemSize = NaN;
			_itemSpacing = 0;
		}

		
		
		override public function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			child.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
			updateAppearance();
			return child;
		}

		
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			super.addChildAt(child, index);
			child.addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
			updateAppearance();
			return child;
		}

		
		
		private function onRemoved(event:Event):void {
			event.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			updateAppearance();
		}

		
		
		override public function setChildIndex(child:DisplayObject, index:int):void {
			super.setChildIndex(child, index);
			updateAppearance();
		}

		
		
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void {
			super.swapChildren(child1, child2);
			updateAppearance();
		}

		
		
		override public function swapChildrenAt(index1:int, index2:int):void {
			super.swapChildrenAt(index1, index2);
			updateAppearance();
		}

		
		
		protected function updateAppearance():void {
			if ( _updatingChildren ) return;
			var position:Number = 0;
			for ( var i:int = 0;i < numChildren ;i++ ) {
				var item:DisplayObject = getChildAt(i);
				if ( _vertical ) item.y = position; else item.x = position;
				var itemSize:Number = ( !isNaN(_itemSize) ? _itemSize : ( _vertical ? item.height : item.width ) );
				if ( !isNaN(_itemSpacing) ) itemSize += _itemSpacing;
				if ( !_inverted ) position += itemSize; else position -= itemSize;
			}
		}

		
		
		public function get items():Array {
			var items:Array = [];
			for ( var i:int = 0;i < numChildren ;i++ ) items.push(getChildAt(i));
			return items;
		}

		
		
		public function get numItems():int {
			return numChildren;
		}

		
		
		public function set items( value:Array ):void {
			_updatingChildren = true;
			while ( numChildren > 0 ) removeChildAt(0);
			for each ( var item : DisplayObject in value ) addChild(item);
			_updatingChildren = false;
			updateAppearance();
		}

		
		
		public function get vertical():Boolean {
			return _vertical;
		}

		
		
		public function set vertical( value:Boolean ):void {
			_vertical = value;
			updateAppearance();
		}

		
		
		public function get inverted():Boolean {
			return _inverted;
		}

		
		
		public function set inverted( value:Boolean ):void {
			_inverted = value;
			updateAppearance();
		}
	}
}
