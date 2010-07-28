package cocktail.core.ui.media.gunz 
{
	import cocktail.core.gunz.Bullet;

	/**
	 * @author hems - henrique@cocktail.as
	 */
	public class VideoBullet extends Bullet 
	{
		public static const LOAD_START: String = "load_start";
		public static const LOAD_COMPLETE: String = "load_complete";
		public static const LOAD_ERROR: String = "error";

		public static const NET_STATUS: String = "net_status";
		public static const METADATA: String = "metadata";
		
		//audio types
		public static const MUTE: String = "mute";
		public static const UNMUTE: String = "unmute";
		
		//playback types
		public static const STOP: String = "stop";
		public static const PLAY: String = "play";
		public static const PAUSE : String = "pause";
		public static const TIME: String = "time";
		public static const SEEK: String = "seek";
		public static const BUFFER_EMPTY : String = "empty_buffer";
		public static const BUFFER_FULL : String = "full_buffer";

		public static const PLAY_COMPLETE : String = "PLAY_COMPLETE";
		
		public var info: Object;
		public var percent_played: Number;
		public var seconds_played: Number;
		public var seconds_total: Number;
		public var buffered: Number;
		
		public function get time_played() : String
		{
			var mins : Number = Math.floor( seconds_played / 60 );
			var secs : Number = Math.floor( seconds_played % 60 );
			
			return ( '0' + mins ).substr( - 2 ) + ':' + ( '0' + secs ).substr( - 2 );
		}
		
		public function get time_total() : String
		{
			var mins : Number = Math.floor( seconds_total / 60 );
			var secs : Number = Math.floor( seconds_total % 60 );
			
			return ( '0' + mins ).substr( - 2 ) + ':' + ( '0' + secs ).substr( - 2 );
		}
	}
}
