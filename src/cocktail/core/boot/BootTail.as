package cocktail.core.boot 
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Capabilities;

	/**
	 * Boots the framework, initializing the main preloader, and loading
	 * the 'core.swf' file.
	 * @author nybras | nybras@codeine.it
	 * @author hems | hems@henriquematias.com
	 */
	public class BootTail extends Sprite 
	{
		/* VARS */
		private var _loader : Loader;

		/* INITIALIZING */
		
		/**
		 * Creates a new BootTail instance.
		 */
		public function BootTail()
		{
			stage.scaleMode = "noScale";
			stage.align = "LT";
			_load( );
		}

		/* BOOTING APPLICATION */
		
		/**
		 * Loader application.
		 */
		protected function _load( ) : void
		{
			_loader = new Loader( );
			_loader.contentLoaderInfo.addEventListener( "complete", _render );
			_loader.load( new URLRequest( _core_path ) );
		}

		/**
		 * Render/Start application. 
		 * @param event	Event.COMPLETE
		 */
		private function _render( event : Event ) : void
		{
			addChild( _loader.content );
			_loader.contentLoaderInfo.removeEventListener( "complete", _render );
			_loader = null;
		}

		/* APPLICATION PATH */
		
		/**
		 * Returns the computed application 'core.swf' path, adding a random
		 * string to avoid cache.
		 */
		private function get _core_path() : String
		{
			var path: String;
			
			if( root.loaderInfo.parameters[ "core" ] )
			{
				path = root.loaderInfo.parameters[ "core" ];
				
				if( root.loaderInfo.parameters[ "version" ] )
					path = path + '?v=' + root.loaderInfo.parameters[ "version" ];
			}
			else
			{
				path = './core.swf';
			}
			
			return path + "?unique=" + Math.random( );
		}
	}
}