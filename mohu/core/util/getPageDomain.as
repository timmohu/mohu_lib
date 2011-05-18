package mohu.core.util {
	import flash.external.ExternalInterface;

	/**
	 * @author Tim Kendrick
	 */
	public function getPageDomain():String {
		try {
			var url:String = ExternalInterface.call("function() { return document.location.href; }");
		}
		catch ( error:Error ) {
			return null; 
		}
		var protocolLength:int = url.indexOf("//") + 2;
		var domain:String = url.substr(protocolLength);
		return url.substr(0, protocolLength + domain.indexOf("/") + 1);
	}
}
