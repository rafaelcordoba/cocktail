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
{
	import cocktail.core.data.dao.ProcessDAO;
	import cocktail.core.events.RouterEvent;
	
	import swfaddress.SWFAddress;
	import swfaddress.SWFAddressEvent;
	
	import flash.events.EventDispatcher;	

	/**
	 * Router class is responsible for all routing operations.
	 * 
	 * @author nybras | nybras@codeine.it
	 * @see Cocktail
	 * @see RouterEvent
	 */
	public class Router extends Index
	{
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		
		private var initialized : Boolean;
		
		private var dispatcher : EventDispatcher;
		private var _history : Array;
		private var _index : Number;
		
		private var lastUrlFreeze : Boolean;
		
		
		
		/* ---------------------------------------------------------------------
			INITIALIZING
		--------------------------------------------------------------------- */
		
		/**
		 * Creates a new Router instance.
		 */
		public function Router ()
		{
			log.info( "created!" );
			
			this.dispatcher = new EventDispatcher();
			
			this.history = new Array();
			this.index = -1;
			
			if ( config.pluginMode ) {
				SWFAddress.addEventListener( SWFAddressEvent.CHANGE, address_change );
				log.info( "Running in  plugin mode, SWFAddress activated." );
				return;
			}
			
			
			this.redirect( config.defaultUrl, true );
		}
		
		
		
		/* ---------------------------------------------------------------------
			LOCATION HANDLERS ( external & internal )
		--------------------------------------------------------------------- */
		
		/**
		 * Gets the current external url location.
		 * @return	The current external url location.
		 */
		public function get location () : String
		{
			return SWFAddress.getValue();
		}
		
		/**
		 * Redirects the application to the given url.
		 * @param url	Target location to redirect the application to.
		 * @param silentMode	If <code>true</code>, reflects the url in the address bar, otherwise <code>false</code> keeps the adress bar as it is.
		 */
		public function redirect ( url : String, silentMode : Boolean = false, freeze : Boolean = false ) : void
		{
			log.info( "redirect(" + url , silentMode , freeze + ");" );
						
			var dao : ProcessDAO;
			
			dao = new ProcessDAO( url, false, freeze );
			lastUrlFreeze = freeze;
			
			if ( ! silentMode && config.pluginMode ) {
				this.history.push( dao.url );
				this.index++;
				
				if ( url != SWFAddress.getValue() )
					SWFAddress.setValue( dao.url );
			}
			else
			{
				this.dispatcher.dispatchEvent( new RouterEvent( RouterEvent.CHANGE, dao.url, lastUrlFreeze ) );
			}
		}
		
		
		
		/* ---------------------------------------------------------------------
			HISTORY HANDLERS
		--------------------------------------------------------------------- */
		
		/**
		 * Check if theres external pages enough to perform a "back" operation.
		 * @return <code>true</code> if yes, <code>false</code> otherwise.
		 */
		public function get hasBack () : Boolean
		{
			return ( this.index > 0 );
		}

		/**
		 * Check it theres external pages enough to perform a "forward" operation.
		 * @return <code>true</code> if yes, <code>false</code> otherwise.
		 */
		public function get hasForward () : Boolean
		{
			return ( this.index < this.history.length );
		}
		
		
		
		/**
		 * Go forward one page.
		 */
		public function forward () : void
		{
			this.index++;
			SWFAddress.forward();
		}

		/**
		 * Go back one page.
		 */
		public function prev () : void
		{
			this.index--;
			SWFAddress.back();
		}
		
		/**
		 * Gets the history.
		 * @return	The history array.
		 */
		public function get history() : Array
		{
			return _history;
		}
		
		// TODO - the method below SHOULDN'T be public :) 
		/**
		 * Sets the history.
		 * @param history	The history array.
		 */
		public function set history(history : Array) : void
		{
			_history = history;
		}
		
		
		/**
		 * Gets the current history index.
		 * @return	The current history index.
		 */
		public function get index() : Number
		{
			return _index;
		}
		
		// TODO - the method below SHOULDN'T be public :) 
		/**
		 * Sets the current history index.
		 * @param index	The current history index.
		 */
		public function set index(index : Number) : void
		{
			_index = index;
		}
		
		/**
		 * Gets the last accessed url.
		 * @return	The last accessed url.
		 */
		public function get previousPageLocation () : String
		{
			return this.history[ this.index - 1 ];
		}
		
		
		
	 	/* ---------------------------------------------------------------------
			LINSTENERS SHORTCUTS
		--------------------------------------------------------------------- */
		
		/**
		 * Listen the RouterEvent.CHANGE.
		 */
		public function listen ( change : Function ) : void
		{
			this.dispatcher.addEventListener( RouterEvent.CHANGE , change );
		}
		
		/**
		 * Unlisten the RoutEvent.CHANGE.
		 */
		public function unlisten ( change : Function ) : void
		{
			this.dispatcher.removeEventListener( RouterEvent.CHANGE , change );
		}
		
		
		
		/* ---------------------------------------------------------------------
			SWFADDRESS LINSTENERS
		--------------------------------------------------------------------- */
		
		/**
		 * Listen the browser url changes ( SWFAddress ).
		 * 
		 * @param event	SWFAddressEvent.
		 */
		private function address_change( event : SWFAddressEvent ) : void 
		{
			log.info( "address_change" );
			
			var url : String;
			
			if ( ! initialized )
			{
				initialized = true;
				
				url = event.value;
				if ( url == "/" )
				{
					if ( config.defaultUrl != "/" )
						this.dispatcher.dispatchEvent( new RouterEvent( RouterEvent.CHANGE , config.defaultUrl, lastUrlFreeze ) );
						// SWFAddress.setTitle( xyz... );
				}
				else
				{
					this.dispatcher.dispatchEvent( new RouterEvent( RouterEvent.CHANGE , url, lastUrlFreeze ) );
					// SWFAddress.setTitle( xyz... );
				}
				
				return;
			}
			
			url = ( event.value == "/" ? config.defaultUrl : event.value );
			this.dispatcher.dispatchEvent( new RouterEvent( RouterEvent.CHANGE, url, lastUrlFreeze));
		}
	}
}
