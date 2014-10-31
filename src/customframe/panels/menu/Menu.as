package customframe.panels.menu
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import com.articulate.wg.v3_0.*;

	import customframe.Frame;
	import customframe.components.list.List;
	import customframe.components.scrollbar.CustomScrollbar;
	import customframe.components.scrollbar.ScrollbarEvent;
	import customframe.managers.OptionManager;
	import customframe.panels.sidebar.Sidebar;

	/**
	 * This is the logic for the Menu symbol in the library (/panels/menu/Menu.)
	 *
	 * The Menu is the outline tree in the sidebar. It controls the selection of the current slide for the
	 * Articulate player to display. It contains a MenuTree and a CustomScrollbar.
	 *
	 */
	public class Menu extends List
	{
		public static const RESTRICTED:String = "restricted";
		public static const FREE:String = "free";
		public static const LOCKED:String = "locked";
		public static const NAV_RESTRICTED_MODE:String = "nav_restricted_mode";
		public static const NAV_LOCKED_MODE:String = "nav_locked_mode";
		
		private const SCROLL_MARGIN:int = 5;
		private const MARGIN_TREE:int = 3;

		public var tree:MenuTree;

		private var m_oFrame:Frame = null;
		private var m_oSelectedNode:MenuNode = null;
		private var m_strFlow:String = FREE;
		private var m_bIgnoreExpand:Boolean = false;

		public function Menu()
		{
			super();
			this.tree.addEventListener(MenuEvent.ADJUST_LAYOUT, Tree_OnAdjustLayout);
			this.tree.addEventListener(MenuEvent.NODE_SELECTED, Tree_OnNodeSelected);
			this.mouseChildren = true;
		}

		public function set CurrentSlide(value:wgISlide):void
		{
			this.tree.SelectSlideById(value.AbsoluteId);
		}

		public function get CustomFrame():Frame
		{
			return m_oFrame;
		}

		public function set CustomFrame(value:Frame):void
		{
			m_oFrame = value;
			m_oFrame.addEventListener(wgPlayerEvent.SLIDE_TRANSITION_IN, SlideChanged);
			m_oFrame.addEventListener(wgPlayerEvent.ACTIONLINK_SELECTED, SlideChanged);
			m_oFrame.addEventListener(wgPlayerEvent.RESUME_PLAYER, Frame_OnResumePlayer);
		}

		public function Update(xmlData:XML, oOptionManager:OptionManager):void
		{
			m_strFlow = oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_MENUOPTIONS, OptionManager.OPTION_FLOW, m_strFlow);
			MenuTree(this.tree).OptionManager = oOptionManager;
			SetTreeXMLData(xmlData);
		}

		protected function SetTreeXMLData(xmlData:XML):void
		{
			MenuTree(this.tree).XMLData = xmlData;
			Redraw();
			var oCurrentSlide:wgISlide = GetCurrentSlide();
			if (oCurrentSlide != null)
			{
				this.tree.SelectSlideById(oCurrentSlide.AbsoluteId);
			}
		}

		protected function GetCurrentSlide():wgISlide
		{
			var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.GET_CURRENT_SLIDE);
			dispatchEvent(evtFrame);
			return evtFrame.ReturnData as wgISlide;
		}

		override public function Redraw():void
		{
			super.Redraw();
			UpdateChildren();
		}

		public function Refresh(nTabHeight:Number, nMainHeight:Number):void
		{
			this.width = this.parent.width;
			this.height = nMainHeight;
			this.y = nTabHeight;
		}
		
		protected function UpdateChildren():void
		{
			if (!m_bIgnoreExpand)
			{
				this.scrollbar.x = m_nWidth - this.scrollbar.width;
				this.scrollbar.y = 0;
				this.scrollbar.height = m_nHeight;
				this.scrollbar.ContentHeight = this.tree.ExpandedHeight + SCROLL_MARGIN;
				var nWidth:int = 0;
				if (this.scrollbar.ContentHeight > m_nHeight)
				{
					nWidth = this.scrollbar.x - this.tree.x - 1;
					this.scrollbar.visible = true;
				}
				else
				{
					nWidth = m_nWidth - MARGIN_TREE - this.tree.x - 1;
					this.scrollbar.visible = false;
				}
				
				this.tree.width = nWidth;
				this.tree.scrollRect = new Rectangle(0, this.scrollbar.Position, nWidth, this.scrollbar.height - SCROLL_MARGIN);
			}
		}

		protected function Frame_OnResumePlayer(evt:wgPlayerEvent):void
		{
			this.tree.AdjustViewState();
		}

		protected function SlideChanged(evt:wgPlayerEvent):void
		{
			var strId:String;
			
			if (evt.type == wgPlayerEvent.ACTIONLINK_SELECTED)
			{
				strId = evt.Data;
			}
			else
			{
				strId = evt.Slide.AbsoluteId;
			}
			
			if (!this.tree.SelectSlideById(strId))
			{
				if (m_oSelectedNode != null)
				{
					m_oSelectedNode.Selected = false;
					m_oSelectedNode = null;
				}
			}
		}

		override protected function Scrollbar_onScrolling(evt:ScrollbarEvent):void
		{
			UpdateChildren();
		}

		protected function Tree_OnAdjustLayout(evt:MenuEvent):void
		{
			UpdateChildren();
		}

		protected function Tree_OnNodeSelected(evt:MenuEvent):void
		{
			var oNode:MenuNode = evt.Node;

			if (m_oSelectedNode != oNode)
			{
				if (oNode.SlideId != "")
				{
					var bContinue:Boolean = true;

					if (evt.NotifyFrame)
					{
						if (m_strFlow == RESTRICTED)
						{
							bContinue = oNode.CheckViewed();
							
							if (!bContinue)
							{
								m_oFrame.TriggerCustomEvent(NAV_RESTRICTED_MODE);
							}
						}

						if (m_strFlow == LOCKED)
						{
							bContinue = false;
							m_oFrame.TriggerCustomEvent(NAV_LOCKED_MODE);
						}
					}

					if (bContinue)
					{
						if (m_oSelectedNode != null)
						{
							m_bIgnoreExpand = true;
							m_oSelectedNode.Selected = false;
							m_bIgnoreExpand = false;
						}

						m_oSelectedNode = oNode;
						m_oSelectedNode.Selected = true;

						if (evt.NotifyFrame)
						{
							oNode.DoNodeAction();
						}
					}

					ScrollToSelectedNode();
					
					if (this.parent.parent is MenuPopup)
					{
						MenuPopup(this.parent.parent).HidePanel();
					}
				}
				else if (oNode is MenuBranchNode)
				{
					MenuBranchNode(oNode).ToggleExpanded();
				}
			}
		}

		protected function ScrollToSelectedNode():void
		{
			if (m_oSelectedNode != null)
			{
				var ptPos:Point = new Point(m_oSelectedNode.x, m_oSelectedNode.y);
				ptPos = m_oSelectedNode.parent.localToGlobal(ptPos);
				ptPos = this.tree.globalToLocal(ptPos);
				this.scrollbar.AutoScroll(ptPos.y, m_oSelectedNode.TitleHeight);
				UpdateChildren();
			}
		}
	}
}
