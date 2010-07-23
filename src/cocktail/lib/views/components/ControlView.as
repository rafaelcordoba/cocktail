package cocktail.lib.views.components 
{
	import cocktail.lib.views.InteractiveView;
	import flash.events.MouseEvent;
	import cocktail.core.ui.media.VideoComponent;

	import flash.display.Sprite;

	/**
	 * @author rafaelcordoba
	 */
	public class ControlView extends InteractiveView
	{
		private var _video : VideoComponent;

		private var _btn_play : Sprite;
		private var _btn_pause : Sprite;
		
		override protected function _instantiate_display() : * 
		{
			super._instantiate_display( );
			
			_btn_play = new Sprite();
			_btn_play.graphics.beginFill( 0x00FF00 );
			_btn_play.graphics.drawRect( 0, 0, 20, 20 );
			_btn_play.graphics.endFill( );
			_btn_play.buttonMode = true;
			sprite.addChild( _btn_play );
			
			_btn_pause = new Sprite();
			_btn_pause.graphics.beginFill( 0x00FF00 );
			_btn_pause.graphics.drawRect( 25, 0, 20, 20 );
			_btn_pause.graphics.endFill( );
			_btn_pause.buttonMode = true;
			sprite.addChild( _btn_pause );
			
			_set_triggers();
		}
		
		public function set_video( component : VideoComponent ) : void
		{
			_video = component;
		}
		
		private function _set_triggers() : void
		{
			listen( _btn_play, MouseEvent.CLICK ).add( _video.play );
			listen( _btn_pause, 'click' ).add( _video.pause );
		}
	}
}
