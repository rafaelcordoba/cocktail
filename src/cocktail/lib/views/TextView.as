package cocktail.lib.views 
{
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * TODO: Code auto-event-capture, see InteractiveView for a real example
	 * @author hems | henrique@cocktail.as
	 */
	public class TextView extends InteractiveView
	{
		public var field : TextField;
		public var format : TextFormat;
		
		[Embed(source='/../fonts/Verdana.ttf', 
		fontName='_Verdana', 
		unicodeRange='U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+00A1-U+00FF')]
        private var _Verdana:Class;
		
		override protected function _instantiate_display() : * 
		{
			super._instantiate_display( );
			
			Font.registerFont( _Verdana );
			
			format = new TextFormat();
			format.font = "_Verdana";
			
			if ( attribute( 'color' ) )
				format.color = attribute( 'color' );
			
			if ( attribute( 'align' ) )
				format.align = attribute( 'align' );
			
			if ( attribute( 'size' ) )
				format.size = attribute( 'size' );
			
			
				
			field = new TextField();
			field.defaultTextFormat = format;
			
			if ( attribute( 'antiAliasType' ) )
				field.antiAliasType = attribute( 'antiAliasType' );
			
			if ( attribute( 'alwaysShowSelection' ) )
				field.alwaysShowSelection = attribute( 'alwaysShowSelection' ) == 'true' ? true : false;
				
			if ( attribute( 'autoSize' ) )
				field.autoSize = attribute( 'autoSize' );

			if ( attribute( 'background' ) )
				field.background = attribute( 'background' ) == 'true' ? true : false;
			
			if ( attribute( 'backgroundColor' ) )
				field.backgroundColor = uint( attribute( 'backgroundColor' ) );
			
			if ( attribute( 'border' ) )
				field.border = attribute( 'border' ) == 'true' ? true : false;
			
			if ( attribute( 'borderColor' ) )
				field.borderColor = uint( attribute( 'borderColor' ) );
				
			if ( attribute( 'condenseWhite' ) )
				field.condenseWhite = attribute( 'condenseWhite' ) == 'true' ? true : false;
			
			if ( attribute( 'displayAsPassword' ) )
				field.displayAsPassword = attribute( 'displayAsPassword' ) == 'true' ? true : false;
			
			if ( attribute( 'embedFonts' ) )
				field.embedFonts = attribute( 'embedFonts' ) == 'true' ? true : false;;
			
			if ( attribute( 'gridFitType' ) )
				field.gridFitType = attribute( 'gridFitType' );
			
			if ( attribute( 'height' ) )
				field.height = n( attribute( 'height' ) );
			
			if ( attribute( 'html' ) == 'true' )
				field.htmlText = xml_node.text();
			else
				field.text = xml_node.text();
			
			if ( attribute( 'maxChars' ) )
				field.maxChars = n( attribute( 'maxChars' ) );
				
			if ( attribute( 'mouseWheelEnabled' ) )
				field.mouseWheelEnabled = attribute( 'mouseWheelEnabled' ) == 'true' ? true : false;
				
			if ( attribute( 'multiline' ) )
				field.multiline = attribute( 'multiline' ) == 'true' ? true: false;
			
			if ( attribute( 'restrict' ) )
				field.restrict = attribute( 'restrict' );
			
			if ( attribute( 'scrollH' ) )
				field.scrollH = n( attribute( 'scrollH' ) );
			
			if ( attribute( 'scrollV' ) )
				field.scrollV = n( attribute( 'scrollV' ) );
			
			if ( attribute( 'sharpness' ) )
				field.sharpness = n( attribute( 'sharpness' ) );
			
			if ( attribute( 'selectable' ) )
				field.selectable = attribute( 'selectable' ) == 'true' ? true : false;
				
			if ( attribute( 'textColor' ) )
				field.textColor = n( attribute( 'textColor' ) );
			
			if ( attribute( 'thickness' ) )
				field.thickness = n( attribute( 'thickness' ) );
			
			if ( attribute( 'type' ) )
				field.type = attribute( 'type' );
				
			if ( attribute( 'useRichTextClipboard' ) )
				field.useRichTextClipboard = attribute( 'useRichTextClipboard' ) == 'true' ? true : false;
				
			if ( attribute( 'width' ) )
				field.width = n( attribute( 'width' ) );
				
			if ( attribute( 'wordWrap' ) )
				field.wordWrap = attribute( 'wordWrap' ) == 'true' ? true : false;
			
			if ( attribute( 'x' ) )
				field.x = n( attribute( 'x' ) );
				
			if ( attribute( 'y' ) )
				field.y = n( attribute( 'y' ) );

			
			sprite.addChild( field );
		}
	}
}
