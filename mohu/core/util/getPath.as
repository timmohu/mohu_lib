package mohu.core.util {
	import flash.display.DisplayObject;

	/**
	 * @author Tim Kendrick
	 */
	public function getPath( displayObject:DisplayObject ):String {
		var url:String = displayObject.root.loaderInfo.url.replace(/\/\[\[DYNAMIC\]\]\/\d/g, "");
		return url.substr(0, url.lastIndexOf("/") + 1);
	}
}
