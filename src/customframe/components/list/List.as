package customframe.components.list
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	import customframe.base.SizingSprite;
	import customframe.components.scrollbar.CustomScrollbar;
	import customframe.components.scrollbar.ScrollbarEvent;
	import customframe.panels.sidebar.Sidebar;

	/**
	 * This is the logic for the List symbol in the library (/components/list/List.)
	 *
	 * List adds a series of items and displays them on the screen.
	 *
	 */
	public class List extends SizingSprite
	{
		public var background:Sprite;
		public var scrollbar:CustomScrollbar;

		protected var m_arrListItems:Array = new Array();
		protected var m_oSelectedItem:ListItem = null;
		protected var m_nBackgroundColor:uint = 0xFFFFFF;

		public function List()
		{
			super();

			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			this.scrollbar.addEventListener(ScrollbarEvent.SCROLLING, Scrollbar_onScrolling);

			m_nWidth = super.width;
			m_nHeight = super.height;
			Redraw();
		}

		override public function Redraw():void
		{
			var nWidth:int = m_nWidth;
			if (this.scrollbar.ContentHeight > m_nHeight)
			{
				this.scrollbar.x = m_nWidth - this.scrollbar.width;
				nWidth = this.scrollbar.x - 1;
				this.scrollbar.visible = true;
				this.scrollbar.height = m_nHeight;
				this.background.scrollRect = new Rectangle(0, this.scrollbar.Position, nWidth, m_nHeight - 1);
			}
			else
			{
				this.scrollbar.visible = false;
			}

			this.background.width = nWidth;
			this.background.height = m_nHeight;
			this.background.scaleX = 1;
			this.background.scaleY = 1;

			for (var i:int = 0; i < m_arrListItems.length; ++i)
			{
				var oListItem:ListItem = GetItemAtIndex(i);
				oListItem.width = nWidth;
			}
		}

		protected function onMouseWheel(evt:MouseEvent):void
		{
			if (this.stage != null)
			{
				this.scrollbar.ScrollByLines(-Math.round(evt.delta / 3));
			}
		}

		protected function Scrollbar_onScrolling(evt:ScrollbarEvent):void
		{
			this.background.scrollRect = new Rectangle(0, this.scrollbar.Position, this.scrollbar.x - 1, m_nHeight - 1);
		}

		public function GetItemAtIndex(nIndex:int):ListItem
		{
			return m_arrListItems[nIndex];
		}

		public function RemoveAll():void
		{
			for (var i:int = 0; i < m_arrListItems.length; ++i)
			{
				m_arrListItems[i].removeEventListener(ListEvent.ITEM_CLICKED, ListItem_onItemClicked);
				removeChild(m_arrListItems[i]);
			}

			m_arrListItems = new Array();
		}

		public function AddListItem(oItem:ListItem):void
		{
			oItem.x = 0;
			var nY:Number = 0;

			if (m_arrListItems.length > 0)
			{
				var oPreviousItem:ListItem = m_arrListItems[m_arrListItems.length - 1];
				nY = oPreviousItem.y + oPreviousItem.height;
			}

			oItem.y = nY;
			oItem.width = m_nWidth;
			oItem.ItemIndex = m_arrListItems.length;
			oItem.addEventListener(ListEvent.ITEM_CLICKED, ListItem_onItemClicked);
			m_arrListItems.push(oItem);
			this.background.addChild(oItem);
			this.scrollbar.ContentHeight = nY + oItem.height;
			Redraw();
		}

		public function ListItem_onItemClicked(evt:ListEvent):void
		{
			if (m_oSelectedItem != evt.Item)
			{
				if (m_oSelectedItem != null)
				{
					m_oSelectedItem.Selected = false;
				}
				m_oSelectedItem = evt.Item;
				m_oSelectedItem.Selected = true;
			}
		}

		public function get Count():int
		{
			return m_arrListItems.length;
		}
	}
}