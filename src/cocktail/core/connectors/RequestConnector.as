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

package cocktail.core.connectors 
{
	import ch.capi.events.MassLoadEvent;
	import ch.capi.net.CompositeMassLoader;
	import ch.capi.net.LoadableFileType;
	
	import cocktail.core.Index;
	import cocktail.core.connectors.request.RequestEvent;
	import cocktail.core.connectors.request.RequestKeeper;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;	

	/**
	 * RequestConnector to hanle all loading requests between application and MASAPI.
	 * 
	 * @author nybras | nybras@codeine.it
	 * @see CompositeMassLoader
	 */
	public class RequestConnector extends Index
	{
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		
		private static var refs : Array;
		
		private var _context : LoaderContext;
		private var _queue : CompositeMassLoader; 
		private var _dispatcher : EventDispatcher;
		
		
		
		/* ---------------------------------------------------------------------
			INITIALIZING
		--------------------------------------------------------------------- */
		
		/**
		 * TODO - add documentation for all methods!
		 */
		public function RequestConnector ()
		{
			RequestConnector.refs = new Array();
			
			_context = new LoaderContext( true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain );
			
			_queue = new CompositeMassLoader();
			_queue.loadableFileFactory.defaultLoaderContext = _context;
			
			_queue.massLoader.addEventListener( Event.COMPLETE, queue_complete );
			_queue.massLoader.addEventListener( ProgressEvent.PROGRESS , queue_progress );
			_queue.massLoader.addEventListener( MassLoadEvent.FILE_OPEN , queue_start );
			_queue.massLoader.addEventListener( IOErrorEvent.IO_ERROR , queue_error );
			
			_dispatcher = new EventDispatcher();
		}
		
		/**
		 * 
		 */
		public function get isLoading () : Boolean
		{
			return _queue.massLoader.stateLoading;
		}
		
		/**
		 * 
		 */
		public function start () : void
		{
			_queue.start();
		}
		
		/**
		 * 
		 */
		public function load ( url : String, autoLoad : Boolean ) : RequestKeeper
		{
			var type : String;
			var keeper : RequestKeeper;
			
			switch ( url.split(".").pop() ) {
				case "swf":
					type = LoadableFileType.SWF;
				break;
				
				case "jpg":
					type = LoadableFileType.SWF;
				break;
				
				case "gif":
					type = LoadableFileType.SWF;
				break;
				
				case "png":
					type = LoadableFileType.SWF;
				break;
				
				case "xml":
					type = LoadableFileType.TEXT;
				break;
				
				case "fxml":
					type = LoadableFileType.TEXT;
				break;
			}
			
			// cache control
			if ( config && !config.cache() )
				url += nocache_str();
			
			keeper = new RequestKeeper( _queue.addFile( url, type ) , autoLoad );
			RequestConnector.refs.push( keeper );
			
			return keeper; 
		}
		
		
		
		/**
		 * 
		 */
		public function listen ( complete : Function, init : Function = null, progress : Function = null, start : Function = null, error : Function = null ) : void
		{
			if ( complete != null ) _dispatcher.addEventListener( RequestEvent.COMPLETE , complete );
			if ( init != null ) _dispatcher.addEventListener( RequestEvent.INIT , init );
			if ( progress != null ) _dispatcher.addEventListener( RequestEvent.PROGRESS , progress );
			if ( start != null ) _dispatcher.addEventListener( RequestEvent.START , start );
			if ( error != null ) _dispatcher.addEventListener( RequestEvent.ERROR , error );
		}
		
		/**
		 * 
		 */
		public function unlisten ( complete : Function, init : Function = null, progress : Function = null, start : Function = null, error : Function = null ) : void
		{
			if ( complete != null ) _dispatcher.removeEventListener( RequestEvent.COMPLETE , complete );
			if ( init != null ) _dispatcher.removeEventListener( RequestEvent.INIT , init );
			if ( progress != null ) _dispatcher.removeEventListener( RequestEvent.PROGRESS , progress );
			if ( start != null ) _dispatcher.removeEventListener( RequestEvent.START , start );
			if ( error != null ) _dispatcher.removeEventListener( RequestEvent.ERROR , error );
		}
		
		
		
		/* ---------------------------------------------------------------------
			CACHE HANDLING
		--------------------------------------------------------------------- */
		
		/**
		 * Returns a unique value, always.
		 */
		private function nocache_str () : String
		{
			var date : Date;
			var output : String;
			
			date = new Date();
			
			output = "?nocache=";
			output += date.getFullYear().toString();
			output += "|"+ date.getMonth();
			output += "|"+ date.getDate();
			output += "|"+ date.getHours();
			output += "|"+ date.getMinutes();
			output += "|"+ date.getSeconds();
			output += "|"+ date.getMilliseconds();
			
			return output;
		}
		
		
		
		/* ---------------------------------------------------------------------
			LISTENERS
		--------------------------------------------------------------------- */
		
		/**
		 * 
		 */		
		private function queue_start ( event : MassLoadEvent ) : void
		{
			dispatch( RequestEvent.START );
		}
		
		/**
		 * 
		 */
		private function queue_progress ( event : ProgressEvent ) : void
		{
			dispatch ( RequestEvent.PROGRESS );
		}
		
		/**
		 * 
		 */
		private function queue_complete ( event : Event ) : void
		{
			dispatch ( RequestEvent.COMPLETE );
		}
		
		/**
		 * 
		 */
		private function queue_error ( event : IOErrorEvent ) : void
		{
			log.debug( event );
			dispatch ( RequestEvent.ERROR );
		}
		
		
		
		/**
		 * 
		 */
		private function dispatch ( type : String ) : void
		{
			_dispatcher.dispatchEvent( new RequestEvent( type , null, _queue.massLoader ) );
		}
	}
}
