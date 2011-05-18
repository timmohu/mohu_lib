package mohu.core.data.amf {

	/**
	 * @author Tim Kendrick
	 */
	public class AMFOperation extends Object {

		public var service:String;
		public var operation:String;
		public var arguments:Array;
		public var onComplete:Function;
		public var onFault:Function;
		public var success:Boolean;
		public var result:Object;

		public function AMFOperation( service:String, operation:String, arguments:Array, onComplete:Function, onFault:Function ) {
			this.service = service;
			this.operation = operation;
			this.arguments = arguments;
			this.onComplete = onComplete;
			this.onFault = onFault;
		}
	}
}
