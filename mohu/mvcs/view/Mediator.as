package mohu.mvcs.view {
	import mohu.messages.Dispatcher;
	import mohu.mvcs.Context;
	import mohu.mvcs.Hub;
	import mohu.mvcs.injection.IInjectable;
	import mohu.mvcs.injection.IInjector;

	import flash.display.DisplayObject;

	/**
	 * @author Tim Kendrick
	 */
	public class Mediator implements IInjectable {

		[Inject("view")]

		public var viewComponent:DisplayObject;

		[Inject("context")]
		public var context:Context;

		[Inject("hub")]
		public var hub:Hub;

		[Inject]
		public var injector:IInjector;

		private var _onRegistered:Dispatcher;
		private var _onRemoved:Dispatcher;

		public function Mediator() {
			_onRegistered = new Dispatcher(this);
			_onRemoved = new Dispatcher(this);
		}

		public function onRegister():void {
			_onRegistered.dispatch();
		}

		public function onRemove():void {
			_onRemoved.dispatch();
		}

		public function get onRegistered():Dispatcher {
			return _onRegistered;
		}

		public function get onRemoved():Dispatcher {
			return _onRemoved;
		}
	}
}
