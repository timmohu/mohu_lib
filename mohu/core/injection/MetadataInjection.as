package mohu.core.injection {
	import flash.utils.Dictionary;
	import flash.utils.describeType;

	/**
	 * @author Tim Kendrick
	 */
	public class MetadataInjection {

		private static var _typeSchemas:Dictionary = new Dictionary();

		public static function injectInto( instance:Object , tag:String , value:* ):Object {
			var objectClass:Class = instance.constructor as Class;
			var typeSchema:XML = ( _typeSchemas[ objectClass ] || ( _typeSchemas[ objectClass ] = describeType(objectClass) ) );
			for each ( var variable : XML in typeSchema.factory.variable ) {
				for each ( var metadata : XML in variable.metadata ) {
					if ( metadata.@name.toString() == tag ) instance[ variable.@name.toString() ] = value;
				}
			}
			return instance;
		}

		public static function extractFrom( instance:Object , tag:String ):* {
			var objectClass:Class = instance.constructor as Class;
			var typeSchema:XML = ( _typeSchemas[ objectClass ] || ( _typeSchemas[ objectClass ] = describeType(objectClass) ) );
			for each ( var variable : XML in typeSchema.factory.variable ) if ( variable.metadata.@name.toString() == tag ) return instance[ variable.@name.toString() ];
			return null;
		}
	}
}
