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

package cocktail.core.scheme 
{
	import flash.display.Sprite;
	import flash.utils.describeType;

	/**
	 * Base class for XML Schemes auto-parsing, you just need to extend this
	 * class and declare your XML desire attributtes as public variables, and
	 * voila! All variable will be automagically parsed. 
	 */
	public class Scheme extends Sprite
	{
		/* ----- VARS ------------------------------------------------------- */
		
		private var _variables : XMLList;
		private var _xml : XML;
		
		
		
		/* ----- PROPERTIES ------------------------------------------------- */
		 
		public var id : String;
		public var src : String;
		public var target : String;
		public var require : String;
		
		public var tag_name : String;
		public var children : XMLList;
		
		
		
		/* ----- CONSTRUCTOR ------------------------------------------------ */
		
		/**
		 * Caches the xml_node, extract the children and tag_name and invoke
		 * the parser.
		 * @param node	XML node to be parsed into this scheme.
		 */
		public function Scheme( node : XML ) 
		{
			_xml = node;
			
			tag_name = _xml.localName();
			children = _xml.children( );
			
			_parse( );
		}
		
		
		
		/* ----- PARSING ---------------------------------------------------- */
		
		/**
		 * Automagically parses the XML Scheme, based on the public variables
		 * declared in your Scheme class.
		 */
		private function _parse() : void 
		{
			var variable : XML;
			var value : *;
			
			_variables = describeType( this )..variable;
			for each ( variable in _variables )
				if ( ( value = _xml.@[ variable.@name ] ) != undefined )
				{
					switch ( variable.@type )
					{
						case "Boolean":
							value = ( value == "true" || value == true );
						break;
					}
					this[ variable.@name ] = value;
				} 
		}
	}
}