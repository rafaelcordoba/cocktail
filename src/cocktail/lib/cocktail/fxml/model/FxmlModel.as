/*	****************************************************************************
		Cocktail ActionScript Full Stack Framework. Copyright (C) 2009 Codeine.
	****************************************************************************
   
		This library is free software; you can redistribute it and/or modify
	it under the terms of the GNU Lesser General Public License as published
	by the Free Software Foundation; either version 2.1 of the License, or
	(at your option) any later version.
		
		This library is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
	or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public
	License for more details.

		You should have received a copy of the GNU Lesser General Public License
	along with this library; if not, write to the Free Software Foundation,
	Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

	-------------------------
		Codeine
		http://codeine.it
		contact@codeine.it
	-------------------------
	
*******************************************************************************/

package cocktail.lib.cocktail.fxml.model 
{
	import cocktail.lib.cocktail.fxml.Fxml;				

	/**
	 * Fxml base class for model DOM.
	 * @author nybras | nybras@codeine.it
	 */
	public class FxmlModel extends Fxml 
	{
		/* ---------------------------------------------------------------------
			INITIALIZING
		--------------------------------------------------------------------- */
		
		/**
		 * Initializes the module.
		 */
		function FxmlModel ()
		{
			super( "models" );
		}
		
		
		
		/* ---------------------------------------------------------------------
			READING / PREPROCESSING
		--------------------------------------------------------------------- */
		
		/**
		 * Reads the raw/xml action DOM, preprocess its contents and return it.
		 * @param name	Action name to handle.
		 * @return	The preprocessed action content.
		 */
		public function action ( name : String ) : XML
		{
			var structure : XML;
			
			structure = _structure..action.( @name == name )[ 0 ];
			
			if ( ! ( action is XML ) )
				structure = <action name={name} />;
			
			structure = _preprocessor.globals ( structure, path );
			structure = _preprocessor.params( structure, path );
			structure = _preprocessor.loops ( structure, path );
			
			return structure;
		}
	}
}