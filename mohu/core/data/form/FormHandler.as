package mohu.core.data.form {	import flash.events.Event;	import flash.events.EventDispatcher;	import flash.events.HTTPStatusEvent;	import flash.events.IOErrorEvent;	import flash.events.ProgressEvent;	import flash.events.SecurityErrorEvent;	import flash.net.URLLoader;	import flash.net.URLRequest;	import flash.net.URLRequestHeader;	import flash.net.URLRequestMethod;	import flash.net.URLVariables;	[Event (name="open", type="flash.events.Event")]	[Event (name="complete", type="flash.events.Event")]	[Event (name="progress", type="flash.events.ProgressEvent")]	[Event (name="securityError", type="flash.events.SecurityErrorEvent")]	[Event (name="ioError", type="flash.events.IOErrorEvent")]	[Event (name="httpStatus", type="flash.events.HTTPStatusEvent")]	public class FormHandler extends EventDispatcher implements IFormHandler {		public static const GET:String = URLRequestMethod.GET;		public static const POST:String = URLRequestMethod.POST;		private var _submitURL:String;		private var _method:String;		private var _dataFormat:String;		private var _contentType:String;		private var _headers:Array;		private var _varsObject:Object;		private var _lastResultObject:Object;		public function FormHandler( submitURL:String = null, vars:Object = null, method:String = "POST", dataFormat:String = "text", contentType:String = "application/x-www-form-urlencoded", requestHeaders:Array = null ) {			super();			_submitURL = submitURL;			_method = method;			_dataFormat = dataFormat;			_contentType = contentType;			this.headers = requestHeaders;			this.vars = vars;		}						public function submit():void {			if (!_submitURL) throw new ReferenceError("No Submit URL specified");			var loader:URLLoader = new URLLoader();			loader.dataFormat = _dataFormat;			loader.addEventListener(Event.OPEN, onRelayEvent);			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onRelayEvent);			loader.addEventListener(ProgressEvent.PROGRESS, onRelayEvent);			loader.addEventListener(Event.COMPLETE, onCompleteEvent);			loader.addEventListener(IOErrorEvent.IO_ERROR, onCompleteEvent);			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onCompleteEvent);						loader.load(this.getURLRequest());		}						private function onRelayEvent( event:Event ):void {			dispatchEvent(event);		}						private function onCompleteEvent( event:Event ):void {			var loader:URLLoader = event.currentTarget as URLLoader;			loader.removeEventListener(Event.OPEN, onRelayEvent);			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onRelayEvent);			loader.removeEventListener(ProgressEvent.PROGRESS, onRelayEvent);			loader.removeEventListener(Event.COMPLETE, onCompleteEvent);			loader.removeEventListener(IOErrorEvent.IO_ERROR, onCompleteEvent);			loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onCompleteEvent);						if ( event.type == Event.COMPLETE ) _lastResultObject = loader.data;			dispatchEvent(event);		}						protected function getURLRequest():URLRequest {			var request:URLRequest = new URLRequest();			request.url = _submitURL;			request.method = method;			for each (var header:URLRequestHeader in _headers) request.requestHeaders.push(header);			if (_contentType) request.contentType = _contentType;			request.data = getRequestData();			return request;		}						protected function getRequestData():Object {			var vars:URLVariables = new URLVariables();			for ( var key : String in _varsObject ) vars[( _varsObject[key] is Array ) ? key + "[]" : key] = _varsObject[key];			return vars;		}						protected function setLastResult( value:Object ):void {			_lastResultObject = value;		}						public function get submitURL():String {			return _submitURL;		}						public function get method():String {			return _method;		}						public function get contentType():String {			return _contentType;		}						public function get dataFormat():String {			return _dataFormat;		}						public function get headers():Array {			return _headers;		}						public function get vars():Object {			return _varsObject;		}						public function get lastResult():Object {			return _lastResultObject;		}						public function set submitURL( value:String ):void {			if ( !value ) throw new ArgumentError("No URL specified");			_submitURL = value;		}						public function set method( value:String ):void {			if ( !value ) throw new ArgumentError("No method specified");			value = value.toUpperCase();			if ( !( ( value == GET ) || ( value == POST ) ) ) throw new ArgumentError("Invalid method '" + value + "' - must be either 'GET' or 'POST'");			_method = value;		}						public function set contentType( value:String ):void {			_contentType = value;		}						public function set dataFormat( value:String ):void {			_dataFormat = value;		}						public function set headers( value:Array ):void {			var a:Array = [];			for each (var o:Object in value) if (!( o is URLRequestHeader )) throw new ArgumentError("Specified headers must contain only URLRequestHeaders");			_headers = a;		}						public function set vars(value:Object):void {			var o:Object = {};			for ( var s : String in value ) o[s] = value[s];			_varsObject = o;		}	}}