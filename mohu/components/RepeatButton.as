package mohu.components {
	import mohu.components.controllers.RepeatButtonController;

	/**
	 * @author Tim Kendrick
	 */
	public class RepeatButton extends Button {

		private var _controller:RepeatButtonController;

		public function RepeatButton( delay:int = 400 , interval:int = 40 , acceleration:Number = 1 , minInterval:int = 5 ) {
			super();
			
			_controller = new RepeatButtonController(delay, interval, acceleration, minInterval, this);
		}
	}
}
