package cocktail.core.logger.msgs 
{

	/**
	 * @author hems | hems@henriquematias.com
	 */
	public class LayoutMessages 
	{
		public static function get no_target_found() : String
		{
			return "No target found: rendering at cocktail.app";
		}
		
		public static function get no_action_to_load(): String
		{
			return "You have to populate xml_node, try running layout.parse_action first";
		}
	}
}
