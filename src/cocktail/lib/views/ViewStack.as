package cocktail.lib.views 
{
	import cocktail.core.Index;
	import cocktail.core.gunz.Gun;
	import cocktail.core.gunz.GunzGroup;
	import cocktail.core.request.Request;
	import cocktail.lib.View;
	import cocktail.lib.gunz.ViewBullet;
	import cocktail.utils.StringUtil;

	import de.polygonal.ds.DLinkedList;
	import de.polygonal.ds.DListNode;

	import flash.utils.Dictionary;

	/**
	 * @author hems - hems@henriquematias.com
	 */
	public class ViewStack extends Index
	{
		/**
		 * ATT: May be will be usefull when coding 
		 * different action/layout transitions
		 */
		public var WILL_WAIT_DESTROY_BEFORE_TRIGGER_RENDER_DONE : Boolean;

		public var on_render_complete : Gun;

		/** The "owner" of the view stack **/
		private var _view : View;
		
		/**
		 * Used to handle all children's render complete, after all
		 * group rendered, on_render_complete is fired!
		 */
		private var _group_rendering : GunzGroup;

		/** Double linked list of view childs **/
		public var list : DLinkedList;

		/** maping view's ids as key on a dictonary **/
		private var _ids : Dictionary;
		
		/** 
		 * This object holds a "key" for each "active" view in the current
		 * action.
		 * 
		 * Before the render process this object is cleared.
		 * 
		 * For each view in current action, a key will be added to this object.
		 * 
		 * i.e. _will_render[ 'my_view_id' ] = true
		 * 
		 * Then, in the "render" time, views not flaged will be destroyed.
		 * 
		 */
		private var _active_views : Object;

		/** Last rendered request **/
		private var _request : Request;

		public function ViewStack( view : View )
		{
			_ids = new Dictionary( true );
			_view = view;
			
			list = new DLinkedList( );
			on_render_complete = new Gun( view.gunz, this, "render_complete" );
			
			WILL_WAIT_DESTROY_BEFORE_TRIGGER_RENDER_DONE = false;
		}

		/**
		 * Adds a view to the view stack
		 */
		public function add( child : View ) : View
		{
			if( has( child.identifier ) )
			{
				/**
				 * TODO: wont add a identifier twice, instead we need to think... 
				 * in a good way to pass those params to the already rendered 
				 * child
				 */
				log.error( "Identifier is unique in ViewStack" );
				
				return child;
			}
			
			// indexing child
			_ids[ view.identifier ] = view;
			view.node = list.append( view );
			
			child.node = list.append( child ); 			
			child.up = view;
			child.boot( cocktail );
			
			return child;
		}

		/**
		 * Remove a view from the index
		 */
		public function remove( id : String ) : View
		{
			if( !has( id ) )
			{
				log.error( "Requested identifier ( " + id + " ) isnt in the ViewStack" );
				
				return null;
			}
			
			by_id( id ).gunz_destroy_done.add( _after_destroy_view );
			by_id( id ).destroy( _request );
			
			return null;
		}

		/**
		 * Called after last view breath, will completely deattach
		 * view from this stack
		 */
		private function _after_destroy_view( bullet : ViewBullet ) : void 
		{
			var view : View;
			
			view = bullet.owner;
			
			//removing from child index
			list.remove( list.nodeOf( view.identifier ) );
			_ids[ view.identifier ] = null;
			
			if( _active_views.hasOwnProperty( view.identifier ) )
				_active_views[ view.identifier ] = null;
		}

		/**
		 * @return True if the identifier is already in the view stack
		 */
		public function has( id : String ) : Boolean
		{
			return _ids[ id ] != null;
		}

		/**
		 * Get a view by id on the viewStack
		 */
		public function by_id( id : String ) : View
		{
			if( has( id ) ) 
				return _ids[ id ];
			
			return null;
		}

		/**
		 * Flag all view as inactive, before run
		 */
		public function mark_all_inactive() : void
		{
			_active_views = {};
		}

		public function is_active( view: View ): Boolean
		{
			return _active_views[ view.identifier ] === true;
		}
		
		/**
		 * Flag a view as active, so it will be rendered
		 */
		public function mark_as_active( view : View ) : View
		{
			_active_views[ view.identifier ] = true;
			
			return view;
		}

		/**
		 * Will execute render on alive views and destroy on dead views
		 */
		public function render( request : Request ) : void 
		{
			var node : DListNode;
			var view : View;
			
			// no childs, no render
			if( !list.size ) return;
			
			log.info( "Running..." );
			
			_request = request;
			_group_rendering = new GunzGroup( );
			_group_rendering.gunz_complete.add( _after_render );
			
			//populating group	
			node = list.head;
			while ( node )
			{
				view = node.data;

				if( _active_views[ view.identifier ] )
					_group_rendering.add( view.gunz_render_done );
				else
					if( WILL_WAIT_DESTROY_BEFORE_TRIGGER_RENDER_DONE )
						_group_rendering.add( view.gunz_destroy_done );
					
				node = node.next;
			}
			
			/*
			 *  made two independent functions to easily implement transitions
			 *  in a near future.
			 */
			_destroy_all(); /* ¿ transition ? */ _render_all();
			
			//reset render poll
			_active_views = {};
		}

		/**
		 * Call destroy in all views that wasnt flaged as "active"
		 */
		private function _destroy_all() : void 
		{
			var node : DListNode;
			var view: View;
			
			// no childs, no destroy
			if( !list.size ) return;
			
			node = list.head;
			do
			{
				view = node.data;
				
				if( !is_active( view ) )
					view.destroy( request );
					
			} while( node = node.next );
		}

		/**
		 * Call render in all views flaged as "active"
		 */
		private function _render_all() : void 
		{
			var node : DListNode;
			var view: View;
			
			node = list.head;
			do
			{
				view = node.data;
				
				if( is_active( view ) )
					view.run( request );
					
			} while( node = node.next );
		}

		/**
		 * Victim of _group_rendering
		 * 
		 * @see	ViewStack#render
		 * 
		 * @see	ViewStack#_group_rendering
		 */
		private function _after_render() : void 
		{
			log.info( "Running..." );
			
			on_render_complete.shoot( new ViewBullet( ) );
		}

		/**
		 * Instantiate a view based on a xml_node
		 */
		public function create( xml_node : XML ) : View 
		{
			var created : View;
			var area_path : String;
			var path : String;
			
			area_path = StringUtil.toUnderscore( view.root.name );
			
			if( xml_node.attribute( 'class' ).toString( ) )
				// waiting for a attribute "class", will evaluate views/{area}/{class}View
				path = xml_node.attribute( 'class' );
			else
				path = StringUtil.toCamel( xml_node.localName( ) );
			
			created = View( new ( _cocktail.factory.view( area_path, path ) ) );
			created.xml_node = xml_node;
			
			add( created );
			
			return created;
		}

		/**
		 * Reference to the stack owner
		 */		
		public function get view() : View
		{
			return _view;
		}

		/** 
		 * Last rendered request 
		 **/
		public function get request() : Request
		{
			return _request;
		}
	}
}
