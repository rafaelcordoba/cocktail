package cocktail.lib 
{
	import cocktail.Cocktail;
	import cocktail.core.gunz.Gun;
	import cocktail.core.request.Request;
	import cocktail.core.slave.ASlave;
	import cocktail.core.slave.ISlave;
	import cocktail.core.slave.Slave;
	import cocktail.core.slave.gunz.ASlaveBullet;
	import cocktail.lib.gunz.ViewBullet;
	import cocktail.lib.views.ViewStack;

	import de.polygonal.ds.DListNode;

	import flash.display.Sprite;

	public class View extends MV
	{
		/* GUNZ */
		public var gunz_render_done : Gun;

		/* GUNZ */
		public var gunz_destroy_done : Gun;

		/** Contains and indexes all the childs **/
		private var _children : ViewStack;

		/** 
		 * Identifier on parent's ViewStack
		 * 
		 * Is setted on xml_node setter.
		 * 
		 * If no "id" property is set in the XML, use the tag localName.
		 * 
		 * IMP: may be the best choice isnt use localName as id 
		 * **/
		public var identifier : String;

		/** The view node on the ViewStack DLinkedList **/
		public var node : DListNode;

		/** Reference to the parent view container **/
		public var up : View;

		/** When created trought xml, this will hold the xml node**/
		private var _xml_node : XML;

		/** View sprite **/
		public var sprite : Sprite;

		/** slave for loading **/
		private var _src_slave : ASlave;

		/**
		 * This flag will help cocktail to manage your render time.
		 * 
		 * Each time the render method is called, this function will
		 * be setted to FALSE, meaning that your render will take
		 * no longer then a simple method execution.
		 * 
		 * If your render will take some time, ie. tweening or doing
		 * some assyncronous thing, you have to tell the framework 
		 * when its done.
		 * 
		 * To do that, just call the get_after_render_shooter method,
		 * and it will return a shooter for you.
		 * 
		 * Example 1:
		 * 	 
		 * 	TweenMax.to( sprite, 1, { 
		 * 		alpha: 1,
		 * 		onComplete: call_after_render
		 * 	} );
		 * 	
		 * Example 2:
		 *  
		 *  delay( 1 , call_after_render )
		 * 
		 * If you dont do this, cocktail will handle your render as
		 * immediate.
		 * 
		 * After calling this method once, the other calls will return null
		 * until the next render.
		 */
		private var _wait_after_render_shoot : Boolean;

		private function _init_gunz() : void 
		{
			gunz_render_done = new Gun( gunz, this, "render_done" );
			gunz_destroy_done = new Gun( gunz, this, "destroy_done" );
		}

		
		/**
		 * 
		 */
		override public function boot( cocktail : Cocktail ) : * 
		{
			var s : *;
		
			s = super.boot( cocktail );
			
			_init_gunz( );
			
			_children = new ViewStack( this );
			_children.boot( cocktail );
			
			sprite = null;
			
			return s;
		}


		/* b a s i c   a p i */

		
		/**
		 * Returns desired atribute in xml_node.
		 * 
		 * i.e. attribute( 'x' )
		 */
		public function attribute( name : String ) : String
		{
			return xml_node.attribute( name ).toString( );
		}

		/**
		 * Removes a view from the view stack
		 */
		public function remove( id : String ) : View 
		{
			return children.remove( id );
		}


		/* l o d a i n g   r e l a t e d */

		/**
		 * Parses all necessary Views for given request.
		 * 
		 * @param process	Running process.
		 * @return	An array with all Datasources, properly instantiated. 
		 */
		private function _parse_assets( request : Request ) : Array 
		{
			log.info( "Running..." );
			var i : int;
			var assets : Array;
			var list : XMLList;
			var node : XML;
			var action : String;
			
			action = request.route.eval.action;
			assets = [];
			
			list = xml_node.children( );
			
			// return home early!
			if( list == null || !list.length( ) ) return assets;
			
			do
			{
				node = list[i];
					
				assets.push( _instantiate_view( node ) );
			} while( ++i < list.length( ) );
			
			
			return assets;
		}

		/**
		 * Filters the loading action. If return false, load routine will
		 * pause
		 */
		public function before_load( request : Request ) : Boolean 
		{
			log.info( "Running..." );
			
			request;
			return true;
		}

		/**
		 * Load will parse all views, instantiate they, and listen for
		 * all loads to complete. After that, will trigger _after_load_assets
		 */
		public function load( request : Request ) : Boolean 
		{
			if( !before_load( request ) ) return false;

			log.info( "Running..." );
			
			var i : int;
			var assets : Array;
			var view : View;
			
			children.mark_all_inactive( );

			// ATT: _parse assets should run after childs.mark_all_inactive()			
			assets = _parse_assets( request ); 

			_load_attributes( );
						
			if( assets.length == 0 ) return true;
			
			do 
			{
				view = assets[ i ];
				
				children.mark_as_active( view );
				
				view.load( request );
			} while( ++i < assets.length );

			return true;
		}

		/**
		 * Loads xml_node attributes into view.
		 * 
		 * Currently only reading "src" attribute.
		 */
		internal function _load_attributes() : void 
		{
			if( attribute( 'src' )  )
				src = attribute( 'src' );
		}
		
		/**
		 * This function is a victim from _src_slave's gunz_start.
		 * 
		 * If your view has any kind of source, you should override this
		 * function and save a typed reference for it.
		 * 
		 * Also your view should extend the respective kind of view.
		 */
		protected function source_start( bullet : ASlaveBullet ) : void
		{
			log.error( "This function should be overrided by your view" );
			
			bullet;
		}

		/**
		 * This function is a victim from _src_slave's gunz_complete.
		 * 
		 * If your view has any kind of source, you should override this
		 * function and save a typed reference for it.
		 * 
		 * Also your view should extend the respective kind of view.
		 */
		protected function source_loaded( bullet : ASlaveBullet ) : void
		{
			log.error( "This function should be overrided by your view" );
			
			if( !( this is Layout) )
				after_load( true );
			
			bullet;
		}
		
		/**
		 * This function is a victim from _src_slave's gunz_error.
		 * 
		 * If your view has any kind of source, you should override to
		 * make a custom error handling
		 * 
		 */
		protected function load_fails( bullet : ASlaveBullet = null ) : void
		{
			log.notice( "This function could be overrided by your view" );
			
			if( !( this is Layout) )
				after_load( false );
			
			bullet;
		}
		
		public function after_load( success: Boolean ): void
		{
			
		}
		
		/**
		 * Instantiate a view based on a xml_node, if it already exists, 
		 * will just return the reference.
		 */
		internal function _instantiate_view( xml_node : XML ) : View 
		{
			var view : View;
			
			if( !xml_node.hasOwnProperty( 'id' ) && false )
			{
				log.warn( "Your view needs to have and id" );
				// FIXME: this ['id'] is becoming a child, not a prop
				xml_node[ 'id' ] = Math.random( ) * 100000000000;
				log.warn( "Assigned a random id: " + xml_node[ 'id' ] );
			}
			
			if( ( view = children.by_id( xml_node.@id ) ) != null ) 
			{
				return children.by_id( xml_node.@id );
			}
			
			return children.create( xml_node );
		}

		/**
		 *	Called from Controller#render
		 *	
		 *	Will check before_render, then render 
		 */
		public function run( request: Request ) : Boolean
		{
			if( !before_render( request ) ) return false;
			
			log.info( "Running..." );
			
			if( sprite == null )
				_instantiate_display( );
			
			set_triggers();
			
			children.on_render_complete.add( _childs_rendred, request ).once();
			
			children.render( request );
			
			return true;
		}

		/**
		 * This function should create all the event handlers
		 */
		public function set_triggers() : void 
		{
		}

		protected function _childs_rendred( bullet: ViewBullet ): void
		{
			log.info( "Running..." );
			_render( bullet.params );
		}
		
		/* r e n d e r   r e l a t e d */
		

		/**
		 * If returns false, wont render
		 */		
		public function before_render( request : Request ) : Boolean 
		{
			log.info( "Running..." );
			request;
			return true;
		}

		/**
		 * Render its children than itself
		 * 
		 * Wont render if before_render returns false
		 */
		private function _render( request : Request ) : *
		{
			log.info( "Running..." );

			_apply_styles( request );
			
			render( request );

			if( !_wait_after_render_shoot )
				if( this != root )
					call_after_render();
			
			/*
			 * we dont need to handle layout attach, cause its already solved
			 * on _instantiate_dosplay
			 */
			if( this != root )
				up.sprite.addChild( sprite );
			
			return true;
		}

		/**
		 * This function will be overwrited by your view, this
		 * is the "init" of your view
		 */
		public function render( request: Request ) : *
		{
			
		}
		
		/**
		 * This should be passed as callback to any assyncronous call in 
		 * your render proccess.
		 * 
		 * It will tell the framework to wait for your render
		 */
		public function get call_after_render(): Function
		{
			if( _wait_after_render_shoot ) return null;
			
			_wait_after_render_shoot = true;
			
			return _call_after_render;
		}
		
		/**
		 * Real render done shooter
		 */
		private function _call_after_render(): void
		{
			gunz_render_done.shoot( new ViewBullet() );
		}

		/**
		 * Creates the view sprite
		 * 
		 * If your view has a different thing to instantiate
		 * ( bitmap, swf, video, etcs ) you should run the super,
		 * then attach your content to sprite
		 * 
		 * ATT: Called by render if sprite == null
		 * 
		 * @see	View#_render
		 */
		protected function _instantiate_display() : *
		{
			sprite = new Sprite( );
		}

		/**
		 * Should "undo" + unload what was instantiated in _instantiate_display 
		 */
		protected function _destroy_display(): void
		{
			if( !sprite.parent ) return;
			
			up.sprite.removeChild( sprite );
		}
		
		/**
		 * Apply the styles for the current request
		 */
		private function _apply_styles( request : Request ) : void
		{
			// FIXME: Implement a style system
			request;
			
			//properties rendering
			//need to think in a good automated process to apply it
			if( xml_node.@x )
				sprite.x = Number( xml_node.@x );
				 	
			if( xml_node.@y )
				sprite.y = Number( xml_node.@y ); 	
		}

		/**
		 * Called after render process
		 */
		private function _after_render( bullet : ViewBullet ) : void
		{
			log.info( "Running..." );

			after_render( bullet.params );
			bullet;
		}

		/**
		 * Called just after the render function
		 */
		public function after_render( request : Request ) : void
		{
			log.info( "Running..." );
			request;
		}

		
		/**
		 * Should unset all possible triggers.
		 * 
		 * Called automatically once - when destroying the view
		 */
		public function unset_triggers() : void
		{
		}

		/**
		 * Destroy filter, if returns false, wont destroy
		 */
		public function before_destroy( request : Request ) : Boolean
		{
			log.info( "Running..." );
			request;
			return true;
		}

		/**
		 * Destroy should undo, everything as done when "rendering" the view.
		 */
		public function destroy( request : Request ) : Boolean 
		{
			if( !before_destroy( request ) ) return false;
		
			log.info( "Running..." );
			
			_destroy_display();
			
			gunz.rm_all();
			
			clear_delays();
			
			after_destroy( request );
			
			return true;
		}

		public function after_destroy( request : Request ) : void 
		{
			log.info( "Running..." );
			request;
		}

		
		/* GETTERS / SETTERS */
		
		
		/** Alias to the main view ( layout ) of the viewstack **/
		public function get root() : Layout 
		{
			return ( up == null ) ? Layout( this ) : up.root;
		}

		/** Alias to layout loader **/
		public function get loader() : Slave
		{
			return root.loader;
		}

		/** Getter for the viewstack **/
		public function get children() : ViewStack
		{
			return _children;
		}

		/** Returns the raw XML of this view **/
		public function get xml_node() : XML  
		{
			return _xml_node;
		}

		/**
		 * Receive the xml node from ViewStack#create
		 * 
		 * This will defined the view identifier
		 */
		public function set xml_node( xml_node : XML ) : void 
		{
			_xml_node = xml_node;
			
			identifier = attribute( 'id' ) || xml_node.localName( );
		}

		
		/** 
		 * ATRIBUTTE GETTER / SETTERS
		 * 
		 * This setters will receive the properties from xml_node, each
		 * time the "load" method is called
		 */
		 
		 
		/**
		 * Unload the current source if any, then load the new path
		 * 
		 * Will load using _src_slave
		 * 	on_complete triggers source_loaded
		 * 	on_error triggers load_fails
		 * 
		 * @param path	Path to the desired asset
		 */
		public function set src( path : String ) : void
		{
			path = root.name + "/" + path;
			
			if( _src_slave != null )
			{
				if( _src_slave.uri == path ) 
				{
					return;
				}
				else if( _src_slave.is_loaded )
				{
					ISlave( _src_slave ).destroy( );
				}
			}
			
			_src_slave = load_uri( path, false ); 
			
			_src_slave.on_error.add( load_fails );
			_src_slave.on_start.add( source_start );
			_src_slave.on_complete.add( source_loaded );
			
			loader.append( _src_slave );
		}
		
		/**
		 * Alias to _src_slave.uri
		 * 	if nothing was loaded here yet, returns null
		 */
		public function get src(): String
		{
			if( !_src_slave ) return null;
			
			return _src_slave.uri;
		}
	}
}