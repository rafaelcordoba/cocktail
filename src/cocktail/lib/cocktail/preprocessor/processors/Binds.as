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

package cocktail.lib.cocktail.preprocessor.processors 
{
	import cocktail.core.data.bind.Bind;
	import cocktail.lib.Model;
	import cocktail.lib.View;
	import cocktail.lib.cocktail.preprocessor.interfaces.IPreProcessor;
	import cocktail.utils.StringUtil;	

	/**
	 * Pre Processor class for {binds}.
	 * @author nybras | nybras@codeine.it
	 */
	public class Binds implements IPreProcessor 
	{
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		
		private var _bind : Bind;
		private var _model : Model;
		private var _view : View;
		
		
		
		/* ---------------------------------------------------------------------
			INITIALIZING
		--------------------------------------------------------------------- */
		
		/**
		 * Creates a new Binds instance.
		 * @param bind	Controller's Bind reference.
		 * @param model	Controller's Model reference.
		 * @param view	Controller's View reference.
		 */
		public function Binds ( bind : Bind, model : Model, view : View )
		{
			_bind = bind;
			_model = model;
			_view = view;
		}
		
		
		
		/* ---------------------------------------------------------------------
			PRE-PROCESSING
		--------------------------------------------------------------------- */
		
		/**
		 * Pre-process all binds.
		 * @param xml	The xml content to be pre-processed.
		 * @param path	The path of the xml file ( just to display clear error messages ).
		 * @return	The xml pos-processed.
		 */
		public function preprocess( xml: XML, path: String ) : XML
		{
			var key : String;
			var content : String;
			
			content = xml;
			
			for each ( key in StringUtil.enclosure( content, "{", "}") )
				StringUtil.replace_all( content, key, _bind.g( StringUtil.innerb( key ) ) );
			
			return new XML ( content );
		}
	}
}