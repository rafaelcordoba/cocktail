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
		public var on_play : Gun;
		public var on_pause : Gun;
		public var on_stop : Gun;
		public var on_seek : Gun;
		public var on_mute : Gun;
		public var on_unmute : Gun;
		public var on_net_status : Gun;
		public var on_metadata : Gun;
		public var on_load_error : Gun;
		public var on_bufer_full : Gun;
		public var on_buffer_empty : Gun;
		public var on_play_complete : Gun;

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
			gunz 			 = new Gunz( this );
			on_time          = new Gun( gunz, this, VideoBullet.TIME ); 
			on_play          = new Gun( gunz, this, VideoBullet.PLAY );
			on_pause         = new Gun( gunz, this, VideoBullet.PAUSE );
			on_stop          = new Gun( gunz, this, VideoBullet.STOP );
			on_seek          = new Gun( gunz, this, VideoBullet.SEEK );
			on_mute          = new Gun( gunz, this, VideoBullet.MUTE );
			on_unmute        = new Gun( gunz, this, VideoBullet.UNMUTE );
			on_net_status    = new Gun( gunz, this, VideoBullet.NET_STATUS );
			on_metadata  	 = new Gun( gunz, this, VideoBullet.METADATA );
			on_load_error    = new Gun( gunz, this, VideoBullet.LOAD_ERROR );
			on_bufer_full    = new Gun( gunz, this, VideoBullet.BUFFER_FULL );
			on_buffer_empty  = new Gun( gunz, this, VideoBullet.BUFFER_EMPTY );
			on_play_complete = new Gun( gunz, this, VideoBullet.PLAY_COMPLETE );
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
			
			on_metadata.shoot( bullet );
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
			
			on_play.shoot( _drop() );
		}

		public function pause( ...args ) : void
		{
			is_playing = false;
		
			_ns.pause( );
			
			//_playhead_timer.stop( );
			
			on_pause.shoot( _drop() );
		}

		public function stop( pull_bullet : Boolean = true ) : void
		{
			is_playing = false;
			_ns.seek( 0 );
			_ns.pause( );
			
			_playhead_timer.stop( );
			
			if( pull_bullet )
				on_stop.shoot( _drop() );
		}

		public function seek( percentage : Number ) : void
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
			
			if( is_playing )
				_ns.resume();
			else
				_ns.pause();
			
			bullet = _drop();
			
			on_seek.shoot( bullet );
		}

		/** audio controls **/

		
		
		public function mute() : void
		{
			_volume_before_mute = _sound.volume;
			_is_muted = true;
				
			TweenMax.to( this, .3, {
				volume: 0
			} );
			
			on_mute.shoot( _drop() );
		}

		public function unmute() : void
		{
			_is_muted = false;
			
			TweenMax.to( this, .3, {
				volume: _volume_before_mute
			} );
			
			on_unmute.shoot( _drop() );
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
					on_load_error.shoot( bullet );
				break;
				
				case "NetStream.Buffer.Full":
					_ns.bufferTime = 1;
					on_bufer_full.shoot( bullet );
				break;
		
				case "NetStream.Buffer.Empty":
					_ns.bufferTime = _buffer_time;
					on_buffer_empty.shoot( bullet );
				break;
				
				case "NetStream.Play.Stop":
					if( !is_playing )
						on_stop.shoot( bullet );
					else
						on_play_complete.shoot( bullet );
				break;
				
				case "NetStream.Seek.InvalidTime":
					
					// Seeking to last valid time
					_ns.seek( Number( event.info[ 'details' ] ) );
					
					if ( is_playing )
						_ns.resume();
					else
						_ns.pause();
				break;
			}
			
			on_net_status.shoot( bullet );
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