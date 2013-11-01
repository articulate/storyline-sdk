package customframe.components.scrollbar
{
	import flash.events.Event;

	/**
	 *
	 * A ScrollbarEvent is dispatched by the CustomScrollbar to tell its target how to update itself in response to
	 * user actions.
	 *
	 */
	public class ScrollbarEvent extends Event
	{
		public static const SCROLLING:String = "scrolling";

		public var Position:Number = 0;

		public function ScrollbarEvent(type:String, Position:Number = 0, bubbles:Boolean = false,
									   cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.Position = Position;
		}

		override public function clone():Event
		{
			return new ScrollbarEvent(type, this.Position, bubbles, cancelable);
		}

		override public function toString():String
		{
			return formatToString("ScrollbarEvent", "type", "Position", "bubbles", "cancelable", "eventPhase");
		}
	}
}
