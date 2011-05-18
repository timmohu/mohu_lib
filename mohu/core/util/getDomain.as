package mohu.core.util {
	import flash.display.DisplayObject;

	/**
	 * @author Tim Kendrick
	 */
	public function getDomain( displayObject:DisplayObject ):String {
		var url:String = displayObject.root.loaderInfo.url.replace(/\/\[\[DYNAMIC\]\]\/\d/g, "");
		var protocolLength:int = url.indexOf("//") + 2;
		var domain:String = url.substr(protocolLength);
		return url.substr(0, protocolLength + domain.indexOf("/") + 1);
	}
}
