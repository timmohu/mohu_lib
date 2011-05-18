package mohu.modules.cms.controller {
	import mohu.modules.cms.messages.CMSDataLoadMessage;
	import mohu.modules.cms.model.CMSDataModel;
	import mohu.modules.cms.services.CMSDataService;
	import mohu.mvcs.controller.Command;

	/**
	 * @author Tim Kendrick
	 */
	public class CMSLoadDataCommand extends Command {

		[Inject("message")]

		public var cmsDataLoadMessage:CMSDataLoadMessage;

		[Inject]
		public var service:CMSDataService;

		[Inject]
		public var cmsDataModel:CMSDataModel;

		override public function execute():void {
			cmsDataModel.init(service.load(cmsDataLoadMessage.data, cmsDataLoadMessage.typeMap), service.items, service.indices);
		}
	}
}
