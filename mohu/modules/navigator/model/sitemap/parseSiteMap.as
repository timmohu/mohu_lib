package mohu.modules.navigator.model.sitemap {
	import mohu.modules.navigator.view.page.PageTransitions;

	import flash.utils.getDefinitionByName;

	/**
	 * @author Tim Kendrick
	 */

	/*
	 * Example XML:
	 * 
	 * 	<page viewComponent="assets.pages.root.RootPageViewComponent">
	 * 		<page name="home" viewComponent="assets.pages.home.HomePageViewComponent" title="Home" data="Custom page data"/>
	 *  	<page name="news" viewComponent="assets.pages.news.NewsPageViewComponent" title="News" transitions="assets.pages.news.NewsPageTransitions" childTransitionSequence="UNLOAD_FIRST">
	 *  		<page name="article" viewComponent="assets.pages.news.ArticlePageViewComponent"/>
	 *  	</page>
	 * 	</page>
	 * 
	 * 
	 */

	public function parseSiteMap(siteMap:XML, defaultChildTransitionSequence:String = "UNLOAD_FIRST"):PageNode {

		var graphicsClass:Class = getDefinitionByName(siteMap.@viewComponent.toString()) as Class;

		var title:String = siteMap.hasOwnProperty("@title") ? siteMap.@title.toString() : null;

		if (siteMap.@transitions.toString()) var transitions:PageTransitions = new (getDefinitionByName(siteMap.@transitions.toString()))();

		var childTransitionSequence:String = siteMap.@childTransitionSequence.toString() || defaultChildTransitionSequence;

		var data:String = siteMap.@data.toString();

		var node:PageNode = new PageNode(graphicsClass, title, transitions, childTransitionSequence, data);

		for each (var child:XML in siteMap.page) node.addChildNode(parseSiteMap(child), child.@name.toString());

		return node;
	}
}
