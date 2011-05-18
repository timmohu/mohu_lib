package mohu.layout {
	import mohu.messages.Dispatcher;
	import mohu.messages.Message;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * @author Tim Kendrick
	 */
	[DefaultProperty("children")]

	public class LayoutComponent extends Sprite {

		internal var _container:LayoutContainer;

		private var _absoluteX:Number;
		private var _absoluteY:Number;
		private var _relativeX:Number;
		private var _relativeY:Number;

		private var _absoluteWidth:Number;
		private var _absoluteHeight:Number;
		private var _relativeWidth:Number;
		private var _relativeHeight:Number;

		// TODO: Make sure minWidth/minHeight values are honoured throughout calculations
		private var _minWidth:Number;
		private var _minHeight:Number;
		private var _maxWidth:Number;
		private var _maxHeight:Number;

		protected var _measuredX:Number;
		protected var _measuredY:Number;
		protected var _measuredWidth:Number;
		protected var _measuredHeight:Number;

		private var _pixelSnap:Boolean;
		private var _backgroundColour:uint = 0x00000000;

		private var _onUpdateX:Dispatcher;
		private var _onUpdateY:Dispatcher;
		private var _onUpdateWidth:Dispatcher;
		private var _onUpdateHeight:Dispatcher;
		private var _onChangeOrientation:Dispatcher;

		public function LayoutComponent() {
			super();

			_absoluteX = NaN;
			_absoluteY = NaN;
			_relativeX = 0;
			_relativeY = 0;

			_absoluteWidth = NaN;
			_absoluteHeight = NaN;
			_relativeWidth = NaN;
			_relativeHeight = NaN;

			_minWidth = NaN;
			_minHeight = NaN;
			_maxWidth = NaN;
			_maxHeight = NaN;

			_measuredX = 0;
			_measuredY = 0;
			_measuredWidth = 0;
			_measuredHeight = 0;

			_pixelSnap = true;

			_onUpdateX = new Dispatcher(this);
			_onUpdateY = new Dispatcher(this);
			_onUpdateWidth = new Dispatcher(this);
			_onUpdateHeight = new Dispatcher(this);
			_onChangeOrientation = new Dispatcher(this);
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);

			_onUpdateX.addListener(onUpdate);
			_onUpdateY.addListener(onUpdate);
			_onUpdateWidth.addListener(onUpdate);
			_onUpdateHeight.addListener(onUpdate);
			_onChangeOrientation.addListener(onUpdate);
		}

		
		
		private function onAdded( event:Event ):void {
			updateWidth();
			updateHeight();
			updateX();
			updateY();
			removeEventListener(Event.ENTER_FRAME, onRedraw);
			render();
		}

		
		
		private function onUpdate( message:Message ):void {
			addEventListener(Event.ENTER_FRAME, onRedraw);
		}

		
		
		private function onRedraw(event:Event):void {
			removeEventListener(Event.ENTER_FRAME, onRedraw);
			render();
		}

		
		
		public function render():void {
			var x:Number = ( _pixelSnap ? Math.round(_measuredX) : _measuredX );
			var y:Number = ( _pixelSnap ? Math.round(_measuredY) : _measuredY );
			if ( this.x != x ) this.x = x;
			if ( this.y != y ) this.y = y;
			graphics.clear();
			if ( !_backgroundColour ) return;
			graphics.beginFill(_backgroundColour & 0x00FFFFFF, ( _backgroundColour >>> 24 ) / 0xFF);
			graphics.drawRect(0, 0, _measuredWidth, _measuredHeight);
			graphics.endFill();
		}

		
		
		public function updateX( forceUpdate:Boolean = false ):void {
			var measuredX:Number = ( isNaN(_absoluteX) ? ( _container ? _container.getChildX(this) : 0 ) : _absoluteX + _relativeX );
			if ( measuredX == _measuredX && !forceUpdate )  return;
			_measuredX = measuredX;
			_onUpdateX.dispatch(new LayoutUpdateMessage(forceUpdate));
			if( forceUpdate ) render();
		}

		
		
		public function updateY( forceUpdate:Boolean = false ):void {
			var measuredY:Number = ( isNaN(_absoluteY) ? ( _container ? _container.getChildY(this) : 0 ) : _absoluteY + _relativeY );
			if ( measuredY == _measuredY && !forceUpdate ) return;
			_measuredY = measuredY;
			_onUpdateY.dispatch(new LayoutUpdateMessage(forceUpdate));
			if( forceUpdate ) render();
		}

		
		
		public function updateWidth( forceUpdate:Boolean = false ):void {
			var measuredWidth:Number = ( isNaN(_absoluteWidth) ? ( isNaN(_relativeWidth) ? contentWidth : ( _container ? _container.getRelativeWidth(this) : 0 ) ) : _absoluteWidth );
			if ( !isNaN(minWidth) ) measuredWidth = Math.max(minWidth, measuredWidth);
			if ( !isNaN(maxWidth) ) measuredWidth = Math.min(maxWidth, measuredWidth);
			if ( measuredWidth == _measuredWidth && !forceUpdate ) return;
			_measuredWidth = measuredWidth;
			_onUpdateWidth.dispatch(new LayoutUpdateMessage(forceUpdate));
			if( forceUpdate ) render();
		}

		
		
		public function updateHeight( forceUpdate:Boolean = false):void {
			var measuredHeight:Number = ( isNaN(_absoluteHeight) ? ( isNaN(_relativeHeight) ? contentHeight : ( _container ? _container.getRelativeHeight(this) : 0 ) ) : _absoluteHeight );
			if ( !isNaN(minHeight) ) measuredHeight = Math.max(minHeight, measuredHeight);
			if ( !isNaN(maxHeight) ) measuredHeight = Math.min(maxHeight, measuredHeight);
			if ( measuredHeight == _measuredHeight && !forceUpdate ) return;
			_measuredHeight = measuredHeight;
			_onUpdateHeight.dispatch(new LayoutUpdateMessage(forceUpdate));
			if( forceUpdate ) render();
		}

		
		
		public function get measuredBounds():Rectangle {
			return new Rectangle(_measuredX, _measuredY, _measuredWidth, _measuredHeight);
		}

		
		
		public function get measuredX():Number {
			return _measuredX;
		}

		
		
		public function get measuredY():Number {
			return _measuredY;
		}

		
		
		public function get measuredWidth():Number {
			return _measuredWidth;
		}

		
		
		public function get measuredHeight():Number {
			return _measuredHeight;
		}

		
		
		public function get absoluteWidth():Number {
			return _absoluteWidth;
		}

		
		
		public function set absoluteWidth( value:Number ):void {
			_absoluteWidth = value;
			_relativeWidth = NaN;
			updateWidth();
		}

		
		
		public function get absoluteHeight():Number {
			return _absoluteHeight;
		}

		
		
		public function set absoluteHeight( value:Number ):void {
			_absoluteHeight = value;
			_relativeHeight = NaN;
			updateHeight();
		}

		
		
		public function get relativeWidth():Number {
			return _relativeWidth;
		}

		
		
		public function set relativeWidth( value:Number ):void {
			_relativeWidth = value;
			_absoluteWidth = NaN;
			updateWidth();
		}

		
		
		public function get relativeHeight():Number {
			return _relativeHeight;
		}

		
		
		public function set relativeHeight( value:Number ):void {
			_relativeHeight = value;
			_absoluteHeight = NaN;
			updateHeight();
		}

		
		
		
		
		public function get contentWidth( ):Number {
			return getBounds(this).right;
		}

		
		
		public function get contentHeight( ):Number {
			return getBounds(this).bottom;
		}

		
		
		public function get relativeX():Number {
			return _relativeX;
		}

		
		
		public function set relativeX( value:Number ):void {
			_relativeX = value;
			updateX();
		}

		
		
		public function get relativeY():Number {
			return _relativeY;
		}

		
		
		public function set relativeY( value:Number ):void {
			_relativeY = value;
			updateY();
		}

		
		
		public function get absoluteX( ):Number {
			return _absoluteX;
		}

		
		
		public function set absoluteX( value:Number ):void {
			_absoluteX = value;
			updateX();
		}

		
		
		public function get absoluteY():Number {
			return _absoluteY;
		}

		
		
		public function set absoluteY( value:Number ):void {
			_absoluteY = value;
			updateY();
		}

		
		
		public function get minWidth():Number {
			return _minWidth;
		}

		
		
		public function set minWidth( value:Number ):void {
			_minWidth = value;
			updateWidth();
		}

		
		
		public function get minHeight():Number {
			return _minHeight;
		}

		
		
		public function set minHeight( value:Number ):void {
			_minHeight = value;
			updateWidth();
		}

		
		
		public function get maxWidth():Number {
			return _maxWidth;
		}

		
		
		public function set maxWidth( value:Number ):void {
			_maxWidth = value;
			updateWidth();
		}

		
		
		public function get maxHeight():Number {
			return _maxHeight;
		}

		
		
		public function set maxHeight( value:Number ):void {
			_maxHeight = value;
			updateHeight();
		}

		
		
		public function get children( ):Array {
			var children:Array = [];
			for ( var i:int = 0 ;i < numChildren ;i++ ) children.push(getChildAt(i));
			return children;
		}

		
		
		public function set children( value:Array):void {
			while ( this.numChildren > 0 ) this.removeChildAt(0);
			for each ( var child : DisplayObject in value ) addChild(child);
		}

		
		
		public function get container():LayoutContainer {
			return _container;
		}

		
		
		public function get pixelSnap():Boolean {
			return _pixelSnap;
		}

		
		
		public function set pixelSnap( value:Boolean ):void {
			_pixelSnap = value;
			render();
		}

		
		
		public function get onUpdateX():Dispatcher {
			return _onUpdateX;
		}

		
		
		public function get onUpdateY():Dispatcher {
			return _onUpdateY;
		}

		
		
		public function get onUpdateWidth():Dispatcher {
			return _onUpdateWidth;
		}

		
		
		public function get onUpdateHeight():Dispatcher {
			return _onUpdateHeight;
		}

		
		
		public function get onChangeOrientation():Dispatcher {
			return _onChangeOrientation;
		}

		
		
		public function get backgroundColour():uint {
			return _backgroundColour;
		}

		
		
		public function set backgroundColour( value:uint ):void {
			_backgroundColour = value;
			render();
		}
	}
}
