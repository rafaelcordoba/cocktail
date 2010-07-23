package cocktail.lib.views.components 
{

	import cocktail.lib.views.VideoView;
	import cocktail.lib.views.InteractiveView;
	
	/**
	 * @author rafaelcordoba
	 */
	public class PlayerView extends InteractiveView
	{
		override protected function _instantiate_display() : * 
		{
			control_view.set_video( video_view.video_component );
			
			return super._instantiate_display( );
		}
		
		public function get video_view() : VideoView
		{
			if ( ! up.children.has( 'video' ) )
				log.error( 'You need to create a <video> tag in your XML with id="video"' );
				
			
			return VideoView( up.children.by_id( 'video' ) );
		}
		
		public function get control_view() : ControlView
		{
			if ( ! up.children.has( 'control' ) )
				log.error( 'You need to create a <control> tag in your XML with id="control"' );
				
			return ControlView( up.children.by_id( 'control' )  );
		}
		
		public function get buffer_view() : BufferView
		{
			return BufferView( up.children.by_id( 'buffer' ) );
		}
	}
}
