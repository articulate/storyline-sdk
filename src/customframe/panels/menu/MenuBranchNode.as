package customframe.panels.menu
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

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
		private const BEHAVIOR_INSIDE:String = "inside";
		private const BEHAVIOR_REACHED:String = "reached";
		private const BEHAVIOR_MANUAL:String = "manual";
		
		private const RESTRICTION_INSIDE:String = "inside";
		private const RESTRICTION_REACHED:String = "reached";
		private const RESTRICTION_UNRESTRICTED:String = "unrestricted";
		
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
			this.addEventListener(MenuEvent.EXPAND_NODES, ChildNode_OnExpandNodes);
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
			
			var strRestrictions:String = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_MENUOPTIONS, OptionManager.OPTION_RESTRICTIONS);
			
			if (strRestrictions == "")
			{
				strRestrictions = RESTRICTION_UNRESTRICTED;
			}
			
			if (strRestrictions != RESTRICTION_UNRESTRICTED)
			{
				HideIcon();
			}
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

		protected function Expand():void
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
			if (m_strSlideId != "")
			{
				bSelected = super.Selected
			}
			else
			{
				for each (var oChild:MenuNode in m_vecChildNodes)
				{
					if (oChild.Selected)
					{
						bSelected = true;
						break;
					}
				}
			}
			return bSelected;
		}

		override public function set Selected(value:Boolean):void
		{
			if (m_strSlideId != "")
			{
				super.Selected = value;
			}
			else if (m_vecChildNodes.length > 0)
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
		
		public function CheckExpanded():void
		{
			if (!Expanded)
			{
				Expand();
			}
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
			if (this.iconHitArea.visible)
			{
				this.closedIcon.visible = !m_bExpanded;
				this.openIcon.visible = m_bExpanded;
			}
		}
		
		protected function HideIcon():void
		{
			this.iconHitArea.visible = false;
			this.closedIcon.visible = false;
			this.openIcon.visible = false;
		}
		
		protected function ShowIcon():void
		{
			this.iconHitArea.visible = true;
			UpdateIcon();
		}

		protected function ChildNode_OnExpandNodes(evt:MenuEvent):void
		{
			var strBehavior = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_MENUOPTIONS, OptionManager.OPTION_BEHAVIOR);
			var strRestrictions = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_MENUOPTIONS, OptionManager.OPTION_RESTRICTIONS);
			
			// check and possibly set behavior and restrictions
			if (strBehavior == "")
			{
				strBehavior = BEHAVIOR_INSIDE;
			}
			
			if (strRestrictions == "")
			{
				strRestrictions = RESTRICTION_UNRESTRICTED;
			}
			
			if (strBehavior == BEHAVIOR_REACHED && strRestrictions == RESTRICTION_INSIDE)
			{
				strBehavior = BEHAVIOR_INSIDE;
			}
			
			// handle icon
			if ((strRestrictions == RESTRICTION_REACHED && evt.target.SlideId == this.SlideId) || (strRestrictions == RESTRICTION_INSIDE && evt.target.SlideId != this.SlideId))
			{
				ShowIcon();
			}
			
			// handle auto expand 
			if (!m_bExpanded && strBehavior != BEHAVIOR_MANUAL)
			{
				if ((strBehavior == BEHAVIOR_REACHED && evt.target.SlideId == this.SlideId) || (strBehavior != BEHAVIOR_MANUAL && evt.target.SlideId != this.SlideId))
				{
					CheckExpanded();
				}
			}
		}

		protected function ChildNode_OnCollapseNodes(evt:MenuEvent):void
		{
			if (!this.Selected)
			{
				Collapse();
			}
		}
		
		override protected function UpdateTextField():void
		{
			var startIndentPos:Number = textField.x;
			
			super.UpdateTextField();
			
			startIndentPos = textField.x - startIndentPos
			
			this.openIcon.x += startIndentPos;
			this.closedIcon.x += startIndentPos;
			this.iconHitArea.x += startIndentPos;
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