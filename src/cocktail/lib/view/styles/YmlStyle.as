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
	import cocktail.utils.StringUtil;					

	/**
	 * Simple style parser for fss files.
	 * @author nybras | nybras@codeine.it
	 */
	public class YmlStyle
	{
		/* ----------------------------------------------------------------------
			VARS
		---------------------------------------------------------------------- */
		
		private static var _content : *;
		private static var _raw : String;
		
		
		
		/* ----------------------------------------------------------------------
			PARSING
		---------------------------------------------------------------------- */
		
		/**
		 * Clean up the FSS, filer all styles and parse them.
		 * @param raw	FSS raw.
		 */
		public static function parse ( raw : String ) : void
		{
			_content = {};
			_raw = raw;
			
			var tmp : String;
			var name : String;
			var names : Array;
			var props : Array;
			
			_raw = _raw.replace( /#.*/g, "" );
			names = _raw.match ( /^[\w_-]+\s*:$/gm );
			
			tmp = _raw;
			for each ( name in names )
				tmp = tmp.split( name ).join( "!=" );
			
			props = tmp.split( "!=" ).slice( 1 );
			
			while ( names.length )
				parse_item ( names.shift(), props.shift() );
		}
		
		/**
		 * Parse each style, extracting its name and props.
		 * @param name	Style name.
		 * @param props	Style props block (raw mode).
		 */
		private static function parse_item ( name : String, props : String ) : void
		{
			var tmp : *;
			var pos : uint;
			var prop : String;
			var value : String;
			
			name = name.substr( 0, name.indexOf( ":" ) );
			tmp = ( _content[ StringUtil.trim( name ) ] = {} );
			
			for each ( prop in props.match( /\w.*/g ) )
			{
				pos = prop.indexOf ( ":" );
				name = StringUtil.trim( prop.substr( 0, pos ) );
				value = StringUtil.trim( prop.substr( pos + 1 ) );
				tmp[ name ] = value;
			}
		}
	}
}