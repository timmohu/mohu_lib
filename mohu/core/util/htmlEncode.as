package mohu.core.util {
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	/**
	 * @author Tim Kendrick
	 */
	public function htmlEncode( string:String ):String {
		return new XMLNode(XMLNodeType.TEXT_NODE, string).toString();
	}
}
