package cocktail.core.embedder
{
	import cocktail.lib.models.datasources.AmfDataSource;
	import cocktail.lib.models.datasources.HttpDataSource;
	import cocktail.lib.models.datasources.InlineDataSource;
	import cocktail.lib.models.datasources.JsonDataSource;
	import cocktail.lib.models.datasources.XmlDataSource;
	import cocktail.lib.views.ImgView;
	import cocktail.lib.views.SwfView;
	import cocktail.lib.views.TextFieldView;
	import cocktail.lib.views.VideoView;
	import cocktail.lib.views.components.player.PlayerView;
	import cocktail.lib.views.components.player.BufferView;
	import cocktail.lib.views.components.player.ControlView;

	/**
	 * Embeder class for cocktail.
	 * @author nybras | nybras@codeine.it
	 * @author hems | hems@henriquematias.com
	 */
	public class EmbedderTail 
	{
		public function EmbedderTail()
		{
			XmlDataSource;
			HttpDataSource;
			InlineDataSource;
			AmfDataSource;
			JsonDataSource;
			
			ImgView;
			SwfView;
			TextFieldView;
			VideoView;
			PlayerView;
			ControlView;
			BufferView;
		}
	}
}