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
		private var on_drag : Gun;
		private var on_stage_up : Gun;
		private var _playing_before_seek : Boolean;

		override protected function _instantiate_display() : * 
		{
			super._instantiate_display( );
			
			_video = VideoView( up.children.by_id( 'video' ) ).video_component;
			
			bar_loaded.scaleX = 1;
			bar_loaded.buttonMode = true;

			bar_played.scaleX = 1;
			bar_played.mouseChildren = false;
			bar_played.mouseEnabled = false;
			
			time_clip.buttonMode = true;
			time_clip.mouseChildren = false;
			
			volume_slider.buttonMode = true;
			volume_slider.mouseChildren = false;
			
			btn_toggle_play.gotoAndStop( 2 );
			
			swf.alpha = 0;
		}

		override public function set_triggers() : void
		{
			super.set_triggers();
			
			_video.on_time.add( _on_playhead_move );
			_video.gunz_on_metadata.add( _align_controls );
			
			player.on_roll_over.add( show_control );
			player.on_roll_out.add( hide_control );
						
			listen( btn_toggle_play, MouseEvent.CLICK ).add( _toggle_play );
			
			listen( bar_loaded, MouseEvent.MOUSE_DOWN ).add( _on_time_seek_start );
			listen( bar_loaded, MouseEvent.CLICK ).add( _seek_release );
			
			listen( time_clip, MouseEvent.MOUSE_DOWN ).add( _on_time_seek_start );
			
			listen( volume_slider, MouseEvent.MOUSE_DOWN ).add( _on_mouse_down_volume );
			
			on_drag     = listen( stage, MouseEvent.MOUSE_MOVE );
			on_stage_up = listen( stage, MouseEvent.MOUSE_UP );
		}

		private function _align_controls( ...args ) : void
		{
			swf.x = 5;
			swf.y = _video.video_height - bg.height - 5;
			
			bg.width = _video.video_width - 10;
			
			btn_toggle_play.x = 10;
			seek_bar.x = btn_toggle_play.x + btn_toggle_play.width + 10;
			volume_slider.x = bg.width - volume_slider.width - 10;
			
			bar_base[ 'bar' ][ 'width' ] 	= bg.width - seek_bar.x - volume_slider.width - 20;
			bar_loaded[ 'bar' ][ 'width' ] 	= bg.width - seek_bar.x - volume_slider.width - 20;
			bar_played[ 'bar' ][ 'width' ] 	= bg.width - seek_bar.x - volume_slider.width - 20;
		}

		private function show_control( ...args  ) : void 
		{
			_align_controls();
			
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

		private function _on_volume_release( ...args ) : void 
		{
			on_drag.rm( _on_drag_volume );
		}

		private function _on_time_release( ...args ): void
		{
			_seek_release();
			
			on_drag.rm( _seek );
		}
		
		/**
		 * Called when user starts to drag the time tooltip
		 */
		private function _on_time_seek_start( ...args ) : void 
		{
			_save_video_status();
			
			on_drag.add( _seek );
			
			on_stage_up.add( _on_time_release ).once();
		}
		
		private function _on_mouse_down_volume( ...args  ) : void
		{
			_video.volume = _resize_volume_slider();
			_resize_volume_slider();
			
			on_drag.add( _on_drag_volume );
			
			on_stage_up.add( _on_volume_release ).once();
		}

		private function _save_video_status( ...args ): void
		{
			_playing_before_seek = _video.is_playing;
		}

		private function _on_drag_volume( ...args ) : void 
		{
			_video.volume = _resize_volume_slider();

			_resize_volume_slider();
		}
		
		private function _resize_volume_slider() : Number
		{
			var pct : Number;
			
			pct = volume_slider.mouseX / volume_slider[ 'base' ][ 'width' ];
			
			if ( pct > 1 )
				pct = 1;
				
			if ( pct < 0 )
				pct = 0;
			
			slider.scaleX = pct;
			
			return pct;
		}
		
		private function _seek_release( ...args ) : void 
		{
			var pct : Number;
			
			pct = seek_bar.mouseX / bar_base.width;
			
			_video.seek( pct, _playing_before_seek );
		}
		
		private function _seek( ...args ) : void 
		{
			var pct : Number;
			
			pct = seek_bar.mouseX / bar_base.width;
			
			_video.seek( pct );
		}
		
		private function _on_playhead_move( bullet : VideoBullet ) : void
		{
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
		
		
		
		public function get player(): PlayerView
		{
			return PlayerView( InteractiveView( up ) );
		}
		
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
		
		public function get volume_slider() : MovieClip
		{
			return swf[ 'volume_slider' ];
		}
		
		public function get slider() : MovieClip
		{
			return volume_slider[ 'slider' ];
		}
		
		public function get slider_mask() : MovieClip
		{
			return volume_slider[ 'mask_mc' ];
		}
	}
}
