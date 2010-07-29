package cocktail.core.router 
{
	import cocktail.Cocktail;
	import cocktail.core.factory.Factory;
	import cocktail.lib.Controller;
	import cocktail.lib.View;
	import cocktail.utils.ObjectUtil;

	/**
	 * Route API - stores system execution infos (controller, action, params).
	 * @author nybras | nybras@codeine.it 
	 * @author hems @ henriquematias.com
	 */
	public class RouteEval
	{
		/* ---------------------------------------------------------------------
		VARS
		--------------------------------------------------------------------- */
		private var _uri : String;
	
		public var controller : Controller;
	
		public var action : String;
	
		public var params : Array;
		
		public var view: View;

		private var _cocktail : Cocktail;

		/* ---------------------------------------------------------------------
		INITIALIZING
		--------------------------------------------------------------------- */
		
		/**
		 * Translates the given uri to an API call.
		 * @param uri	URI to be translated.
		 */
		public function RouteEval( uri : String )
		{
			_uri = uri;
		}
	
		public function boot( cocktail: Cocktail ): RouteEval
		{
			_cocktail = cocktail;
			
			var factory: Factory;
			var parts : Array;
			var full_path : Array;
			var area: String;
			var view_path : String;
			
			factory = _cocktail.factory;
			
			full_path = _uri.split( ":" );
			
			parts = String( full_path[ 0 ] ).split( '/' );

			area = parts[ 0 ];
			
			controller = factory.controller( area );
			action     = parts[ 1 ];
			params     = [].concat( parts.slice( 2 ) ); 
			
			view_path  = full_path[ 1 ];
			
			if( factory.layout( area ).child( view_path ) )
				view = factory.layout( area ).children.by_id( view_path ); 
				
			return this;
		}

		/* ---------------------------------------------------------------------
		RUNNING
		--------------------------------------------------------------------- */
		
		/**
		 * Runs the API call into the given controller.
		 * @param controller	Controller to run the API call.
		 */
		public function run() : *
		{
			return ObjectUtil.exec( controller, action, params );
		}
	}
}