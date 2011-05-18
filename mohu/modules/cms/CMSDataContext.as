package mohu.modules.cms {
	import mohu.modules.cms.controller.CMSLoadDataCommand;
	import mohu.modules.cms.messages.CMSDataLoadMessage;
	import mohu.modules.cms.model.CMSDataModel;
	import mohu.modules.cms.services.CMSDataService;
	import mohu.mvcs.Context;

	/**
	 * @author Tim Kendrick
	 */
	public class CMSDataContext extends Context {

		private var _model:CMSDataModel;

		public function CMSDataContext() {
			super(new CMSDataHub());
			
			_initModel();
			_initView();
			_initController();
			_initServices();
		}

		private function _initModel():void {
			var hub:CMSDataHub = this.hub as CMSDataHub;
			
			_model = new CMSDataModel();
			_model.onDataLoaded.addListener(hub.onDataLoaded.dispatch);
			
			this.injector.mapClassInstance(CMSDataModel, _model);
		}

		private function _initView():void {
		}

		private function _initController():void {
			var hub:CMSDataHub = this.hub as CMSDataHub;
			
			commandMap.mapCommand(hub.loadData, CMSLoadDataCommand);
		}

		private function _initServices():void {
			this.injector.mapClass(CMSDataService);
		}

		public function startup(data:String, typeMap:Object):void {
			_model.typeMap = typeMap;
			(this.hub as CMSDataHub).loadData.dispatch(new CMSDataLoadMessage(data, typeMap));
		}
	}
}
