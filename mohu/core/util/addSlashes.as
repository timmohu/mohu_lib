package mohu.core.util {

	/**
	 * @author Tim Kendrick
	 */
	public function addSlashes( string:String ):String {
		return string.replace(/([\\\/"])/g, "\\$1").replace(/\f/g, "\\f").replace(/\n/g, "\\n").replace(/\r/g, "\\r").replace(/\t/g, "\\t");
	}
}
