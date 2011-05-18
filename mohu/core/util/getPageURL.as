package mohu.core.util {
	import flash.external.ExternalInterface;

	/**
	 * @author Tim Kendrick
	 */
	public function getPageURL():String {
		try {
			var url:String = ExternalInterface.call("function() { return document.location.href; }");
		}
		catch ( error:Error ) {
			return null; 
		}
		return url;
	}
}
