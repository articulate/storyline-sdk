package customframe.windows.prompt
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	import customframe.base.SizingSprite;

	public class PromptContentArea extends SizingSprite
	{
		public static const CHILD_ADDED:String = "childAdded";

		public function PromptContentArea()
		{
			super();
		}

		override public function addChild(child:DisplayObject):DisplayObject
		{
			dispatchEvent(new Event(CHILD_ADDED));
			QueueRedraw();

			return super.addChild(child);
		}

		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			dispatchEvent(new Event(CHILD_ADDED));
			QueueRedraw();

			return super.addChildAt(child, index);
		}

		override public function Redraw():void
		{
			super.Redraw();
			this.width = m_nWidth;
			this.height = m_nHeight;
			this.scaleX = 1;
			this.scaleY = 1;
		}
	}
}