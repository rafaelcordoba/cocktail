package cocktail.lib.cocktail.fxml.view {	import cocktail.lib.cocktail.fxml.Fxml;							/**	 * @author nybras | nybras@codeine.it	 */	public class FxmlView extends Fxml 	{		public function action ( name : String ) : XMLList		{			var structure : XML;						structure = _structure..action ( @name == name ) [ 0 ] ;			if ( ! ( action is XML ) )				structure = <action name={name} />;						structure = _preprocessor.globals ( structure, _path );			structure = _preprocessor.params( structure, _path );			structure = _preprocessor.loops ( structure, _path );			structure = _preprocessor.sweeps ( structure, _path );						return structure;		}	}}