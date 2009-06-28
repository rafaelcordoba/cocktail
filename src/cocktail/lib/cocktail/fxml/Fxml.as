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

package cocktail.lib.cocktail.fxml 
{
	import cocktail.core.Index;
	import cocktail.core.connectors.RequestConnector;
	import cocktail.core.connectors.request.RequestEvent;
	import cocktail.lib.cocktail.preprocessor.PreProcessor;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;		
	
	/**
	 * Fxml base class.
	 * @author nybras | nybras@codeine.it
	 */
	public class Fxml extends Index 
	{
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		
		public var path : String;
		
		protected var _structure : XML;
		protected var _preprocessor : PreProcessor;
		
		private var _type : String;
		private var _complete : Function;
		private var _dispatcher: EventDispatcher;
		
		
		
		/* ---------------------------------------------------------------------
			INITIALIZING
		--------------------------------------------------------------------- */
		
		/**
		 * Creates a new FXML instance.
		 * @param type	Fxml type (model|layout).
		 */
		public function Fxml ( type : String ) : void
		{
			_type = type;
		}
		
		/**
		 * Boot the module.
		 * @param preprocessor	Controller preprocessor instancereference.
		 */
		public function boot ( preprocessor: PreProcessor ): void
		{
			_dispatcher = new EventDispatcher ();
			_preprocessor = preprocessor;
		}
		
		
		
		/* ---------------------------------------------------------------------
			LOADING / CACHING
		--------------------------------------------------------------------- */
		
		/* loading main fxml */
		
		/**
		 * Loads the layout fxml.
		 * @param url	URL to be loaded.
		 * @return	A reference to the FXML class itself, for inline reuse.
		 */
		public function load ( url : String ) : Fxml
		{
			new RequestConnector().load( url, true ).listen( _cache );
			return this;
		}
		
		/**
		 * Cache the loaded fxml content.
		 * @param event	RequestEvent.COMPLETE.
		 */
		private function _cache ( event: RequestEvent ): void
		{
			_structure = XML ( event.iLoadableFile.getData() );
			_load_recursive();
		}
		
		
		
		/* loading main's required fxmls */
		
		/**
		 * Loads all required fxml's starting from the main layout fxml,
		 * recursively.
		 */
		private function _load_recursive () : void
		{
			var cache : Function;
			var node : XML;
			var url : String;
			
			if ( ( node = _structure..require[ 0 ] ) )
			{
				cache = proxy ( _cache_recursive, node );
				url = config.path( ".fxml" ) + _type +"/"+ node.@src;
				new RequestConnector().load( url, true ).listen( cache );
			}
			else
				_dispatcher.dispatchEvent( new Event ( Event.COMPLETE ) );
		}
		
		/**
		 * Cache the loaded fxml and invoke next loading, again.
		 * @param node	Fxml require node to be replaced by the loaded content.
		 * @param event	RequestEvent.COMPLETE.	
		 */
		private function _cache_recursive(
			node : XML,
			event : RequestEvent
		): void
		{
			var data : XMLList;
			
			data = new XMLList ( event.iLoadableFile.getData() ).children();
			node.parent().replace ( node.childIndex(), data );
			
			_load_recursive();
		}
		
		
		
		
		/* ---------------------------------------------------------------------
			LISTEN SHORTCUTS 
		--------------------------------------------------------------------- */
		
		/**
		 * Get the fxml structure.
		 * @return	The FXML structure.
		 */
		public function get structure() : XML
		{
			return _structure;
		}
		
		
		
		/* ---------------------------------------------------------------------
			LISTEN SHORTCUTS 
		--------------------------------------------------------------------- */
		
		/**
		 * Start listening for events.
		 * @param complete	Complete handler.
		 */
		public function listen ( complete : Function ) : void
		{
			_dispatcher.addEventListener( Event.COMPLETE, complete );
		}
		
		/**
		 * Stop listening for events.
		 * @param complete	Complete handler.
		 */
		public function unlisten ( complete : Function ) : void
		{
			_dispatcher.removeEventListener( Event.COMPLETE, complete );
		}
	}
}