package cocktail.lib.views.components.player 
{
	import cocktail.core.ui.media.gunz.VideoBullet;
	import cocktail.core.ui.media.VideoComponent;
	import cocktail.lib.views.SwfView;
	import cocktail.lib.views.VideoView;

	/**
	 * @author rafaelcordoba
	 */
	public class BufferView extends SwfView 
	{
		private var _video : VideoComponent;
		
		override protected function _instantiate_display() : * 
		{
			super._instantiate_display( );
			
			_video = VideoView( up.children.by_id( 'video' ) ).video_component;
		}
		
		override public function set_triggers() : void
		{
			super.set_triggers();
			
			_video.gunz_net_status.add( _on_net_status );
			_video.gunz_on_metadata.add( _center_buffer );
		}

		private function _on_net_status( bullet : VideoBullet ) : void 
		{
			switch( bullet.info[ 'code' ] )
			{
				case "NetStream.Buffer.Full":
					swf.alpha = 0;
				break;
		
				case "NetStream.Buffer.Empty":
					swf.alpha = 1;
				break;
			}
			
			_center_buffer();
		}

		private function _center_buffer( ...args ) : void 
		{
			swf.x = ( _video.video_width - swf.width ) / 2;
			swf.y = ( _video.video_height - swf.height ) / 2;
		}
	}
}
