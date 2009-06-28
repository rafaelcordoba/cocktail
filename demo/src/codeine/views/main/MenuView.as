package codeine.views.main 
{
	import codeine.AppView;	

	/**
	 * Handles the main interface.
	 * @author nybras | nybras@codeine.it
	 */
	public class MenuView extends AppView 
	{
//		/* ---------------------------------------------------------------------
//			VARS
//		--------------------------------------------------------------------- */
//		
//		private var _main : BtnElement;
//		private var _datasources : BtnElement;
//		private var _media : BtnElement;
//		private var _form : BtnElement;
//		
//		private var _main_trigger : Function;
//		private var _datasources_trigger : Function;
//		private var _media_trigger : Function;
//		private var _form_trigger : Function;
//		
//		private var _selected : BtnElement;
//		
//		
//		
//		/* ---------------------------------------------------------------------
//			RENDERING
//		--------------------------------------------------------------------- */
//		
//		/**
//		 * Prepare everything before render.
//		 */
//		public function before_render () : void
//		{
//			_main = BtnElement ( child( "main" ) );
//			_datasources = BtnElement ( child ( "datasources" ) );
//			_media = BtnElement ( child ( "media" ) );
//			_form = BtnElement ( child ( "form" ) );
//			
//			set_selected();
//		}
//		
//		/**
//		 * Mount animation.
//		 */
//		public function after_render () : void
//		{
//			set_triggers();
//		}
//		
//		
//		
//		/* ---------------------------------------------------------------------
//			DESTROYING
//		--------------------------------------------------------------------- */
//		
//		/**
//		 * Unmount animation.
//		 * @param dao	ProcessDAO to be destroyed.
//		 */
//		public function before_destroy ( dao : ProcessDAO ) : void
//		{
//			unset_triggers(); dao;
//		}
//		
//		
//		
//		/* ---------------------------------------------------------------------
//			TRIGGERING
//		--------------------------------------------------------------------- */
//		
//		/**
//		 * Sets all triggers.
//		 */
//		public function set_triggers () : void
//		{
//			_main.sprite.addEventListener( MouseEvent.CLICK , _main_trigger = proxy( go, "Main/home" ) );
//			_datasources.sprite.addEventListener( MouseEvent.CLICK , _datasources_trigger = proxy( go, "Datasources/index" ) );
//			_media.sprite.addEventListener( MouseEvent.CLICK , _media_trigger = proxy( go, "Media/index" ) );
//			_form.sprite.addEventListener( MouseEvent.CLICK , _form_trigger = proxy( go, "Form/index" ) );
//			
//			config.listen_addressbar( set_selected );
//		}
//		
//		/**
//		 * Unsets all triggers.
//		 */
//		public function unset_triggers () : void
//		{
//			_main.sprite.removeEventListener( MouseEvent.CLICK , _main_trigger );
//			_datasources.sprite.removeEventListener( MouseEvent.CLICK , _datasources_trigger );
//			_media.sprite.removeEventListener( MouseEvent.CLICK , _media_trigger );
//			_form.sprite.removeEventListener( MouseEvent.CLICK , _form_trigger );
//		}
//		
//		
//		
//		/* ---------------------------------------------------------------------
//			BEHAVIORS
//		--------------------------------------------------------------------- */
//		
//		/**
//		 * Sets the current selected button.
//		 * @param event	Event.CHANGE.
//		 */
//		private function set_selected ( event : Event = null ) : void
//		{
//			var process : ProcessDAO;
//			var btn : BtnElement;
//			
//			process = new ProcessDAO ( config.location, false, false );
//			btn = BtnElement ( this [ "_"+ process.area_name.toLowerCase() ] );
//			
//			if ( _selected is BtnElement )
//			{
//				_selected.out();
//				_selected.enable();
//				_selected.sprite.mouseEnabled = true;
//			}
//			
//			( _selected = btn ).disable();
//			_selected.over();
//			_selected.sprite.mouseEnabled = false;
//		}
//		
//		/**
//		 * Redirects the application.
//		 * @param url	Url to redirect the aplication to.
//		 * @param event	MouseEvent.CLICK
//		 */
//		private function go ( url : String, event : MouseEvent ) : void
//		{
//			redirect ( url );
//		}
	}
}