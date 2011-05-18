package mohu.modules.cms.services {
	import mohu.mvcs.service.Service;

	import com.adobe.serialization.json.JSON;

	import flash.errors.IOError;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Tim Kendrick
	 */
	public class CMSDataService extends Service {

		private static const VECTOR_CLASS_NAME:String = getQualifiedClassName(Vector) + ".<*>";

		private var _items:Object;
		private var _indices:Dictionary;

		public function load(data:String, typeMap:Object = null):* {
			if (!typeMap) typeMap = {};

			var response:Object = JSON.decode(data);
			if (!response.success) throw new IOError(response.data);
			
			var rootItem:Object = response.data;

			_items = {};
			_indices = new Dictionary(true);

			for each (var item : Object in rootItem.references) cacheItem(item.id, item.dataType, typeMap, rootItem.references, _items, _indices);

			return _items[rootItem.id];
		}

		private function cacheItem(id:int, dataType:String, typeMap:Object, items:Object, linkedItems:Object, indices:Dictionary):* {
			if (linkedItems[id]) return linkedItems[id];

			var itemClass:Class = (typeMap[dataType] ? typeMap[dataType] : Object);
			var item:* = new itemClass();

			linkedItems[id] = item;
			indices[item] = id;

			for (var field : String in items[id].value) {
				var property:Object = items[id].value[field];
				if (property && (property.constructor == Object)) {
					switch (property.type) {
						case "reference":
							property = cacheItem(property.id, property.dataType, typeMap, items, linkedItems, indices);
							break;

						case "list":
						case "smartlist":
							var listClass:Class = typeMap[property.dataType];
							var listItems:* = (listClass ? new (getDefinitionByName(VECTOR_CLASS_NAME.replace("*", getQualifiedClassName(listClass)))) : []);
							for each (var listID : int in property.items) listItems.push(cacheItem(listID, property.dataType, typeMap, items, linkedItems, indices));
							property = listItems;
							break;
					}
				}
				item[field] = property;
			}
			return item;
		}

		public function get items():Object {
			return _items;
		}

		public function get indices():Dictionary {
			return _indices;
		}
	}
}
