package cocktail.lib 
{
	import cocktail.Cocktail;
	import cocktail.core.gunz.Bullet;
	import cocktail.core.logger.msgs.LayoutMessages;
	import cocktail.core.request.Request;
	import cocktail.core.router.RouteEval;
	import cocktail.core.slave.Slave;
	import cocktail.core.slave.gunz.ASlaveBullet;
	import cocktail.core.slave.slaves.TextSlave;
	import cocktail.lib.gunz.LayoutBullet;
	import cocktail.lib.gunz.ViewBullet;
	import cocktail.utils.StringUtil;

	import flash.display.Sprite;

	/**
	 * This class will load the respective xml and it assets.
	 * 
	 * It has some filters:
	 * 	before_render( request: Request )
	 * 	before_load( request: Request )
	 * 
	 * And some callbacks:
	 *  after_render( request )
	 *  after_load( success ) //triggered after all request assets were loaded
	 *  
	 * @author hems	hems@henriquematias.com
	 */
	public class Layout extends View 
	{
		/** queue of this layout an respective children **/
		private var _loader : Slave;

		/** 
		 * path to "container" asset.
		 * format is: {controller}/{area}:{view_id}
		 */
		private var _target : String;

		override public function boot(cocktail : Cocktail) : * 
		{
			_loader = new Slave( );
			
			return super.boot( cocktail );
		}

		/**
		 * Load layout's xml scheme.
		 * 
		 * @param request	request responsible for the action
		 */
		public function load_xml( request : Request ) : Layout 
		{
			request;
			log.info( "Running..." );
			load_uri( _xml_path ).on_complete.add( _xml_loaded );
			return this;
		}

		/**
		 * Parsing model xml scheme.
		 * 
		 * @param bullet	SlaveBullet.
		 */
		private function _xml_loaded( bullet : ASlaveBullet ) : void 
		{
			log.info( "Running..." );
			
			_xml = new XML( TextSlave( bullet.owner ).data );
			
			if( !_is_scheme_valid )
				log.fatal( "The scheme in this file has errors." + _xml_path );
			else
				on_xml_load_complete.shoot( new LayoutBullet( ) );
		}

		override internal function _load_attributes() : void 
		{
			super._load_attributes( );
		
			if( attribute( 'target' ) )
				target = attribute( 'target' );
		}

		/**
		 * Checks if the scheme is valid.
		 * @return	If shceme is valid, returns <code>true</code> otherwise
		 * return <code>false</code>.
		 */
		private function get _is_scheme_valid() : Boolean 
		{
			log.info( "Running..." );
			// TODO: check for some reserved word, or things like that
			return true;
		}

		public function parse_action( action: String ): void
		{
			var list : XMLList;
			
			//this will parse <{action}>
			//list = _xml[ action ];
			
			//this will parse <area id="{action}">
			list = _xml[ 'action' ].( @id == action || @id == "*" );
			
			if( list )
				xml_node = XML( list.toXMLString( ) );			
		}
		
		/**
		 * 
		 */
		override public function load( request : Request ) : Boolean 
		{
			var action : String;
			
			action = request.route.eval.action;
			
			parse_action( action );
			
			if( !xml_node )
			{
				log.error( LayoutMessages.no_action_to_load );
				return false;
			}
			
			//TODO: If target isnt rendered, redirect to asset page
			if( scope == null )
			{
				//redirect
				//request.loading = true;
			}
			
			//reset the loader
			_loader.reset( );			
			
			//check for before_load, parse and load children
			if( !super.load( request ) ) return false;
			
			//if no children wont need loading, return!
			if( !loader.length )
			{
				var bullet : ViewBullet;
				
				bullet = new ViewBullet( );
				bullet.params = request;
				
				_after_load( bullet );
				
				return false;
			}
			
			loader.on_complete.add( _after_load, request ).once( );
			loader.on_error.add( _load_assets_failed, request ).once( );
			loader.load( );
				
			return true;
		}

		/**
		 * Triggered after all views have loaded its content
		 */
		private function _after_load( ...n /* bullet : Bullet */ ) : void 
		{
			log.info( "Running..." );
			
			after_load( true );
			
			//this will tell controller, that everything was ok
			on_load_complete.shoot( new ViewBullet( ) );
		}

		private function _load_assets_failed( bullet : Bullet ) : void
		{
			log.error( "Failed to load all layout assets" );
			_after_load( bullet );
		}

		override protected function _instantiate_display() : * 
		{
			return _cocktail.app.addChild( sprite = new Sprite( ) );
		}

		
		override protected function _destroy_display() : void 
		{
			if( !sprite ) return;
			
			sprite.parent.removeChild( sprite );
		}

		
		/* PUBLIC GETTERS */
		
		
		/**
		 * Returns true if childs.request is equal to param request
		 * @param request	The request you would check if is rendered
		 * @see	ViewStack#request
		 */
		public function is_rendered( request : Request ) : Boolean
		{
			return children.request == request; 
		}

		override public function get loader() : Slave
		{
			return _loader;
		}

		/**
		 * 
		 * @param path	path to the desired view i.e. player.controls.play
		 */
		public function child( path : String ) : View
		{
			var steps : Array;
			var view : View;
			
			if( !path ) return null;
			
			view  = this;
			steps = path.split( "." );
			
			while ( steps.length )
			{
				if( !view.children.has( steps[ 0 ] ) )
					return null;
					
				view = view.children.by_id( steps.shift( ) );
			}
			
			return view;
		}

		/* PRIVATE GETTERS */

		/**
		 * Evaluates the path for the xml file.
		 * @return	The path to the xml file.
		 */
		private function get _xml_path() : String 
		{
			log.info( "Running..." );
			
			return "layouts/" + StringUtil.toUnderscore( name ) + ".xml";
		}

		
		/** 
		 * ATRIBUTTE SETTERS
		 * 
		 * This setters will receive the properties from xml_node, each
		 * time the "load" method is called
		 */
		 
		/**
		 * Unload the current source if any, then load the new path
		 * Will trigger _source_loaded after complete 
		 * 
		 * @param path	Path to the desired asset
		 */
		public function set target( path : String ) : void
		{
			_target = path;
		}

		public function get scope() : View 
		{
			var eval : RouteEval;
			
			eval = new RouteEval( String( xml_node.attribute( 'target' ) ) );
			
			return eval.view;
		}
	}
}