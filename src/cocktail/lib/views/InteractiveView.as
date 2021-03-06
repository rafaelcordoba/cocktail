package cocktail.lib.views 
{
	import cocktail.core.gunz.Gun;
	import cocktail.core.request.Request;
	import cocktail.lib.View;

	/**
	 * Auto-glue to mouse events.
	 * 
	 * Any of those functions will be automatically assigned to sprite
	 * events. ( you just need to defined it in your class ).
	 * 	click
	 * 	mouse_over
	 * 	roll_over
	 * 	mouse_out
	 * 	roll_out
	 * 	mouse_up
	 * 	mouse_down
	 * 	double_click
	 * 	
	 * All interactive views have those gunz, so if you want listen
	 * to any of those events from "outside" ( why ? ), use:
	 * 
	 * 	view.on_click.add( handler, params )
	 * 	view.on_mouse_over.add( handler, params )
	 * 	view.on_roll_over.add( handler, params )
	 * 	view.on_mouse_out.add( handler, params )
	 * 	view.on_roll_out.add( handler, params )
	 * 	view.on_mouse_up.add( handler, params )
	 * 	view.on_mouse_down.add( handler, params )
	 * 	view.on_double_click.add( handler, params )
	 * 	
	 * @author hems | henriquematias.com
	 */
	public class InteractiveView extends View
	{
		private var _on_click : Gun;

		private var _on_mouse_over : Gun;

		private var _on_roll_over : Gun;

		private var _on_mouse_out : Gun;

		private var _on_roll_out : Gun;

		private var _on_mouse_up : Gun;

		private var _on_mouse_down : Gun;

		private var _on_double_click : Gun;

		/**
		 * Override super method just to add triggers to view
		 */		
		override protected function _instantiate_display() : * 
		{
			super._instantiate_display( );
			
			return sprite; 
		}

		/**
		 * 
		 */
		override public function destroy( request : Request ) : Boolean 
		{
			if( _on_click )
				_on_click.rm_all();
			
			if( _on_mouse_over )
				_on_mouse_over.rm_all();
				
			if( _on_roll_over )
				_on_roll_over.rm_all();
				
			if( _on_mouse_out )
				_on_mouse_out.rm_all();
				
			if( _on_roll_out )
				_on_roll_out.rm_all();
			
			if( _on_mouse_up )
				_on_mouse_up.rm_all();
				
			if( _on_mouse_down )
				_on_mouse_down.rm_all();
			
			if( _on_double_click )
				_on_double_click.rm_all();
			
			return super.destroy( request );;
		}

		/**
		 * Will check if user customized some events, if so, will plug
		 * then for the user.
		 * 
		 * Called automatically once - when creating the view sprite
		 */
		override public function set_triggers() : void 
		{
			super.set_triggers();
			
			if( is_defined( 'click' ) )
				on_click.add( this[ 'click' ] );
			
			if( is_defined( 'mouse_over' ) )
				on_mouse_over.add( this[ 'mouse_over' ] );
				
			if( is_defined( 'roll_over' ) )
				on_roll_over.add( this[ 'roll_over' ] );
				
			if( is_defined( 'mouse_out' ) )
				on_mouse_out.add( this[ 'mouse_out' ] );
				
			if( is_defined( 'roll_out' ) )
				on_roll_out.add( this[ 'on_roll_out' ] );
			
			if( is_defined( 'mouse_up' ) )
				on_mouse_up.add( this[ 'mouse_up' ] );
				
			if( is_defined( 'mouse_down' ) )
				on_mouse_down.add( this[ 'mouse_down' ] );
			
			if( is_defined( 'double_click' ) )
				on_double_click.add( this[ 'double_click' ] );
		}
		
		public function get on_click( ): Gun
		{
			if( _on_click ) return _on_click;
			
			return _on_click = listen( sprite, "click" ); 
		}

		public function get on_mouse_over( ): Gun
		{
			if( _on_mouse_over ) return _on_mouse_over;
			
			_on_mouse_over = listen( sprite, "mouseOver" );
			
			return _on_mouse_over;  
		}

		public function get on_roll_over( ): Gun
		{
			if( _on_roll_over ) return _on_roll_over;
			
			_on_roll_over = listen( sprite, "rollOver" );
			
			return _on_roll_over;  
		}

		public function get on_mouse_out( ): Gun
		{
			if( _on_mouse_out ) return _on_mouse_out;
			
			_on_mouse_out = listen( sprite, "mouseOut" );
			return _on_mouse_out; 
		}

		public function get on_roll_out( ): Gun
		{
			if( _on_roll_out ) return _on_roll_out;
			
			_on_roll_out = listen( sprite, "rollOut" ); 
			
			return _on_roll_out; 
		}

		public function get on_mouse_up( ): Gun
		{
			if( _on_mouse_up ) return _on_mouse_up;
			
			_on_mouse_up = listen( sprite, "mouseUp" ); 
			
			return _on_mouse_up; 
		}

		public function get on_mouse_down( ): Gun
		{
			if( _on_mouse_down ) return on_mouse_down;
			
			_on_mouse_down = listen( sprite, "mouseDown" );
			
			return _on_mouse_down; 
		}

		public function get on_double_click( ): Gun
		{
			if( _on_double_click ) return _on_double_click;
			
			_on_double_click = listen( sprite, "doubleClick" );
			 
			return _on_double_click; 
		}
	}
}
