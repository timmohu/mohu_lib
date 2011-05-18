package mohu.core.data.preloader {
	import mohu.messages.Dispatcher;

	import flash.net.URLRequest;

	/**
	 * @author Tim Kendrick
	 */

	public interface IPreloaderAsset {

		function load( ):void;		

		
		
		function get url( ):URLRequest;

		
		
		function get data( ):*;

		
		
		function get bytesLoaded( ):int;

		
		
		function get bytesTotal( ):int;

		
		
		function get progress( ):Number;

		
		
		function get onProgress( ):Dispatcher;

		
		
		function get onComplete( ):Dispatcher;

		
		
		function get onError( ):Dispatcher;
	}
}
