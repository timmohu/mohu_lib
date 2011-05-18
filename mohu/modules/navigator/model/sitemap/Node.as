package mohu.modules.navigator.model.sitemap {

	/**
	 * @author Tim Kendrick
	 */
	public class Node extends Object {

		private var _parent:Node;
		private var _childNodes:Vector.<Node>;
		private var _childNodeNames:Vector.<String>;

		public function Node() {
			super();
			_childNodes = new Vector.<Node>();
			_childNodeNames = new Vector.<String>();
		}

		public function addChildNode(node:Node, name:String):Node {
			if (!name) throw new ArgumentError("No node name specified");
			if (_childNodeNames.indexOf(name) != -1) throw new ArgumentError("The specified node name '" + name + "' already exists on this node");
			_childNodes.push(node);
			_childNodeNames.push(name);
			node._parent = this;
			return node;
		}

		public function removeChildNode(node:Node):Node {
			var index:int = _childNodes.indexOf(node);
			if (index == -1) throw new ArgumentError("The specified node is not a child of this node");
			_childNodes.splice(index, 1);
			_childNodeNames.splice(index, 1);
			node._parent = null;
			return node;
		}

		public function hasChildNode(name:String):Boolean {
			return (_childNodeNames.indexOf(name) != -1);
		}

		public function getChildNode(name:String):Node {
			return _childNodes[_childNodeNames.indexOf(name)];
		}

		public function getNodeName(childNode:Node):String {
			return _childNodeNames[_childNodes.indexOf(childNode)];
		}

		public function pathExists(path:Array):Boolean {
			if (!path || (path.length == 0)) return true;
			path = path.concat();
			var index:int = _childNodeNames.indexOf(path.shift());
			if (index == -1) return false;
			return _childNodes[index].pathExists(path);
		}

		public function getPath(path:Array):Node {
			if (!path || (path.length == 0)) return this;
			path = path.concat();
			var index:int = _childNodeNames.indexOf(path.shift());
			if (index == -1) return null;
			return _childNodes[index].getPath(path);
		}

		public function get parent():Node {
			return _parent;
		}

		public function get children():Vector.<Node> {
			return _childNodes.concat();
		}

		public function get numChildren():uint {
			return _childNodes.length;
		}
	}
}
