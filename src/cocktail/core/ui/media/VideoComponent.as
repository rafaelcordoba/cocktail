package cocktail.core.ui.media 
{
	import cocktail.core.Index;
	import cocktail.core.gunz.Gun;
	import cocktail.core.gunz.Gunz;
	import cocktail.core.logger.Logger;
	import cocktail.core.ui.media.gunz.VideoBullet;

	import gs.TweenMax;

	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;

	/**
	 * @author hems : hems@cocktail.as
	 */
	public class VideoComponent
	{
		private const DEFAULT_TIMER_DELAY : Number = 30;

		private var _video : Video;
		private var _player : Sprite;
		private var _nc : NetConnection;
		private var _ns : NetStream;
		private var _sound : SoundTransform;
		private var _video_duration : Number;
		private var _volume_before_mute : Number;
		private var _buffer_time : Number;
		private var _is_muted : Boolean;
		private var _playhead_timer : Timer;
		private var gunz : Gunz;
		private var client_listener : Object;

		public var is_playing : Boolean;
		public var video_width : Number;
		public var video_height : Number;
		public var video_volume : Number;
		
		public var on_time : Gun;
		public var gunz_play : Gun;
		public var gunz_pause : Gun;
		public var gunz_stop : Gun;
		public var gunz_seek : Gun;
		public var gunz_mute : Gun;
		public var gunz_unmute : Gun;
		public var gunz_net_status : Gun;
		public var gunz_on_metadata : Gun;
		public var gunz_load_error : Gun;
		public var gunz_bufer_full : Gun;
		public var gunz_buffer_empty : Gun;
		public var gunz_play_complete : Gun;

		public function VideoComponent( 
			scope : Sprite = null, 
			width : Number = NaN, 
			height : Number = NaN,
			buffer : Number = 3,
			volume : Number = 1 
		)
		{
			_get_gunz();
			
			//video init
			_video = new Video( );
			//video.smoothing = true;
			_video.smoothing  = false;
			_video.deblocking = 0;
			
			_buffer_time = buffer ? buffer : 3;
			
			if( width ) 
				video_width = width;
			
			if( height )
				video_height = height;
			
			if( scope )
				player = scope;
			
			//loading init
			_nc = new NetConnection( );
			_nc.connect( null );
			
			_ns = new NetStream( _nc );
			_ns.bufferTime = _buffer_time;
			_ns.addEventListener( NetStatusEvent.NET_STATUS, _on_net_status );
			_ns.soundTransform = _sound = new SoundTransform( );
			
			video_volume = volume;
			
			//initial status
			is_playing = false;
			_set_triggers( );
		}
		
		private function _get_gunz() : void 
		{
			gunz = new Gunz( this );
			on_time          = new Gun( gunz, this, VideoBullet.TIME ); 
			gunz_play          = new Gun( gunz, this, VideoBullet.PLAY );
			gunz_pause         = new Gun( gunz, this, VideoBullet.PAUSE );
			gunz_stop          = new Gun( gunz, this, VideoBullet.STOP );
			gunz_seek          = new Gun( gunz, this, VideoBullet.SEEK );
			gunz_mute          = new Gun( gunz, this, VideoBullet.MUTE );
			gunz_unmute        = new Gun( gunz, this, VideoBullet.UNMUTE );
			gunz_net_status    = new Gun( gunz, this, VideoBullet.NET_STATUS );
			gunz_on_metadata   = new Gun( gunz, this, VideoBullet.METADATA );
			gunz_load_error    = new Gun( gunz, this, VideoBullet.LOAD_ERROR );
			gunz_bufer_full    = new Gun( gunz, this, VideoBullet.BUFFER_FULL );
			gunz_buffer_empty  = new Gun( gunz, this, VideoBullet.BUFFER_EMPTY );
			gunz_play_complete = new Gun( gunz, this, VideoBullet.PLAY_COMPLETE );
		}

		private function _set_triggers() : void
		{
			_playhead_timer = new Timer( DEFAULT_TIMER_DELAY );
			_playhead_timer.stop( );
			_playhead_timer.addEventListener( TimerEvent.TIMER, _pull_time );
		}

		private function _unset_triggers() : void
		{
			gunz.destroy();
			
			_playhead_timer.stop( );
			_playhead_timer.removeEventListener( TimerEvent.TIMER, _pull_time );
		}

		public function destroy() : void
		{
			_unset_triggers( );
			_ns.close( );
			_video.clear( );
			_nc.close( );
		}

		
		
		/** events **/

		
		private function _pull_time(event : TimerEvent) : void
		{
			on_time.shoot( _drop() );
		}

		private function _drop(): VideoBullet
		{
			var bullet: VideoBullet;
			
			bullet = new VideoBullet();
			bullet.seconds_played = time;
			bullet.percent_played = played_pct;
			bullet.buffered = buffered;
			bullet.seconds_total = duration;
			
			return bullet;			
		}
		
		
		/** video controls **/

		
		
		public function load( path : String ) : void
		{
			//net stream
			
			_video.attachNetStream( _ns );
			
			_ns.play( path );
			
			stop( false );
		}

		public function attach_ns( ns : NetStream ) : void
		{
			client_listener = new Object();
			client_listener[ 'onMetaData' ] = onMetaDataHandler;
			
			_ns = ns;
			_ns.bufferTime = _buffer_time;
			_ns.client = client_listener;
			_ns.addEventListener( NetStatusEvent.NET_STATUS, _on_net_status );
			_ns.soundTransform = _sound = new SoundTransform( );
			
			_video.attachNetStream( _ns );
		}
		
		public function onMetaDataHandler( info : Object ) : void 
		{
			if ( isNaN( video_width ) )
				video_width = info[ "width" ];
			
			if( isNaN( video_height ) )
				video_height = info[ "height" ];
				
			_video_duration = Math.round( info[ "duration" ] * 100 ) / 100;
			
			_video.width = video_width;
			_video.height = video_height;
			
			volume = video_volume;
			
			var bullet : VideoBullet;
			bullet = _drop();
			
			gunz_on_metadata.shoot( bullet );
		}

		public function unload() : void 
		{
			_ns.play( '' );
		}

		public function play( ...args ) : void
		{
			is_playing = true;
			_ns.resume( );
			
			_playhead_timer.stop( );
			_playhead_timer.start( );
			
			gunz_play.shoot( _drop() );
		}

		public function pause( ...args ) : void
		{
			is_playing = false;
		
			_ns.pause( );
			
			//_playhead_timer.stop( );
			
			gunz_pause.shoot( _drop() );
		}

		public function stop( pull_bullet : Boolean = true ) : void
		{
			is_playing = false;
			_ns.seek( 0 );
			_ns.pause( );
			
			_playhead_timer.stop( );
			
			if( pull_bullet )
				gunz_stop.shoot( _drop() );
		}

		public function seek( percentage : Number, play: Boolean = false ) : void
		{
			percentage = Math.floor( percentage * 1000 ) / 1000;
			 
			var bullet : VideoBullet;
			var seconds : Number;
			var pct_loaded : Number;
			
			pct_loaded = bytes_loaded / bytes_total;
			
			if ( percentage > pct_loaded )
				percentage = pct_loaded;
				
			seconds = Math.floor( percentage * duration );
			
			_ns.seek( seconds );
			
			if( play)
				_ns.resume();
			else
				_ns.pause();
			
			bullet = _drop();
			
			gunz_seek.shoot( bullet );
		}

		/** audio controls **/

		
		
		public function mute() : void
		{
			_volume_before_mute = _sound.volume;
			_is_muted = true;
				
			TweenMax.to( this, .3, {
				volume: 0
			} );
			
			gunz_mute.shoot( _drop() );
		}

		public function unmute() : void
		{
			_is_muted = false;
			
			TweenMax.to( this, .3, {
				volume: _volume_before_mute
			} );
			
			gunz_unmute.shoot( _drop() );
		}

		
		
		/** internal handlers **/

		
		
		private function _on_net_status( event : NetStatusEvent ) : void
		{
			var bullet : VideoBullet;
			
			bullet = _drop();
			bullet.info = event.info;
			
			bullet = _drop();
			bullet.info = event.info;
			
			switch( event.info[ 'code' ] )
			{
				case "NetStream.Play.StreamNotFound":
					gunz_load_error.shoot( bullet );
				break;
				
				case "NetStream.Buffer.Full":
					_ns.bufferTime = 1;
					gunz_bufer_full.shoot( bullet );
				break;
		
				case "NetStream.Buffer.Empty":
					_ns.bufferTime = _buffer_time;
					gunz_buffer_empty.shoot( bullet );
				break;
				
				case "NetStream.Play.Stop":
					if( !is_playing )
						gunz_stop.shoot( bullet );
					else
						gunz_play_complete.shoot( bullet );
				break;
				
				case "NetStream.Seek.InvalidTime":
					trace( '############', 'NetStream.Seek.InvalidTime' );
					_ns.seek( Number( event.info[ 'details' ] ) );
					_ns.resume();
				break;
			}
			
			gunz_net_status.shoot( bullet );
		}

		
		
		/** info getters / setters **/

		
		
		public function set volume( number : Number ) : void
		{
			_sound.volume = number;
			_ns.soundTransform = _sound;
		}

		public function get volume() : Number
		{
			return _sound.volume;
		}

		public function get is_muted() : Boolean
		{
			return _is_muted;
		}

		/**
		 * @return Buffered value, from 0 to 1
		 */
		public function get buffered() : Number
		{
			return _ns.bytesLoaded / _ns.bytesTotal;
		}

		/**
		 * @return NetStream::bytesLoaded
		 */
		public function get bytes_loaded() : Number
		{
			return _ns.bytesLoaded;
		}

		/**
		 * @return NetStream::bytesTotal
		 */
		public function get bytes_total() : Number
		{
			return _ns.bytesTotal;
		}

		/*
		 * @return Played time, from 0 to 1
		 */
		public function get played_pct() : Number
		{
			return time / duration;
		}

		/**
		 * @return Played time in secs
		 */
		public function get time() : Number
		{
			return _ns.time;
		}

		/**
		 * @return Duration of the current playing video. 
		 * You need to wait the Meta Data event 
		 */
		public function get duration() : Number
		{
			return _video_duration; 
		}

		public function set PROGRESS_INTERVAL( ms : Number ) : void
		{
			_playhead_timer.delay = ms;
		}

		public function get PROGRESS_INTERVAL() : Number
		{
			return _playhead_timer.delay;
		}

		
		
		/** asset getter / setter **/

		
		
		public function get video() : Video
		{
			return _video;
		}

		public function get player() : Sprite
		{
			if ( _player )
				return _player;
			else
				return null;
		}

		public function set player( scope : Sprite ) : void
		{
			scope.addChild( _video );
			
			_player = scope;
		}
		
	}
}