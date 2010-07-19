package cocktail.core.ui.media 
{
	import cocktail.lib.MVC;

	import themes.cocktail.components.video.AControl;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author rafaelcordoba
	 */
	public class VideoControl
	{
		public var sprite : Sprite;

		private var _video_component : VideoComponent;
		private var _asset : AControl;
		private var _muted : Boolean;

		public function VideoControl( component : VideoComponent)
		{
			_video_component = component;
			
			_muted = false;
			
			sprite = new Sprite( );
			_asset = new AControl( );
			
			sprite.addChild( _asset );
			
			_btn_play.buttonMode = true;
			_btn_play.mouseChildren = false;
			_btn_play.addEventListener( MouseEvent.CLICK, _video_component.play );
			
			_btn_pause.buttonMode = true;
			_btn_pause.mouseChildren = false;
			_btn_pause.addEventListener( MouseEvent.CLICK, _video_component.pause );
			
			_btn_mute.buttonMode = true;
			_btn_mute.mouseChildren = false;
			_btn_mute.addEventListener( MouseEvent.CLICK, _toggle_mute );
		}
		
		private function _toggle_mute( event : MouseEvent ) : void
		{
			if ( _muted )
			{
				_muted = false;
				_video_component.unmute( );
			}
			else
			{
				_muted = true;
				_video_component.mute( );
			}
		}

		/* GETTERS */

		private function get _btn_play() : MovieClip
		{
			return _asset[ 'btn_play' ];
		}

		private function get _btn_pause() : MovieClip
		{
			return _asset[ 'btn_pause' ];
		}

		private function get _btn_mute() : MovieClip
		{
			return _asset[ 'btn_mute' ];
		}
	}
}
