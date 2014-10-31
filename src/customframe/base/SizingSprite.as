package customframe.base
{
	import customframe.panels.menu.Menu;
	import customframe.panels.sidebar.Sidebar
	
	public class SizingSprite extends CustomSprite
	{
		protected var m_nWidth:Number = 0;
		protected var m_nHeight:Number = 0;

		/**
		 * SizingSprite extends CustomSprite to add fuctionality related to delayed updating of a sprite.
		 */
		public function SizingSprite()
		{
			super();
		}

		override public function get width():Number
		{
			if (m_bDirty)
			{
				Redraw();
			}

			return m_nWidth;
		}
		override public function set width(value:Number):void
		{
			if (value != m_nWidth)
			{
				m_nWidth = value;
				QueueRedraw();
			}
		}

		override public function get height():Number
		{
			if (m_bDirty)
			{
				Redraw();
			}

			return m_nHeight;
		}
		override public function set height(value:Number):void
		{
			if (value != m_nHeight)
			{	
				m_nHeight = value;
				QueueRedraw();
			}
		}
	}
}