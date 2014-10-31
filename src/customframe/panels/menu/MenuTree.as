package customframe.panels.menu
{
	/**
	 * This is the logic for the MenuTree symbol in the library (/panels/menu/MenuTree.)
	 *
	 * The MenuTree is the root node of the Menu tree. It is basically a MenuBranchNode without the triangle icon
	 * (because it is always expanded.) It has no graphical elements and is invisible apart from the clild nodes it
	 * contains.
	 */
	public class MenuTree extends MenuParentNode
	{
		public function MenuTree()
		{
			super(null);
			m_nHeight = 0;
		}

		override protected function get LevelIndent():int
		{
			return 0;
		}

		override public function get height():Number
		{
			return 0;
		}
		
		public function get ExpandedHeight():Number
		{
			return m_nExpandedHeight;
		}

		override protected function CreateNode(xmlData:XML, nIndex:int):MenuNode
		{
			var oChildNode:MenuNode = super.CreateNode(xmlData, nIndex);
			this.addChild(oChildNode);
			return oChildNode
		}

		override protected function UpdateChildrenSizeAndPosition():void
		{
			var nOldHeight:int = m_nExpandedHeight;
			UpdateChildrenFromPosAndHeight(0, 0);

			if (nOldHeight != m_nExpandedHeight)
			{
				dispatchEvent(new MenuEvent(MenuEvent.ADJUST_LAYOUT));
			}
		}

		override public function set width(value:Number):void
		{
			if (value != m_nWidth)
			{
				m_nWidth = value;
				for each (var oNode:MenuNode in m_vecChildNodes)
				{
					oNode.width = value;
				}
				QueueRedraw();
			}
		}

		override protected function ChildNode_OnAdjustLayout(evt:MenuEvent):void
		{
			AdjustLayout();
			dispatchEvent(new MenuEvent(MenuEvent.ADJUST_LAYOUT));
		}
	}
}