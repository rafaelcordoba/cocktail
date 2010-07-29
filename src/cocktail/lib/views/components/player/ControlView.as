package cocktail.lib.views.components.player 
{
	import cocktail.core.gunz.Gun;
	import cocktail.core.ui.media.VideoComponent;
	import cocktail.core.ui.media.gunz.VideoBullet;
	import cocktail.lib.views.InteractiveView;
	import cocktail.lib.views.SwfView;
	import cocktail.lib.views.VideoView;

	import gs.TweenMax;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author rafaelcordoba
	 */
	public class ControlView extends SwfView
	{
		private var _video : VideoComponent;
		private var _gun_mouse_move : Gun;
		private var _gun_stage_up : Gun;

		override protected function _instantiate_display() : * 
		{
			super._instantiate_display( );
			
			_video = VideoView( up.children.by_id( 'video' ) ).video_component;
			
			log.debug( _video );
			
			bar_loaded.scaleX = 1;
			bar_loaded.buttonMode = true;

			bar_played.scaleX = 1;
			bar_played.mouseChildren = false;
			bar_played.mouseEnabled = false;
			
			time_clip.buttonMode = true;
			time_clip.mouseChildren = false;
			
			btn_toggle_play.gotoAndStop( 2 );
			
			swf.alpha = 0;
		}

		override public function set_triggers() : void
		{
			super.set_triggers();
			
			_video.gunz_time.add( _on_playhead_move );
			
			listen( btn_toggle_play, MouseEvent.CLICK ).add( _toggle_play );
			listen( bar_loaded, MouseEvent.CLICK ).add( _seek_click );
			listen( bar_loaded, MouseEvent.MOUSE_DOWN ).add( _on_mouse_down );
			listen( time_clip, MouseEvent.MOUSE_DOWN ).add( _on_mouse_down );
			
			InteractiveView( up ).on_roll_over.add( show_control );
			InteractiveView( up ).on_roll_out.add( hide_control );
			
			VideoView( up.children.by_id( 'video' ) ).video_component.gunz_on_metadata.add( _place_control );
		}
		
		private function _place_control( ...args ) : void
		{
			TweenMax.to( swf, 0.3, { alpha:1 } );
			
			swf.x = 5;
			swf.y = _video.video_height - bg.height - 5;
			
			bg.width = _video.video_width - 10;
			
			bar_base[ 'bar' ][ 'width' ] 	= bg.width - seek_bar.x - 20;
			bar_loaded[ 'bar' ][ 'width' ] 	= bg.width - seek_bar.x - 20;
			bar_played[ 'bar' ][ 'width' ] 	= bg.width - seek_bar.x - 20;
		}

		private function show_control( ...args  ) : void 
		{
			_place_control();
			
			TweenMax.to( swf, 0.3, { alpha:1 } );
		}

		private function hide_control( ...args ) : void 
		{
			log.debug();
			
			TweenMax.to( swf, 0.3, { alpha:0 } );
		}
		
		private function _toggle_play( ...args ) : void
		{
			if ( _video.is_playing )
			{
				btn_toggle_play.gotoAndStop( 1 );
				_video.pause();
			}
			else
			{
				btn_toggle_play.gotoAndStop( 2 );
				_video.play();
			}
		}

		private function _on_mouse_up( ...args ) : void 
		{
			log.debug();
			
			if ( _gun_mouse_move )
			{
				_gun_mouse_move.rm( _on_mouse_move );
				_gun_mouse_move = null;
			}
			
			if ( _gun_stage_up )
			{
				_gun_stage_up.rm( _on_mouse_up );
				_gun_stage_up = null;
			}
		}

		private function _on_mouse_down( ...args ) : void 
		{
			log.debug();
			
			_gun_mouse_move = listen( sprite.stage, MouseEvent.MOUSE_MOVE );
			_gun_mouse_move.add( _on_mouse_move );
			
			_gun_stage_up = listen( sprite.stage, MouseEvent.MOUSE_UP );
			_gun_stage_up.add( _on_mouse_up );
		}

		private function _on_mouse_move( ...args ) : void 
		{
//			log.debug();
			
			_seek_click();
		}
		
		private function _seek_click( ...args ) : void 
		{
			var pct : Number;
			
			pct = bar_loaded.mouseX / bar_base.width;
			
			_video.seek( pct );
		}
		
		private function _on_playhead_move( bullet : VideoBullet ) : void
		{
//			log.debug( bullet.seconds_played );
			
			txt_played.text = bullet.time_played;
			
			bar_loaded.scaleX = bullet.buffered;
			bar_played.scaleX = bullet.percent_played;
			
			time_clip.x = seek_bar.x + bar_played.width;
		}
		
		public function show() : void
		{
			TweenMax.to( sprite, 0.3, { autoAlpha:1 } );
		}
		
		public function hide() : void
		{
			TweenMax.to( sprite, 0.3, { autoAlpha:0 } );
		}
		
		/* Getters */
		
		public function get bg() : MovieClip
		{
			return swf[ 'bg' ];
		}
		
		public function get btn_toggle_play() : MovieClip
		{
			return swf[ 'btn_toggle_play_mc' ];
		}
		
		public function get seek_bar() : MovieClip
		{
			return swf[ 'seek_bar' ];
		}
		
		public function get bar_base() : MovieClip
		{
			return seek_bar[ 'bar_base' ];
		}
		
		public function get bar_loaded() : MovieClip
		{
			return seek_bar[ 'bar_loaded' ];
		}
		
		public function get bar_played() : MovieClip
		{
			return seek_bar[ 'bar_played' ];
		}
		
		public function get time_clip() : MovieClip
		{
			return swf[ 'time_clip' ];
		}
		
		public function get txt_played() : TextField
		{
			return time_clip[ 'txt_played' ];
		}
	}
}
