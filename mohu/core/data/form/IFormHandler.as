package mohu.core.data.form {	import flash.events.IEventDispatcher;	[Event (name="open", type="flash.events.Event")]	[Event (name="complete", type="flash.events.Event")]	[Event (name="progress", type="flash.events.ProgressEvent")]	[Event (name="securityError", type="flash.events.SecurityErrorEvent")]	[Event (name="ioError", type="flash.events.IOErrorEvent")]	[Event (name="httpStatus", type="flash.events.HTTPStatusEvent")]	public interface IFormHandler extends IEventDispatcher {		function submit():void;						function get submitURL():String;						function get method():String;						function get contentType():String;						function get dataFormat():String;						function get headers():Array;						function get vars():Object;						function get lastResult():Object;						function set submitURL(_value:String):void;						function set method(_value:String):void;						function set contentType(_value:String):void;						function set dataFormat(_value:String):void;						function set headers(_value:Array):void;						function set vars(_value:Object):void;	}}