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
		
		public var seek: Number;
		public var info: Object;
		public var played: Number;
		public var buffered: Number;

	}
}
