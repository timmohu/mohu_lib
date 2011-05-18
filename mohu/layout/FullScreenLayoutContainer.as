package mohu.layout {
	import flash.events.Event;

	/**
	 * @author Tim Kendrick
	 */
	public class FullScreenLayoutContainer extends LayoutContainer {

		public function FullScreenLayoutContainer() {
			super();
			absoluteX = absoluteY = 0;
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
		}

		
		
		override public function render():void {
			x = Math.max(0, Math.round((stage.stageWidth - measuredWidth) / 2));
			y = Math.max(0, Math.round((stage.stageHeight - measuredHeight) / 2));
		}

		
		
		override public function get contentWidth():Number {
			return ( stage ? stage.stageWidth : 0 );
		}

		
		
		override public function get contentHeight():Number {
			return ( stage ? stage.stageHeight : 0 );
		}

		
		
		protected function onAdded(event:Event):void {
			stage.addEventListener(Event.RESIZE, onResizeStage, false, 0, true);
			onResizeStage(null);
		}

		
		
		protected function onResizeStage(event:Event):void {
			updateWidth();
			updateHeight();
			render();
		}

		
		
		protected function onRemoved(event:Event):void {
			stage.removeEventListener(Event.RESIZE, onResizeStage);
		}
	}
}
