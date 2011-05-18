package mohu.core.util {
	import flash.external.ExternalInterface;

	/**
	 * @author Tim Kendrick
	 */
	public function getPagePath():String {
		try {
			var url:String = ExternalInterface.call("function() { return document.location.href; }");
		}
		catch ( error:Error ) {
			return null; 
		}
		return url.substr(0, url.lastIndexOf("/") + 1);
	}
}
