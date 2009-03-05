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

package cocktail.utils {	import cocktail.core.Index;					/**	 * Utilities for array manipulation.	 * 	 * @author nybras | nybras@codeine.it	 */	public class ArrayUtil extends Index	{		/**		 * Deletes some item of the given array.		 * @param array	Array source.		 * @param value	Value to searched and delted.		 * @param prop	If informed, the value must be an object or something like that and the method compares the "prop" that must exist inside the given value instead of the value itself.		 * @return	The same given array, for inline re-use.		 */		public static function del ( array : Array, value : *, prop : * = null  ) : Array		{			var i : Number;						for ( i = ( array.length - 1 ) ; i >= 0; i-- )			{				if ( prop != null )				{					if ( array[ i ][ prop ] == value  )						array.splice( i, 1 );				}				else				{					if ( array[ i ] == value )						array.splice( i, 1 );				}			}						return array;		}				/**		 * Search the given array for the given value/key.		 * @param array	Array source.		 * @param value	Value to searched.		 * @param prop	If informed, the value must be an object or something like that and the method compares the "prop" that must exist inside the given value instead of the value itself.		 * @return	The found item.		 */		public static function find ( array : Array, value : *, prop : * = null  ) : *		{			var i : Number;						for ( i = ( array.length - 1 ) ; i >= 0; i-- )			{				if ( prop != null )				{					if ( array[ i ][ prop ] == value  )						return array[ i ];				}				else				{					if ( array[ i ] == value )						return array[ i ];				}			}						return null;		}				/**		 * Check if the array has some item or not.		 * @param array	Array source.		 * @param value		Value to be compared.		 * @param prop	If informed, the value must be an object or something like that and the method compares the "prop" that must exist inside the given value instead of the value itself.		 */		public static function has ( array : Array, value : *, prop : * = null ) : Boolean		{			var item : *;						for each ( item in array )				if ( prop != null && item[ prop ] == value )					return true;				else if ( item == value )					return true;						return false;		}				/**		 * Clones the given array and return it.		 * @param array	Source array to be cloned		 * @return	Cloned array.		 */		public static function clone ( array : Array ) : Array		{			var item : *;			var clone : Array = new Array;						for each ( item in array )				clone.push( item );							return clone;		}	}}