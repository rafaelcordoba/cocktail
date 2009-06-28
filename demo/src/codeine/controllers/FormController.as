package codeine.controllers 
{
	import codeine.AppController;
	import codeine.models.FormModel;
	import codeine.models.form.FormDAO;
	import codeine.views.FormView;
	import codeine.views.form.SendView;		

	/**
	 * Handles the form controller.
	 * @author nybras | nybras@codeine.it
	 */
	public class FormController extends AppController
	{
		/* ---------------------------------------------------------------------
			CASTING
		--------------------------------------------------------------------- */
		
		/**
		 * Cast the model for strict typing / completion.
		 * @return	FormModel.
		 */
		public function get form_model(): FormModel
		{
			return FormModel ( model );
		}
		
		/**
		 * Cast the view for strict typing / completion.
		 * @return	FormView.
		 */
		public function get form_view(): FormView
		{
			return FormView ( layout );
		}
		
		
		
		/* ---------------------------------------------------------------------
			DEPENDENCIES
		--------------------------------------------------------------------- */
		
		/**
		 * Specify dependencies for action /index/.
		 */
		public function index_uses () : void
		{
			uses ( "Main/base", true );
		}
		
		
		
		/* ---------------------------------------------------------------------
			SENDING FORM
		--------------------------------------------------------------------- */
		
		/**
		 * Sends the form an wait for server response.
		 * @param form	Form data to be sent.
		 */
		public function send ( form : FormDAO ) : void
		{
			form_model.send ( form, send_result );
		}
		
		/**
		 * Handles server response after sending form.
		 * @param status	Server result status.
		 */
		public function send_result ( status : Boolean ) : void
		{
			var send: SendView;
			
			send = SendView ( form_view.child( "body.form.form-mod" ) );
			
//			if ( status )
//				send.feedback( _bind.g( "success-msg" ) );
//			else
//				send.feedback( _bind.g( "error-msg" ) );
		}
	}
}