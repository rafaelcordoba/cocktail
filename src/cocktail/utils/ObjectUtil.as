package cocktail.utils 
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author hems @ henriquematias.com
	 */
	public class ObjectUtil 
	{
		public static function classpath( obj : * ) : String
		{
			return getQualifiedClassName( obj ).replace( "::", "." );
		}

		public static function classname( obj : * ) : String 
		{
			return ObjectUtil.classpath( obj ).split( "." ).pop( );
		}

		/**
		 * Describes the given property as XML.
		 * @return	Item described to XML. 
		 */
		public static function describe( obj : Object, name : String ) : XML
		{
			var described : XML;
			
			try
			{
				described = describeType( obj[ name ] );
			}
			catch( e : Error )
			{
				return null;
			}
			
			return described;
		}

		public static function is_defined(
			scope : *, 
			property : String
		) : Boolean 
		{
			var result : Boolean;
			
			try
			{
				scope[ property ];
				result = true;
			}
			catch( e : Error ) 
			{
				if( e.errorID == 1006 )
					result = false;
			}
			
			return result;
		}

		/**
		 * Tries to execute some method, omitting the possible error results.
		 * 
		 * @param scope	Method scope.
		 * @param method	Method name.
		 * @param params	Method params
		 */
		public static function exec(
			scope : *,
			method : String,
			params : * = null
		) : *
		{
			if( is_defined( method, scope ) )
				return Function( scope[ method ] ).apply( scope, (
					params != null ? [][ 'concat' ]( params ) : []
				) );
		}

		/**
		 * Creates a proxy function holding default params.
		 * 
		 * @param method	Method to be handled.
		 * 
		 * @param params	Default params to be passed to method, these params
		 * will be added in *first* place.
		 * 
		 * @return	The proxy function with the given params.
		 */
		public static function proxy( method : Function, ...params ) : Function
		{
			return ( function( ...innerParams ):void
			{
				method.apply( method.prototype, params.concat( innerParams ) );
			} );
		}

		/**
		 * Returns a function that will run trought properties object and
		 * copy properties values into target properties.
		 *
		 * The function return will rave a "...rest" parameter, so use it
		 * at your own risk, since its wont throw any errors
		 * 
		 * @param properties	object with properties already assigned
		 * 
		 * @param target	object that will received those properties	
		 * 
		 * @return	Applyer function
		 */
		public static function apply( properties : Object, target : * ) : Function
		{
			return proxy( function( props : *, obj : *, ...rest ): void
			{
				for ( var prop : String in props ) 
				{
					obj[ prop ] = props[ prop ];
				}
			}, properties, target );
		}
	}
}
