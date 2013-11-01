package customframe.components.list
{
	import flash.events.Event;

	/**
	 * A ListEvent is used to communicate when the user clicks in a list item.
	 *
	 */
	public class ListEvent extends Event
	{
		public static const ITEM_CLICKED:String = "itemClicked";

		public var Item:ListItem = null;

		public function ListEvent(type:String, Item:ListItem, bubbles:Boolean = true, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.Item = Item;
		}

		override public function clone():Event
		{
			return new ListEvent(type, Item, bubbles, cancelable);
		}

		override public function toString():String
		{
			return formatToString("ListEvent", "type", "Item", "bubbles", "cancelable", "eventPhase");
		}
	}
}