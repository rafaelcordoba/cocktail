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

package cocktail.lib.view.ui 
{
	import cocktail.lib.view.styles.renders.Render;
	import cocktail.lib.view.ui.events.UIEvent;	

	/**
	 * Base UI class.
	 * @author nybras | nybras@codeine.it
	 */
	public class UI extends UIEvent 
	{
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		
		private var _renders : Array = [];
		
		/**
		 * Add a render to the renders array.
		 * @param render	Render to be added.
		 */
		protected function _add_render ( render : Render ) : void
		{
			_renders.push( render );
			render.boot ( _sprite, _style );
		}
		
	}
}