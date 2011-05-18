package mohu.core.injection {

	/**
	 * @author Tim Kendrick
	 */
	public class ValueInjector {

		private var _source:Object;
		private var _sourceField:String;
		private var _target:Object;
		private var _targetField:String;

		public function set source( value:Object):void {
			_source = value;
		}

		public function set sourceField( value:String ):void {
			_sourceField = value;
		}

		
		public function set target( value:Object ):void {
			_target = value;
		}

		public function set targetField( value:String ):void {
			_targetField = value;
			_target[ _targetField ] = _source[ _sourceField ];
		}
	}
}
