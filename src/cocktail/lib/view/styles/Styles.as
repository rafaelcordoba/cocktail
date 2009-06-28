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

package cocktail.lib.view.styles
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;	

		/**
	 * Styles (multiple) manager.
	 * @author nybras | nybras@codeine.it
	 */
	public class Styles 
	{
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		
		private var _loading : Boolean;
		private var _loader : URLLoader;
		private	var _styles : *;
		
		
		
		/* ---------------------------------------------------------------------
			INITIALIZING
		--------------------------------------------------------------------- */
		
		/**
		 * Styles manager.
		 * @param url	Url to be loaded.
		 */
		public function Styles ( url : String = null ) : void
		{
			_styles = {};
			// load ( url );
		}
		
		
		
		/* ---------------------------------------------------------------------
			DESTROYING
		--------------------------------------------------------------------- */
		
		/**
		 * Destroys all styles, even if its still loading.
		 */
		public function destroy () : void
		{
			if ( _loading )
			{
				_loader.close();
				_loader.removeEventListener( Event.COMPLETE, _cache );
				
				_loading = false;
			}	
			_styles = null;
		}
		
		
		
		/* ---------------------------------------------------------------------
			STYLES SEARCH
		--------------------------------------------------------------------- */
		
		/**
		 * Search by the given style name.
		 * @return	The found style, parsed into object.
		 */
		public function style ( name : String ) : *
		{
			return _styles[ name ];
		}
		
		
		
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		
		/**
		 * Load the given style url.
		 * @param url	Url to be loaded.
		 */
		public function load ( url : String ) : void
		{
			_loading = true;
			_loader = new URLLoader();
			_loader.addEventListener( Event.COMPLETE, _cache );
			_loader.load( new URLRequest( url ) );
		}
		
		/**
		 * Cached all styles parsed into objects.
		 * @param event	Event.COMPLETE.
		 */
		private function _cache ( event : Event ) : void
		{
			var raw : *;
			var style : String;
			
			raw = Fss.parse ( URLLoader( event.target ).data );
			for ( style in raw )
				_styles[ style ] = raw[ style ];
			
			_loader.removeEventListener( Event.COMPLETE, _cache );
		}
		
	}
}