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

package cocktail.core 
	import cocktail.core.loggers.AlconLogger;
	import cocktail.core.loggers.Logger;
	import cocktail.core.loggers.MonsterLogger;
	import cocktail.lib.Controller;
	
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;	

	/**
		/* ---------------------------------------------------------------------
		}
		/**
		 * Describes the given item as XML.
		 * @return	Item described to XML. 
		 */
		public function describe ( name : String ) : XML
		{
			var described : XML;
			
			try
			{
				described = describeType( this[ name ] );
			}
			catch ( e : Error )
			{
				log.warn ( "Cannot describe item "+ name +"''." );
				log.warn ( e );
			}
			
			return described;
		}

		
		/**
		 * Check if some property/method/variabel is defined in the given scope.
		 * @param scope	Scope to evaluate.
		 * @param property	Property/Method/Variable to evaluate.
		 */
		public function defined ( scope : *, property : String ) : void
		{
			var result : Boolean;
			
			try
			{
				scope[ property ];
				result = true;
			}
			catch ( e : Error ) 
			{
				if ( e.errorID == 1006 )
					result = false;
			}
		}
		
		/**
		 * Tries to execute some method, handling the possible error results.
		 * @param scope	Method scope.
		 * @param method	Method name.
		 * @param params	Method params
		 */
		public function try_exec (
			scope : *,
			method : String,
			params : * = null
		) : void
		{
			if ( defined ( scope, method ) )
				scope[ method ].apply ( scope, (
					params != null ? [].concat( params ) : []
				) );
		}
		
		
		
		/* ----------------------------------------------------------------------
			CASTING VALUES
		---------------------------------------------------------------------- */
		
		/**
		 * Cast the given value as <code>Number</code>.
		 * @param value	Value to be casted.
		 * @return	Value as <code>Number</code>.
		 */
		protected function n ( value : * ) : uint
		{
			return Number ( value );
		}
		
		/**
		 * Cast the given value as <code>int</code>.
		 * @param value	Value to be casted.
		 * @return	Value as <code>int</code>.
		 */
		protected function i ( value : * ) : int
		{
			return int ( value );
		}
		
		/**
		 * Cast the given value as <code>uint</code>.
		 * @param value	Value to be casted.
		 * @return	Value as <code>uint</code>.
		 */
		protected function u ( value : * ) : uint
		{
			return uint ( value );
		}
		
		/**
		 * Cast the given value as <code>Boolean</code>.
		 * @param value	Value to be casted.
		 * @return	Value as <code>Boolean</code>.
		 */
		protected function b ( value : * ) : Boolean
		{
			return Boolean ( value );
		}