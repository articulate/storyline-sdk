package com.articulate.wg.v3_0
{
	import flash.events.Event;

	/**
	 * Represents events related to <i>wgIWindow</i> objects.
	 */
	public class wgEventWindow extends Event
	{
		/**
		 * The <i>EVENT_CLOSE_WINDOW</i> constant defines the value of the <i>type</i> property of
		 * the event that should be dispatched when the user closes a window.
		 */
		public static const EVENT_CLOSE_WINDOW:String = "wg_wnd_close";

		/**
		 * @param type The type of the event, accessible as wgEventWindow.type.
		 * @param bubbles Determines whether the Event object participates in the bubbling stage of the event flow.
		 * The default value is false.
		 * @param cancelable Determines whether the Event object can be canceled. The default values is false.
		 */
		public function wgEventWindow(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		/**
		 * @private
		 */
		public override function clone():Event
		{
			return new wgEventWindow(type, bubbles, cancelable);
		}

		/**
		 * @private
		 */
		public override function toString():String
		{
			return formatToString("wgEventWindow", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}