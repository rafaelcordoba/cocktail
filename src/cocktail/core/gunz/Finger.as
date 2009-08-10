package cocktail.core.gunz 
{
	import cocktail.core.gunz.Trigger;	

	/**
	 * Base Finger class.
	 * @author nybras | nybras@codeine.it
	 */
	public class Finger 
	{
		/* ---------------------------------------------------------------------
			VARS
		--------------------------------------------------------------------- */
		
		internal var _id : uint;
		internal var _trigger : Trigger;
		
		internal var _type : String;
		internal var _handler : Function;
		internal var _params : Object;
		
		internal var _times : Number;
		internal var _pulled : Number;
		
		
		
		/* ---------------------------------------------------------------------
			INITIALIZING
		--------------------------------------------------------------------- */
		
		/**
		 * Creates a new Trigger's Finger with the given props.
		 * @param id	Finger's id ( index on trigger listeners array )
		 * @param trigger	Parent trigger.
		 * @param type	Bullet type.
		 * @param handler	Bullet handler.
		 * @param params	Bullet params.
		 * @param params	Number of times the listener should live, if the
		 * times is <code>-1</code> its infinite ( default ) as usual, otherwise
		 * the listener will work just for the given number of times and after
		 * that its automagicaly-destroyed.
		 */
		public function Finger (
			id : uint,
			trigger : Trigger,
			type : String,
			handler : Function,
			params : Object,
			times : Number
		) {
			_id = id;
			_trigger = trigger;
			_type = type;
			_handler = handler;
			_params = params;
			_times = times;
			_pulled = 0;
		}
		
		
		
		/* ---------------------------------------------------------------------
			PULL / RELEASE
		--------------------------------------------------------------------- */
		
		/**
		 * Pull the Trigger, shooting the given bullet w/ params/owner injected.
		 * @param bullet	Bullet to be pulled.
		 */
		internal function pull ( bullet : Bullet ) : void
		{
			bullet.set_params( _params );
			bullet.set_owner( _trigger._owner );
			_handler( bullet );
			
			if ( _times != -1 && ++_pulled == _times )
				release();
		}
		
		/**
		 * Release the Finger, disabling it from pulling again.
		 */
		internal function release () : void
		{
			_trigger._listeners.splice( _id, 1 );
			
			if ( _id < ( _trigger._listeners.length - 1) )
				do
				{
					Finger ( _trigger._listeners [ _id ] )._id--;
				} while ( ++_id < _trigger._listeners.length );
			
			_id = undefined;
			_trigger = undefined;
			_type = undefined;
			_handler = undefined;
			_params = undefined;
		}
	}
}