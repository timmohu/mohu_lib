package mohu.core.keyboard {
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * @author Tim Kendrick
	 */
	 
	public function fixAtSign( textField:TextField ):void {
		textField.addEventListener(Event.CHANGE, onChangeText);
		function onChangeText(event:Event):void {
			var tf:TextField = event.currentTarget as TextField;
			if (tf.text.indexOf("\"") != -1) tf.text = tf.text.replace(new RegExp("\"", "g"), "@");
		}
	}
}
