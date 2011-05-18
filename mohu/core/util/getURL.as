package mohu.core.util {
	import flash.display.DisplayObject;

	/**
	 * @author Tim Kendrick
	 */
	public function getURL( displayObject:DisplayObject ):String {
		return displayObject.root.loaderInfo.url.replace(/\/\[\[DYNAMIC\]\]\/\d/g, "");
	}
}
