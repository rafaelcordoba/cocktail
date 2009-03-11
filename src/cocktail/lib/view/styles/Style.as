package cocktail.lib.view.styles{	import cocktail.lib.view.styles.selectors.PositionSelector;	import cocktail.utils.StringUtil;					/**	 * Style (individual) manager.	 * @author nybras | nybras@codeine.it	 */	public class Style extends PositionSelector	{		/* ---------------------------------------------------------------------			INITIALIZING		---------------------------------------------------------------------- */				/**		 * Style class.		 * @param name	Style name.		 * @param properties	StyleYml.		 */		public function Style ( name : String, properties: *, parent : Style ) : void		{			var key : String;			var value : String;						_name = name;			_parent = parent;						for ( key in properties )			{				try				{					name = StringUtil.replace_all ( key, "-", "_" ).toUpperCase();					value = properties[ key ];					this[ StringUtil.trim ( name ) ] = StringUtil.trim( value );				}				catch ( e : Error )				{					log.warn ( e );				}			}		}	}}