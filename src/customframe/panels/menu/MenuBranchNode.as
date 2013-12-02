package customframe.panels.menu
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import customframe.components.text.FormattedTextField;
	import customframe.managers.OptionManager;

	/**
	 * This is the logic for the MenuBranchNode symbol in the library (/panels/menu/MenuBranchNode.)
	 *
	 * A MenuBranchNode contains child nodes. It has a triangular icon that can be clicked to collapse the
	 * node and hide its children or expand the node and show its children.
	 *
	 */
	public class MenuBranchNode extends MenuParentNode
	{
		public var closedIcon:Sprite;
		public var openIcon:Sprite;
		public var iconHitArea:Sprite;

		protected var m_bExpanded:Boolean = false;

		public function MenuBranchNode(oOptionManager:OptionManager, strNumber:String = "", bExpanded:Boolean = false)
		{
			super(oOptionManager, strNumber);
			m_bExpanded = bExpanded;
			this.closedIcon.mouseEnabled = false;
			this.openIcon.mouseEnabled = false;
			UpdateIcon();
		}

		override public function Redraw():void
		{
			super.Redraw();

			if (m_nWidth > 0)
			{
				UpdateIcon();
			}
		}

		override public function set XMLData(value:XML):void
		{
			super.XMLData = value;

			if (value != null)
			{
				this.iconHitArea.mouseEnabled = true;
				this.iconHitArea.buttonMode = true;
				this.iconHitArea.addEventListener(MouseEvent.MOUSE_OVER, Icon_OnMouseOver);
				this.iconHitArea.addEventListener(MouseEvent.MOUSE_OUT, Icon_OnMouseOut);
				this.iconHitArea.addEventListener(MouseEvent.MOUSE_DOWN, Icon_OnClicked);
			}
		}

		override protected function get UnexpandedHeight():Number
		{
			return this.textField.y + this.textField.TextHeight + MARGIN_BOTTOM;
		}

		override public function set width(value:Number):void
		{
			if (m_nWidth != value)
			{
				super.width = value;

				for each (var oNode:MenuNode in m_vecChildNodes)
				{
					oNode.width = value;
				}
			}
		}

		override protected function Expand():void
		{
			m_bExpanded = true;

			for each (var oChild:MenuNode in m_vecChildNodes)
			{
				addChild(oChild);
			}

			dispatchEvent(new MenuEvent(MenuEvent.ADJUST_LAYOUT, this));
			QueueRedraw();
		}

		public function ToggleExpanded():void
		{
			(m_bExpanded) ? Collapse() : Expand();
		}

		override protected function Collapse():void
		{
			m_bExpanded = false;

			for each (var oChild:MenuNode in m_vecChildNodes)
			{
				removeChild(oChild);
			}
			dispatchEvent(new MenuEvent(MenuEvent.ADJUST_LAYOUT, this))
			QueueRedraw();
		}

		override public function get Selected():Boolean
		{
			var bSelected:Boolean = false;

			for each (var oChild:MenuNode in m_vecChildNodes)
			{
				if (oChild.Selected)
				{
					bSelected = true;
					break;
				}
			}
			return bSelected;
		}

		override public function set Selected(value:Boolean):void
		{
			if (m_vecChildNodes.length > 0)
			{
				m_vecChildNodes[0].Selected = value;
			}
		}

		override protected function CreateNode(xmlData:XML, nIndex:int):MenuNode
		{
			var oChildNode:MenuNode = super.CreateNode(xmlData, nIndex);
			oChildNode.addEventListener(MenuEvent.COLLAPSE_NODES, ChildNode_OnCollapseNodes);
			oChildNode.addEventListener(MenuEvent.EXPAND_NODES, ChildNode_OnExpandNodes);
			oChildNode.addEventListener(MouseEvent.MOUSE_OVER, ChildNode_OnMouseOver);

			if (m_bExpanded)
			{
				addChild(oChildNode);
			}

			return oChildNode
		}

		public function get Expanded():Boolean
		{
			return m_bExpanded;
		}

		override public function get height():Number
		{
			return (m_bExpanded) ? m_nExpandedHeight : super.height;
		}

		protected function UpdateIcon():void
		{
			this.closedIcon.visible = !m_bExpanded;
			this.openIcon.visible = m_bExpanded;
		}

		protected function ChildNode_OnExpandNodes(evt:MenuEvent):void
		{
			Expand();
		}

		protected function ChildNode_OnCollapseNodes(evt:MenuEvent):void
		{
			if (!this.Selected)
			{
				Collapse();
			}
		}

		protected function ChildNode_OnMouseOver(evt:MouseEvent):void
		{
			super.OnMouseOut(evt);
		}

		override protected function OnMouseOver(evt:MouseEvent):void
		{
			var bOverChild:Boolean = false;

			for each (var oChild:MenuNode in m_vecChildNodes)
			{
				if (oChild.ItemHover)
				{
					bOverChild = true;
					break;
				}
			}

			if (!bOverChild && this.background != null)
			{
				var ptMouse:Point = new Point(evt.stageX, evt.stageY);
				ptMouse = this.background.globalToLocal(ptMouse);

				if (ptMouse.x >= 0 && ptMouse.x <= this.background.width &&
					ptMouse.y >= 0 && ptMouse.y <= this.background.height)
				{
					super.OnMouseOver(evt);
					UpdateTextColor();
				}
			}
		}

		override protected function OnMouseOut(evt:MouseEvent):void
		{
			if (m_bHover)
			{
				super.OnMouseOut(evt);
			}
		}

		protected function Icon_OnMouseOver(evt:MouseEvent):void
		{
			super.OnMouseOut(evt);
		}

		protected function Icon_OnMouseOut(evt:MouseEvent):void
		{
			super.OnMouseOver(evt);
		}

		protected function Icon_OnClicked(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			ToggleExpanded();
		}
	}
}