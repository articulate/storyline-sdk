package customframe.panels.menu
{
	import flash.events.Event;

	/**
	 * A ListEvent is used by the nodes in the menu tree to communicate bewtwen child nodes and their parents.
	 *
	 */
	public class MenuEvent extends Event
	{
		public static const ADJUST_LAYOUT:String = "adjustLayout";
		public static const COLLAPSE_NODES:String = "collapseNodes";
		public static const EXPAND_NODES:String = "expandNodes";
		public static const NODE_SELECTED:String = "nodeSelected";

		public var Node:MenuNode = null;
		public var NotifyFrame:Boolean = false;

		public function MenuEvent(type:String, oNode:MenuNode = null, bNotifyFrame:Boolean = false,
								  bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.Node = oNode;
			this.NotifyFrame = bNotifyFrame;
		}

		public override function clone():Event
		{
			return new MenuEvent(type, this.Node, this.NotifyFrame, bubbles, cancelable);
		}

		public override function toString():String
		{
			return formatToString("MenuEvent", "type", "Node", "NotifyFrame", "bubbles", "cancelable", "eventPhase");
		}
	}
}