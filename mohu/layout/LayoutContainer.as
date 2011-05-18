package mohu.layout {
	import mohu.messages.Message;

	import flash.display.DisplayObject;

	/**
	 * @author Tim Kendrick
	 */

	public class LayoutContainer extends LayoutComponent {

		private static const HORIZONTAL_ALIGN_ALLOWED_VALUES:Array = [HorizontalAlign.LEFT , HorizontalAlign.CENTRE , HorizontalAlign.RIGHT];
		private static const VERTICAL_ALIGN_ALLOWED_VALUES:Array = [VerticalAlign.TOP , VerticalAlign.MIDDLE , VerticalAlign.BOTTOM];

		private var _vertical:Boolean;

		private var _horizontalAlign:String;
		private var _verticalAlign:String;

		private var _spacing:Number;

		private var _paddingLeft:Number;
		private var _paddingRight:Number;
		private var _paddingTop:Number;
		private var _paddingBottom:Number;

		private var _children:Array;

		private var _updatingChildren:Boolean;

		
		
		public function LayoutContainer( vertical:Boolean = true ) {
			super();

			_vertical = vertical;

			_horizontalAlign = HorizontalAlign.LEFT;
			_verticalAlign = VerticalAlign.TOP;

			_spacing = 0;

			_paddingLeft = 0;
			_paddingRight = 0;
			_paddingTop = 0;
			_paddingBottom = 0;

			_children = [];

			onUpdateWidth.addListener(onUpdateWidthHandler);
			onUpdateHeight.addListener(onUpdateHeightHandler);
		}

		
		
		private function onUpdateWidthHandler( message:LayoutUpdateMessage ):void {
			updateChildrenX(message.forceUpdate);
		}

		
		
		private function onUpdateHeightHandler( message:LayoutUpdateMessage ):void {
			updateChildrenY(message.forceUpdate);
		}

		
		
		private function updateChildrenX( forceUpdate:Boolean = false ):void {
			_updatingChildren = true;
			var child:LayoutComponent;
			for each ( child in _children ) child.updateWidth(forceUpdate);
			for each ( child in _children ) child.updateX(forceUpdate);
			_updatingChildren = false;
		}

		
		
		private function updateChildrenY( forceUpdate:Boolean = false ):void {
			_updatingChildren = true;
			var child:LayoutComponent;
			for each ( child in _children ) child.updateHeight(forceUpdate);
			for each ( child in _children ) child.updateY(forceUpdate);
			_updatingChildren = false;
		}

		
		
		public function getChildX( child:LayoutComponent ):Number {
			if ( !isNaN(child.absoluteX) ) return child.absoluteX;
			if ( _vertical ) return getAlignOffsetX(child.measuredWidth) + child.relativeX;
			var totalWidth:Number = 0;
			for each ( var otherChild : LayoutComponent in _children ) {
				if ( otherChild == child ) break;
				if ( isNaN(otherChild.absoluteX) ) totalWidth += otherChild.relativeX + otherChild.measuredWidth + _spacing;
			}
			return getAlignOffsetX(totalChildWidth) + totalWidth + child.relativeX;
		}

		
		
		public function getChildY( child:LayoutComponent ):Number {
			if ( !isNaN(child.absoluteY) ) return child.absoluteY;
			if ( !_vertical ) return getAlignOffsetY(child.measuredHeight) + child.relativeY;
			var totalHeight:Number = 0;
			for each ( var otherChild : LayoutComponent in _children ) {
				if ( otherChild == child ) break;
				if ( isNaN(otherChild.absoluteY) ) totalHeight += otherChild.relativeY + otherChild.measuredHeight + _spacing;
			}
			return getAlignOffsetY(totalChildHeight) + totalHeight + child.relativeY;
		}

		
		
		private function getAlignOffsetX( contentWidth:Number ):Number {
			switch ( _horizontalAlign ) {
				case HorizontalAlign.LEFT: 
					return _paddingLeft;
				case HorizontalAlign.CENTRE:
					return ( _measuredWidth - _paddingLeft - _paddingRight - contentWidth ) / 2;
				case HorizontalAlign.RIGHT:
					return _measuredWidth - _paddingRight - contentWidth;
			}
			return 0;
		}

		
		
		private function getAlignOffsetY( contentHeight:Number ):Number {
			switch ( _verticalAlign ) {
				case VerticalAlign.TOP: 
					return _paddingTop;
				case VerticalAlign.MIDDLE: 
					return ( _measuredHeight - _paddingTop - _paddingBottom - contentHeight ) / 2;
				case VerticalAlign.BOTTOM:
					return _measuredHeight - _paddingBottom - contentHeight;
			}
			return 0;
		}

		
		
		protected function get totalChildWidth( ):Number {
			if ( _children.length == 0 ) return 0;
			var totalWidth:Number = 0;
			for each ( var child : LayoutComponent in _children ) if ( isNaN(child.absoluteX) ) totalWidth += child.relativeX + child.measuredWidth + _spacing;
			return ( totalWidth == 0 ? 0 : totalWidth - _spacing );
		}

		
		
		protected function get totalChildHeight( ):Number {
			if ( _children.length == 0 ) return 0;
			var totalHeight:Number = 0;
			for each ( var child : LayoutComponent in _children ) if ( isNaN(child.absoluteY) ) totalHeight += child.relativeY + child.measuredHeight + _spacing;
			return ( totalHeight == 0 ? 0 : totalHeight - _spacing );
		}

		
		
		public function getRelativeWidth( child:LayoutComponent ):Number {
			if ( isNaN(child.relativeWidth) ) return ( isNaN(child.absoluteWidth) ? child.contentWidth : child.absoluteWidth );
			if ( !isNaN(child.absoluteX) || _vertical ) return child.relativeWidth * ( _measuredWidth - _paddingLeft - _paddingRight );
			var relativeTotal:Number = 0;
			for each ( var otherChild : LayoutComponent in _children ) if ( !isNaN(otherChild.relativeWidth) && isNaN(otherChild.absoluteX) ) relativeTotal += otherChild.relativeWidth;
			if ( relativeTotal == child.relativeWidth ) relativeTotal = 1;
			return ( spareWidth * child.relativeWidth / relativeTotal );
		}

		
		
		public function getRelativeHeight( child:LayoutComponent ):Number {
			if ( isNaN(child.relativeHeight) ) return ( isNaN(child.absoluteHeight) ? child.contentHeight : child.absoluteHeight );
			if ( !isNaN(child.absoluteY) || !_vertical ) return child.relativeHeight * ( _measuredHeight - _paddingTop - _paddingBottom );
			var relativeTotal:Number = 0;
			for each ( var otherChild : LayoutComponent in _children ) if ( !isNaN(otherChild.relativeHeight) && isNaN(otherChild.absoluteY) ) relativeTotal += otherChild.relativeHeight;
			if ( relativeTotal == child.relativeHeight ) relativeTotal = 1;
			return ( spareHeight * child.relativeHeight / relativeTotal );
		}

		
		
		protected function get spareWidth( ):Number {
			var totalWidth:Number = _measuredWidth - _paddingLeft - _paddingRight;
			var spaces:int = -1;
			// TODO: Account for components with both relativeWidth and minWidth/maxWidth specified
			for each ( var otherChild : LayoutComponent in _children ) {
				if ( !isNaN(otherChild.absoluteX) ) continue;
				spaces++;
				if ( !isNaN(otherChild.absoluteWidth) ) totalWidth -= otherChild.absoluteWidth; else if ( isNaN(otherChild.relativeWidth) ) totalWidth -= otherChild.contentWidth;
			}
			if ( spaces > 0 ) totalWidth -= _spacing * spaces; 
			return totalWidth;
		}

		
		
		protected function get spareHeight( ):Number {
			var totalHeight:Number = _measuredHeight - _paddingTop - _paddingBottom;
			var spaces:int = -1;
			// TODO: Account for components with both relativeHeight and minHeight/maxHeight specified
			for each ( var otherChild : LayoutComponent in _children ) {
				if ( !isNaN(otherChild.absoluteY) ) continue;
				spaces++;
				if ( !isNaN(otherChild.absoluteHeight) ) totalHeight -= otherChild.absoluteHeight; else if ( isNaN(otherChild.relativeHeight) ) totalHeight -= otherChild.contentHeight;
			}
			if ( spaces > 0 ) totalHeight -= _spacing * spaces; 
			return totalHeight;
		}

		
		
		override public function addChild( child:DisplayObject ):DisplayObject {
			if ( !( child is LayoutComponent ) ) throw new ArgumentError("Specified child is not a LayoutComponent");
			( child as LayoutComponent )._container = this;
			addChildListeners(child as LayoutComponent);
			if ( _children.indexOf(child) != -1 ) _children.splice(_children.indexOf(child), 1);
			_children.push(child);
			super.addChild(child);
			onUpdateChildWidth(null);
			onUpdateChildHeight(null);
			return child;
		}

		
		
		
		override public function addChildAt( child:DisplayObject , index:int ):DisplayObject {
			if ( !( child is LayoutComponent ) ) throw new ArgumentError("Specified child is not a LayoutComponent");
			( child as LayoutComponent )._container = this;
			addChildListeners(child as LayoutComponent);
			if ( _children.indexOf(child) != -1 ) _children.splice(_children.indexOf(child, 1));
			_children.splice(index, 0, child);
			super.addChildAt(child, index);
			onUpdateChildWidth(null);
			onUpdateChildHeight(null);
			return child;
		}

		
		override public function removeChild(child:DisplayObject):DisplayObject {
			super.removeChild(child);
			removeChildListeners(child as LayoutComponent);
			_children.splice(_children.indexOf(child), 1);
			return child;
		}

		
		override public function removeChildAt(index:int):DisplayObject {
			return _children.splice(index, 1);
		}

		private function addChildListeners( child:LayoutComponent ):void {
			child.onUpdateX.addListener(onUpdateChildX);
			child.onUpdateY.addListener(onUpdateChildY);
			child.onUpdateWidth.addListener(onUpdateChildWidth);
			child.onUpdateHeight.addListener(onUpdateChildHeight);
			child.onChangeOrientation.addListener(onChangeChildOrientation);
		}

		
		
		private function removeChildListeners( child:LayoutComponent ):void {	
			child.onUpdateX.removeListener(onUpdateChildX);
			child.onUpdateY.removeListener(onUpdateChildY);
			child.onUpdateWidth.removeListener(onUpdateChildX);
			child.onUpdateHeight.removeListener(onUpdateChildY);
			child.onChangeOrientation.removeListener(onChangeChildOrientation);
		}

		
		
		private function onUpdateChildWidth( message:LayoutUpdateMessage ):void {
			if ( _updatingChildren ) return;
			_updatingChildren = true;
			if ( !_vertical ) for each ( var child : LayoutComponent in _children ) if ( isNaN(child.absoluteX) ) child.updateX(message ? message.forceUpdate : false);
			if ( isNaN(relativeWidth) && isNaN(absoluteWidth) ) updateWidth(message ? message.forceUpdate : false);
			_updatingChildren = false;
		}

		
		
		private function onUpdateChildHeight( message:LayoutUpdateMessage ):void {
			if ( _updatingChildren ) return;
			_updatingChildren = true;
			if ( _vertical ) for each ( var child : LayoutComponent in _children ) if ( isNaN(child.absoluteY) ) child.updateY(message ? message.forceUpdate : false);
			if ( isNaN(relativeHeight) && isNaN(absoluteHeight) ) updateHeight(message ? message.forceUpdate : false);
			_updatingChildren = false;
		}

		
		
		private function onUpdateChildX( message:LayoutUpdateMessage ):void {
			if ( _updatingChildren ) return;
			if ( _vertical ) return;
			_updatingChildren = true;
			for each ( var child : LayoutComponent in _children ) if ( isNaN(child.absoluteX) ) child.updateX(message ? message.forceUpdate : false);
			_updatingChildren = false;
		}

		
		
		private function onUpdateChildY( message:LayoutUpdateMessage ):void {
			if ( _updatingChildren ) return;
			if ( !_vertical ) return;
			_updatingChildren = true;
			for each ( var child : LayoutComponent in _children ) if ( isNaN(child.absoluteY) ) child.updateY(message ? message.forceUpdate : false);
			_updatingChildren = false;
		}

		
		
		private function onChangeChildOrientation( message:Message ):void {
			onUpdateChildX(null);
			onUpdateChildY(null);
		}

		
		
		public function get vertical():Boolean {
			return _vertical;
		}

		
		
		public function set vertical( value:Boolean ):void {
			_vertical = value;
			onChangeOrientation.dispatch();
		}

		
		
		override public function get children():Array {
			return _children.concat();
		}

		
		
		override public function set children( value:Array ):void {
			while ( numChildren > 0) removeChildAt(0);
			for each ( var child : LayoutComponent in value ) addChild(child);
			updateChildrenX();
			updateChildrenY();
		}

		
		
		override public function get contentWidth( ):Number {
			var absoluteWidth:Number = 0;
			var cumulativeWidth:Number = _paddingLeft;
			for each ( var child : LayoutComponent in _children ) {
				child.updateWidth();
				var childWidth:Number = child.relativeX + child.measuredWidth;
				if ( !isNaN(child.absoluteX) || _vertical ) {
					if ( isNaN(child.absoluteX) ) childWidth += _paddingLeft;
					if ( childWidth > absoluteWidth ) absoluteWidth = childWidth;
				} else {
					cumulativeWidth += childWidth + _spacing;
				}
			}
			if ( !_vertical && ( cumulativeWidth != _paddingLeft ) ) cumulativeWidth -= _spacing;
			return ( absoluteWidth > cumulativeWidth ? absoluteWidth : cumulativeWidth + _paddingRight );
		}

		
		
		override public function get contentHeight( ):Number {
			var absoluteHeight:Number = 0;
			var cumulativeHeight:Number = _paddingTop;
			for each ( var child : LayoutComponent in _children ) {
				child.updateHeight();
				var childHeight:Number = child.relativeY + child.measuredHeight;
				if ( !isNaN(child.absoluteY) || !_vertical ) {
					if ( isNaN(child.absoluteY) ) childHeight += _paddingLeft;
					if ( childHeight > absoluteHeight ) absoluteHeight = childHeight;
				} else {
					cumulativeHeight += childHeight + _spacing;
				}
			}
			if ( _vertical && ( cumulativeHeight != _paddingTop ) ) cumulativeHeight -= _spacing;
			return ( absoluteHeight > cumulativeHeight ? absoluteHeight : cumulativeHeight + _paddingBottom );
		}

		
		
		public function get spacing():Number {
			return _spacing;
		}

		
		
		public function set spacing(spacing:Number):void {
			_spacing = spacing;
			if ( _vertical ) updateChildrenY(); else updateChildrenX();
		}

		
		
		public function get paddingLeft():Number {
			return _paddingLeft;
		}

		
		
		public function set paddingLeft( value:Number ):void {
			_paddingLeft = value;
			updateChildrenX();
		}

		
		
		public function get paddingRight():Number {
			return _paddingRight;
		}

		
		
		public function set paddingRight( value:Number ):void {
			_paddingRight = value;
			updateChildrenX();
		}

		
		
		public function get paddingTop():Number {
			return _paddingTop;
		}

		
		
		public function set paddingTop( value:Number ):void {
			_paddingTop = value;
			updateChildrenY();
		}

		
		
		public function get paddingBottom():Number {
			return _paddingBottom;
		}

		
		
		public function set paddingBottom( value:Number ):void {
			_paddingBottom = value;
			updateChildrenY();
		}

		
		
		public function get horizontalAlign():String {
			return _horizontalAlign;
		}

		
		
		public function set horizontalAlign( value:String ):void {
			if ( HORIZONTAL_ALIGN_ALLOWED_VALUES.indexOf(value) == -1 ) throw new ArgumentError("Specified horizontalAlign '" + value + "' is not valid ( allowed values : " + HORIZONTAL_ALIGN_ALLOWED_VALUES.join(", ") + " )");
			_horizontalAlign = value;
			updateChildrenX();
		}

		
		
		public function get verticalAlign():String {
			return _verticalAlign;
		}

		
		
		public function set verticalAlign( value:String ):void {
			if ( VERTICAL_ALIGN_ALLOWED_VALUES.indexOf(value) == -1 ) throw new ArgumentError("Specified verticalAlign '" + value + "' is not valid ( allowed values : " + VERTICAL_ALIGN_ALLOWED_VALUES.join(", ") + " )");
			_verticalAlign = value;
			updateChildrenY();
		}
	}
}
