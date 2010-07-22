package cocktail.lib.views 
{
	import cocktail.core.slave.gunz.ASlaveBullet;
	import cocktail.core.slave.slaves.VideoSlave;
	import cocktail.core.ui.media.VideoComponent;

	/**
	 * @author rafaelcordoba - rafael@rafaelcordoba.com
	 */
	public class VideoView extends InteractiveView 
	{
		public var video_component : VideoComponent;
		
		private var _video_slave : VideoSlave;
		
		override public function set src( path : String ) : void 
		{
			var uri : String;
			
			if ( attribute( 'streaming' ) == 'true' )
			{
				uri = root.name + "/" + path;
				path   = config.path( uri.toLowerCase( ).split( "." ).pop( ) );
				uri = path + uri;
				
				_video_slave = new VideoSlave();
				_video_slave.on_start.add( source_start );
				_video_slave.on_complete.add( source_loaded );
				_video_slave.load( uri );
			}
			else
			{
				super.src = path;
			}
		}

		/**
		 * This function is a victim from _src_slave's gunz_start
		 */
		override protected function source_start(bullet : ASlaveBullet) : void 
		{
			var _video_width : Number;
			var _video_height : Number;
			var _video_buffer : Number;
			var _video_volume : Number;
			
			_video_slave = VideoSlave( bullet.owner );
			
			if( attribute( 'width' ) ) 
				_video_width = n( attribute( 'width' ) );
			
			if( attribute( 'height' ) )
				_video_height = n( attribute( 'height' ) );
				
			if( attribute( 'buffer' ) )
				_video_buffer = n( attribute( 'buffer' ) ); 
				
			if( attribute( 'volume' ) )
				_video_volume = n( attribute( 'volume' ) ); 
				
			video_component = new VideoComponent( null, 
												  _video_width, 
												  _video_height, 
												  _video_buffer, 
												  _video_volume );
												  
			video_component.attach_ns( _video_slave.net_stream );
		}
		
		override protected function source_loaded(bullet : ASlaveBullet) : void 
		{
			super.source_loaded( bullet );
		}

		override protected function _instantiate_display() : * 
		{
			super._instantiate_display( );
			
			sprite.addChild( video_component.video );
			
			if( attribute( 'auto_play' ) == 'true' )
				video_component.play( );
			
			return null;
		}
	}
}
