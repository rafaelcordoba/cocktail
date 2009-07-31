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

package cocktail.core.data.dao.style {
	import cocktail.core.data.dao.style.StyleDAO;
	
	/**
	 * @author carlos
	 */
	public class StyleCheckDAO extends StyleDAO 
	{
		
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		//BG
		public var bg_color : Number = 0xffffff;
		
		//BORDER
		public var border_color : Number = 0xffffff;
		public var thickness : Number = 2;
		
		//MARKER
		public var marker_color : Number = 0xffffff;
		
			
		/**
		 * Creates a new StyleCkeckDAO instance.
		 * @param item	The item xml node.
		 */
		public function StyleCheckDAO( item : XML = null ) 
		{
			super( item );
			
			autoApplicableVars = autoApplicableVars.split( "|width" ).join( "" );
			autoApplicableVars = autoApplicableVars.split( "|height" ).join( "" );
		}
		
	}
}