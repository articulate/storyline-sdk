package com.articulate.wg.v3_0
{
	import flash.events.Event;

	public class wgEventTimeline extends Event
	{
		/**
		 * The <i>UPDATE_TIMELINE</i> constant defines the value of the <i>type</i> property of the
		 * event that is dispatched when the timeline needs to be updated.
		 */
		public static const UPDATE_TIMELINE:String = "bw_update_timeline";
		/**
		 * The <i>TIMELINE_CHANGED</i> constant defines the value of the <i>type</i> property of the
		 * event that is dispatched when the timeline is changed.
		 */
		public static const TIMELINE_CHANGED:String = "bw_timeline_changed";

		public function wgEventTimeline(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		/**
		 * @private
		 */
		public override function clone():Event
		{
			return new wgEventTimeline(type, bubbles, cancelable);
		}

		/**
		 * @private
		 */
		public override function toString():String
		{
			return formatToString("wgEventTimeline", "type", "bubbles", "cancelable", "eventPhase");
		}
	}
}