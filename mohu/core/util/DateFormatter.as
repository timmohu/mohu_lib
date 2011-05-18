package mohu.core.util {

	/**
	 * @author Tim Kendrick
	 */
	public class DateFormatter extends Object {

		public static var DAYS:Array = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
		public static var DAYS_SHORT:Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		public static var MONTHS:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		public static var MONTHS_SHORT:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

		private var _source:String;
		private var _days:Array;
		private var _months:Array;
		private var _am:String;
		private var _pm:String;

		public function DateFormatter(source:String, days:Array = null, months:Array = null, am:String = "am", pm:String = "pm") {
			super();
			_source = source;
			_days = days ? days : DAYS;
			_months = months ? months : MONTHS;
			_am = am;
			_pm = pm;
			if (_days.length != 7) throw new ArgumentError("Specified days array contains '" + _days.length + "' items"); 
			if (_months.length != 12) throw new ArgumentError("Specified months array contains '" + _days.length + "' items"); 
		}

		
		
		public function format(date:Date):String { 
			return _source
				.replace(/DD/g, (date.date < 10 ? "0" : "") + date.date)
				.replace(/D/g, date.date)
				.replace(/MM/g, (date.month + 1 < 10 ? "0" : "") + (date.month + 1))
				.replace(/M/g, (date.month + 1))
				.replace(/YYYY/g, date.fullYear)
				.replace(/YY/g, date.fullYear % 100)
				.replace(/HH/g, (date.hours < 10 ? "0" : "") + date.hours)
				.replace(/H/g, date.hours)
				.replace(/hh/g, (date.hours == 12 ? "12" : ((date.hours % 12 < 10 ? "0" : "") + date.hours % 12)))
				.replace(/h/g, (date.hours == 12 ? "12" : date.hours % 12))
				.replace(/NN/g, (date.minutes < 10 ? "0" : "") + date.minutes)
				.replace(/N/g, date.minutes)
				.replace(/SS/g, (date.seconds < 10 ? "0" : "") + date.seconds)
				.replace(/S/g, date.seconds)
				.replace(/d/g, _days[date.day])
				.replace(/m/g, _months[date.month])
				.replace(/ap/g, date.hours < 12 ? "am" : "pm");
		}

		
		
		public function get days():Array {
			return _days;
		}

		
		
		public function set days(value:Array):void {
			_days = value;
		}

		
		
		public function get months():Array {
			return _months;
		}

		
		
		public function set months(value:Array):void {
			_months = value;
		}

		
		
		public function get source():String {
			return _source;
		}

		
		
		public function set source(value:String):void {
			_source = value;
		}

		
		
		public function get am():String {
			return _am;
		}

		
		
		public function set am(value:String):void {
			_am = value;
		}

		
		
		public function get pm():String {
			return _pm;
		}

		
		
		public function set pm(value:String):void {
			_pm = value;
		}
	}
}
