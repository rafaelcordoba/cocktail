package codeine.views 
{
	import cocktail.core.data.dao.ProcessDAO;
	
	import codeine.AppView;	

	/**
	 * Handles the datasources interface.
	 * @author nybras | nybras@codeine.it
	 */
	public class DatasourcesView extends AppView 
	{
		/* ---------------------------------------------------------------------
			RENDERING
		--------------------------------------------------------------------- */
		
		/**
		 * Prepare everything before render.
		 */
		public function before_render () : void
		{
			_sprite.alpha = 0;
		}
		
		/**
		 * Mount animation.
		 */
		public function after_render () : void
		{
//			motion.alpha( 1, .5 ).listen( render_done );
		}
		
		
		
		/* ---------------------------------------------------------------------
			DESTROYING
		--------------------------------------------------------------------- */
		
		/**
		 * Unmount animation.
		 * @param dao	ProcessDAO to be destroyed.
		 */
		public function before_destroy ( dao : ProcessDAO ) : void
		{
//			motion.alpha( 0, .5 ).listen( destroy_done ); dao;
		}
	}
}