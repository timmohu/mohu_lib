package mohu.modules.cms.model {
	import mohu.messages.Dispatcher;
	import mohu.mvcs.model.Model;

	import flash.utils.Dictionary;

	/**
	 * @author Tim Kendrick
	 */
	public class CMSDataModel extends Model {

		public var typeMap:Object;

		public var root:*;
		public var items:Object;
		public var indices:Dictionary;

		private var _onDataLoaded:Dispatcher;

		public function CMSDataModel() {
			_onDataLoaded = new Dispatcher(this);
		}

		public function init(root:*, items:Object, indices:Dictionary):CMSDataModel {
			this.root = root;
			this.items = items;
			this.indices = indices;
			_onDataLoaded.dispatch();
			return this;
		}

		public function getItem(id:int):* {
			return items[id];
		}

		public function getItemID(item:*):int {
			return (indices[item] == null ? -1 : indices[item]);
		}

		public function get onDataLoaded():Dispatcher {
			return _onDataLoaded;
		}
	}
}
