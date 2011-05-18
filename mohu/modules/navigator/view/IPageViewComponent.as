package mohu.modules.navigator.view {
	import flash.display.DisplayObjectContainer;

	/**
	 * @author Tim Kendrick
	 */
	public interface IPageViewComponent {

		function show():void;

		function hide():void;

		function get childContainer():DisplayObjectContainer;

		function set childContainer(value:DisplayObjectContainer):void;
	}
}
