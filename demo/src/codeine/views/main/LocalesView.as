package codeine.views.main 
{
	import codeine.AppView;	

	/**
	 * Handles the locales button bar.
	 * @author nybras | nybras@codeine.it
	 */
	public class LocalesView extends AppView 
	{
//		/* ---------------------------------------------------------------------
//			VARS
//		--------------------------------------------------------------------- */
//		
//		private var _en : BtnElement;
//		private var _pt : BtnElement;
//		
//		private var _en_trigger : Function;
//		private var _pt_trigger : Function;
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
//			_en = BtnElement ( child ( "en" ) );
//			_pt = BtnElement ( child ( "pt" ) );
//		}
//		
//		/**
//		 * Mount animation.
//		 */
//		public function after_render () : void
//		{
//			_selected = ( config.current_locale == "en" ? _en : _pt );
//			_selected.disable();
//			_selected.over();
//			
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
//		private function set_triggers () : void
//		{
//			_en.sprite.addEventListener( MouseEvent.CLICK , _en_trigger = proxy ( change_locale, "en" ) );
//			_pt.sprite.addEventListener( MouseEvent.CLICK , _pt_trigger = proxy ( change_locale, "pt" ) );
//		}
//		
//		/**
//		 * Unsets all triggers.
//		 */
//		private function unset_triggers () : void
//		{
//			_en.sprite.removeEventListener( MouseEvent.CLICK , _en_trigger );
//			_pt.sprite.removeEventListener( MouseEvent.CLICK , _pt_trigger );
//		}
//		
//		
//		
//		/* ---------------------------------------------------------------------
//			BEHAVIORS
//		--------------------------------------------------------------------- */
//		
//		/**
//		 * Change the application locale.
//		 * @param locale	Locale to use.
//		 * @param event	MouseEvent.CLICK
//		 */
//		private function change_locale ( locale : String, event : MouseEvent ) : void
//		{
//			_selected = this[ "_" + ( locale == "en" ? "pt" : "en" ) ];
//			_selected.enable();
//			_selected.out();
//			
//			_selected = this[ "_"+ locale ];
//			_selected.disable();
//			_selected.over();
//			
//			switchLocale( locale );
//		}
	}
}