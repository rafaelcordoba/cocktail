package codeine.views.form 
{
	import cocktail.core.data.dao.ProcessDAO;
	import cocktail.lib.view.helpers.FormHelper;
	import cocktail.lib.view.helpers.events.FormEvent;
	
	import codeine.AppView;
	import codeine.controllers.FormController;
	import codeine.models.form.FormDAO;
	
	import flash.events.MouseEvent;		

	/**
	 * Handles the form fields interface.
	 * @author nybras | nybras@codeine.it
	 */
	public class SendView extends AppView 
	{
		/* ---------------------------------------------------------------------
			CASTING CONTROLLER
		--------------------------------------------------------------------- */
		
		/**
		 * Cast the controller for strict typing / completion.
		 * @return	FormController.
		 */
		public function get form_ctrl(): FormController
		{
			return FormController ( _controller );
		}

		
		
//		/* ---------------------------------------------------------------------
//			VARS
//		--------------------------------------------------------------------- */
//		
//		private var _form: FormHelper;
//		
//		private var _send: BtnElement;
//		private var _feedback : TxtElement;
//
//		private var _name : TxtElement;
//		private var _email : TxtElement;
//		private var _select : SelectElement;
//		private var _radio : RadiogroupElement;
//		private var _check1 : CheckElement;
//		private var _check2 : CheckElement;
//		private var _comment : TxtElement;
//		
//		
//		
//		/* ---------------------------------------------------------------------
//			INITIALIZING
//		--------------------------------------------------------------------- */
//		
//		private function _init () : void
//		{
//			_name = TxtElement ( child("name.input" ) );
//			_email = TxtElement ( child ( "email.input" ) );
//			_select = SelectElement ( child ( "select.subject" ) );
//			_radio = RadiogroupElement ( child ( "radio.group" ) );
//			_check1 = CheckElement ( child ( "check.check-1" ) );
//			_check2 = CheckElement ( child ( "check.check-2" ) );
//			_comment = TxtElement ( child ( "comment.input" ) );
//			
//			_send = BtnElement ( child ( "send" ) );
//			_feedback = TxtElement ( child ( "feedback" ) );
//			
//			_form = new FormHelper ();
//			_form.add( _name, "text", "name", _bind.g ( "name-msg" ) ).length( 3 ).listen( vtxt, itxt );
//			_form.add( _email, "text", "email", _bind.g ( "email-msg" ) ).email().listen( vtxt, itxt );
//			_form.add( _select, "value", "select", _bind.g ( "info-msg" ) ).notnull().listen( vsel, isel );
//			_form.add( _radio, "value", "radio" );
//			_form.add( _check1, "checked", "check-1" );
//			_form.add( _check2, "checked", "check-2" );
//			_form.add( _comment, "text", "comment", _bind.g ( "comment-msg" ) ).length( 3 ).listen( vtxt, itxt );
//		}
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
//			_sprite.alpha = 0;
//			_init();
//		}
//		
//		/**
//		 * Mount animation.
//		 */
//		public function after_render () : void
//		{
//			motion.alpha( 1, .5 ).listen( render_done );
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
//			motion.alpha( 0, .5 ).listen( destroy_done ); dao;
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
//			_send.sprite.addEventListener( MouseEvent.CLICK, send );
//		}
//
//		/**
//		 * Unsets all triggers.
//		 */
//		public function unset_triggers () : void
//		{
//			_send.sprite.removeEventListener( MouseEvent.CLICK, send );
//		}
//		
//		
//		
//		/* ---------------------------------------------------------------------
//			VALIDATING, HIGHLIGHTS, SENDING FORM
//		--------------------------------------------------------------------- */
//		
//		/**
//		 * Send click trigger, sends the form.
//		 * @param event	MouseEvent.CLICK.
//		 */
//		public function send ( event: MouseEvent ): void
//		{
//			if ( !_form.valid )
//				return;
//			
//			form_ctrl.send ( new FormDAO (
//				_form.g( "name" ),
//				_form.g( "email" ),
//				_form.g( "select" ),
//				_form.g( "radio" ),
//				_bind.g( "check-1" ) +"="+ _form.g( "check-1" ) + "\r\n" +
//				_bind.g( "check-2" ) +"="+ _form.g( "check-2" ),
//				_form.g( "comment" )
//			) );
//			
//			feedback( _bind.g( "sending" ) );
//		}
//		
//		
//		
//		/**
//		 * Shows the given message.
//		 * @param message	Message to be shown.
//		 */
//		public function feedback ( message : String ) : void
//		{
//			_feedback.field.text = message;
//		}
//		
//		
//		
//		/**
//		 * Invoked when some TxtElenent is validated.
//		 * @param event	FormEvent.VALIDATE.
//		 */
//		public function vtxt ( event : FormEvent ) : void
//		{
//			TxtElement ( event.item.instance ).field.borderColor = 0x000000;
//			feedback ( "" );
//		}
//		
//		/**
//		 * Invoked when some TxtElenent is invalidated.
//		 * @param event	FormEvent.INVALIDATE.
//		 */
//		public function itxt ( event : FormEvent ) : void
//		{
//			TxtElement ( event.item.instance ).field.borderColor = 0xff0000;
//			feedback ( event.item.message );
//		}
//		
//		
//		
//		/**
//		 * Invoked when some SelecElement is validated.
//		 * @param event	FormEvent.VALIDATE.
//		 */
//		public function vsel ( event : FormEvent ) : void
//		{
//			SelectElement ( event.item.instance ).highlight( false );
//			feedback ( "" );
//		}
//		
//		/**
//		 * Invoked when some SelecElement is invalidated.
//		 * @param event	FormEvent.INVALIDATE.
//		 */
//		public function isel ( event : FormEvent ) : void
//		{
//			SelectElement ( event.item.instance ).highlight();
//			feedback ( event.item.message );
//		}
	}
}