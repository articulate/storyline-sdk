package customframe.panels.menu
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import com.articulate.wg.v2_0.*;

	import customframe.Frame;
	import customframe.components.list.List;
	import customframe.components.scrollbar.CustomScrollbar;
	import customframe.components.scrollbar.ScrollbarEvent;
	import customframe.managers.OptionManager;

	/**
	 * This is the logic for the Menu symbol in the library (/panels/menu/Menu.)
	 *
	 * The Menu is the outline tree in the sidebar. It controls the selection of the current slide for the
	 * Articulate player to display. It contains a MenuTree and a CustomScrollbar.
	 */
	public class Menu extends List
	{
		public static const RESTRICTED:String = "restricted";
		public static const NAV_RESTRICTED_MODE:String = "nav_restricted_mode";
		public static const LOCKED:String = "locked";
		public static const NAV_LOCKED_MODE:String = "nav_locked_mode";
		public static const MENU_OPTIONS:String = "menuoptions";
		public static const FLOW:String = "flow";
		public static const FREE:String = "free";

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
			m_oFrame.addEventListener(wgPlayerEvent.SLIDE_TRANSITION_IN, Frame_OnSlideTransitionIn);
			m_oFrame.addEventListener(wgPlayerEvent.RESUME_PLAYER, Frame_OnResumePlayer);
		}

		public function Update(xmlData:XML, oOptionManager:OptionManager):void
		{
			m_strFlow = oOptionManager.GetOptionAsString(MENU_OPTIONS, FLOW, m_strFlow);
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

		protected function GotoSlide(strSlideId:String, strWindowId:String):void
		{
			var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.GOTO_SLIDE);
			evtFrame.Id = strSlideId;
			evtFrame.WindowId = strWindowId;
			dispatchEvent(evtFrame);
		}

		override public function Redraw():void
		{
			super.Redraw()
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
				this.scrollbar.ContentHeight = this.tree.height + SCROLL_MARGIN;
				var nWidth:int = (this.scrollbar.ContentHeight > this.scrollbar.height) ?
								 this.scrollbar.x - this.tree.x - 1 : m_nWidth - MARGIN_TREE - this.tree.x - 1;
				this.tree.width = nWidth;
				this.tree.scrollRect = new Rectangle(0, this.scrollbar.Position, nWidth, this.scrollbar.height - 1);
			}
		}

		protected function Frame_OnResumePlayer(evt:wgPlayerEvent):void
		{
			this.tree.AdjustViewState();
		}

		protected function Frame_OnSlideTransitionIn(evt:MenuEvent):void
		{
			if (!this.tree.SelectSlideById(evt.Node.Id))
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
							var oSlide:wgISlide = GetSlideById(oNode.SlideId);
							if (oSlide != null)
							{
								bContinue = oSlide.Viewed;

								if (!bContinue)
								{
									m_oFrame.TriggerCustomEvent(NAV_RESTRICTED_MODE);
								}
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
							m_oSelectedNode.AutoCollapse();
							m_bIgnoreExpand = false;
						}

						m_oSelectedNode = oNode;
						m_oSelectedNode.Selected = true;

						if (evt.NotifyFrame)
						{
							GotoSlide(m_oSelectedNode.SlideId, m_oSelectedNode.WindowId);
						}
					}

					ScrollToSelectedNode();
				}
				else if (oNode is MenuBranchNode)
				{
					MenuBranchNode(oNode).ToggleExpanded();
				}
			}
		}

		protected function GetSlideById(strSlideId:String):wgISlide
		{
			var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.GET_SLIDE);
			evtFrame.Id = strSlideId;
			dispatchEvent(evtFrame);
			return evtFrame.ReturnData as wgISlide;
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
