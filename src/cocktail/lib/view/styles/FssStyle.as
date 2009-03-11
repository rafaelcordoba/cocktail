package cocktail.lib.view.styles{	import cocktail.utils.StringUtil;									/**	 * Simple style parser for fss files.	 * @author nybras | nybras@codeine.it	 */	public class FssStyle	{		/* ----------------------------------------------------------------------			VARS		---------------------------------------------------------------------- */				private static var _content : *;		private static var _raw : String;								/* ----------------------------------------------------------------------			PARSING		---------------------------------------------------------------------- */				/**		 * Clean up the FSS, filer all styles and parse them.		 * @param raw	FSS raw.		 */		public static function parse ( raw : String ) : *		{			_content = {};			_raw = raw;						var tmp : String;			var name : String;			var names : Array;			var props : Array;						_raw = _raw.replace( /#.*/g, "" );			names = _raw.match ( /^[\w_-]+\s*:$/gm );						tmp = _raw;			for each ( name in names )				tmp = tmp.split( name ).join( "|m|" );						props = tmp.split( "|m|" ).slice( 1 );						while ( names.length )				parse_item ( names.shift(), props.shift() );						return _content;		}				/**		 * Parse each style, extracting its name and props.		 * @param name	Style name.		 * @param props	Style props block (raw mode).		 */		private static function parse_item ( name : String, props : String ) : void		{			var tmp : *;			var pos : uint;			var prop : String;			var value : String;						name = name.substr( 0, name.indexOf( ":" ) );			tmp = ( _content[ StringUtil.trim( name ) ] = {} );						for each ( prop in props.match( /\w.*/g ) )			{				pos = prop.indexOf ( ":" );				name = StringUtil.trim( prop.substr( 0, pos ) );				value = StringUtil.trim( prop.substr( pos + 1 ) );				tmp[ name ] = value;			}		}	}}