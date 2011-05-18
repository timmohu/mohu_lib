package mohu.modules.deeplink.model {
	import mohu.messages.Dispatcher;

	import flash.external.ExternalInterface;

	/**
	 * @author Tim Kendrick
	 */
	public class DeepLinker {

		private static const JAVASCRIPT:String = <xml><![CDATA[

			function() {

				if (typeof(DeepLinker) == 'undefined')
				{
	
					DeepLinker = new function ()
					{
		
						this.interval = NaN;
						this.intervalID = NaN;
						this.targets = [];
						this.url = null;
	
						this.addTarget = function (id, interval)
						{
							DeepLinker.targets.push(id);
							if (isNaN(DeepLinker.interval) || (interval < DeepLinker.interval))
							{
								if (!isNaN(DeepLinker.intervalID)) clearInterval(DeepLinker.intervalID);
								DeepLinker.interval = interval;
								DeepLinker.intervalID = setInterval(DeepLinker.check, interval);
							}
							DeepLinker.check();
						}

						this.removeTarget = function (id)
						{
							DeepLinker.targets.splice(DeepLinker.targets.indexOf(id), 1);
							if (DeepLinker.targets.length == 0)
							{
								if (!isNaN(DeepLinker.intervalID)) clearInterval(DeepLinker.intervalID);
								DeepLinker.interval = NaN;
								DeepLinker.intervalID = NaN;
								DeepLinker.url = null;
							}
						}

						this.check = function ()
						{
							if (document.location.href == DeepLinker.url) return;
							DeepLinker.url = document.location.href;
							var index = document.location.href.indexOf('#');
							var path = (index == -1 ? '' : document.location.href.substr(index + 1));
							for (var i = 0 ; i < DeepLinker.targets.length ; i++) document.getElementById(DeepLinker.targets[i]).__onDeepLinkUpdate(path);
						};

						this.go = function (path)
						{
							var url = document.location.href;
							var index = url.indexOf('#');
							if (index != -1) url = url.substr(0, index);
							document.location.href = url + '#' + path;
							DeepLinker.check();
						};

						this.forward = function (pages)
						{
							history.go(pages);
							DeepLinker.check();
						};

						this.back = function (pages)
						{
							history.go(-pages);
							DeepLinker.check();
						};

						this.replace = function (path)
						{
							var url = document.location.href;
							var index = url.indexOf('#');
							if (index != -1) url = url.substr(0, index);
							document.location.replace(url + '#' + path);
							DeepLinker.check();
						};
					};
	
				}
	
				return true;
			}

		]]></xml>.toString();

		private static const JAVASCRIPT_CLASS:String = "DeepLinker";
		private static const JAVASCRIPT_CALLBACK:String = "__handleDeepLinkUpdated";

		private static var initialised:Boolean;

		private var _currentPath:String = "";
		private var _pathPrefix:String;
		private var _onChanged:Dispatcher;

		public function DeepLinker(pathPrefix:String = "", updateDelay:int = 100) {
			if (!ExternalInterface.objectID) throw new Error("No object ID specified for ExternalInterface");

			_pathPrefix = pathPrefix ? pathPrefix : "";

			_onChanged = new Dispatcher(this);

			try {
				if (!initialised) initialised = ExternalInterface.call(JAVASCRIPT);

				ExternalInterface.addCallback(JAVASCRIPT_CALLBACK, _handleUpdated);
				ExternalInterface.call(JAVASCRIPT_CLASS + ".addTarget", ExternalInterface.objectID, updateDelay);

				_currentPath = ExternalInterface.call("function() { var index = document.location.href.indexOf('#'); return (index == -1 ? '' : document.location.href.substr(index + 1)); }");
				if (_currentPath && (_currentPath.indexOf(_pathPrefix) == 0)) _currentPath = _currentPath.substr(_pathPrefix.length);
			}
			catch (error:Error) { 
			}
		}

		public function destroy():void {
			try {
				ExternalInterface.call(JAVASCRIPT_CLASS + ".removeTarget", ExternalInterface.objectID);
			}
			catch (error:Error) {
			}
		}

		private function _handleUpdated(path:String):void {
			if (_pathPrefix && (path.indexOf(_pathPrefix) == 0)) path = path.substr(_pathPrefix.length);
			if (_currentPath == path) return;
			_currentPath = path;
			_onChanged.dispatch();
		}

		public function go(path:String):void {
			_updateAddress("go", _pathPrefix + path);
		}

		public function back(pages:int = 1):void {
			_updateAddress("back", pages);
		}

		public function forward(pages:int = 1):void {
			_updateAddress("forward", pages);
		}

		public function replace(path:String):void {
			_updateAddress("replace", _pathPrefix + path);
		}

		public function get currentPath():String {
			return _currentPath;
		}

		private function _updateAddress(functionName:String, parameter:*):void {
			if (!initialised) return;
			try {
				ExternalInterface.call(JAVASCRIPT_CLASS + "." + functionName, parameter);
			}
			catch (error:Error) { 
			}
		}

		public function get onChanged():Dispatcher {
			return _onChanged;
		}
	}
}
