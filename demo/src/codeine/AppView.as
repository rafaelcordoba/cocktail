package codeine 
{
	import cocktail.lib.View;
	
	import codeine.views.elements.PreloaderElement;	

	/**
	 * Creates any custom view behavior  in the application level. In this case, we are doing all preloader staff.
	 * @author nybras | nybras@codeine.it
	 */
	public class AppView extends View
	{
		
//		public function AppView () : void
//		{
//			use_preloader = ( up == null );
//		}
//
//		/**
//		 * PRELOADING
//		 */
//		
//		public function load_start ( has_bytes_total : Boolean ) : void
//		{
//			if ( ! preloader )
//				init_preloader ();
//			
//			has_bytes_total;
//			if ( ! use_preloader ) return;
//			
//			_sprite.addChild( preloader.sprite );
//			preloader.show();
//		}
//		
//		private function init_preloader () : void
//		{
//			preloader = new PreloaderElement();
//		}
//		
//		public function load_progress ( p : Number, ...params ) : void
//		{
//			if ( ! use_preloader ) return;
//			preloader.progress = p;
//		}
//		
//		public function load_complete () : void
//		{
//			if ( ! use_preloader ) return;
//			preloader.hide();
//		}
	}
}