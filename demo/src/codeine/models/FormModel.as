package codeine.models 
{
	import cocktail.core.data.amf.Amf;
	
	import codeine.AppModel;
	import codeine.models.form.FormDAO;	

	/**
	 * Handles the form model.
	 * @author nybras | nybras@codeine.it
	 */
	public class FormModel extends AppModel
	{
		/* ---------------------------------------------------------------------
			SEND FORM
		--------------------------------------------------------------------- */
		
		/**
		 * Send form.
		 * @param form	Form DAO.
		 * @param result	Result callback.
		 */
		public function send ( form : FormDAO, result : Function ) : void
		{
			var login : Amf;
			
			login = new Amf( config.gateway(), "Form" );
			login.result = result;
			login.invoke( "send", [
				config.current_locale,
				form.name,
				form.email,
				form.select,
				form.radio,
				form.check,
				form.comment
			]);
		}
	}
}