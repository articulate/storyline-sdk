package customframe.panels.menu
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextFormat;

	import com.articulate.wg.v3_0.wgEventFrame;
	import com.articulate.wg.v3_0.wgISlide;
	import com.articulate.wg.v3_0.wgPlayerEvent;

	import customframe.components.list.ItemBase;
	import customframe.components.text.FormattedTextField;
	import customframe.managers.OptionManager;
	import customframe.Frame;

	/**
	 * MenuNode is the base class for the nodes in the menu tree.
	 *
	 */
	public class MenuNode extends ItemBase
	{
		public static const PLAYER_PREFIX:String = "_player.";
		public static const LEVEL_INDENT:int = 13;

		public static const MENU_OPTIONS:String = "menuoptions";
		public static const AUTO_NUMBER:String = "autonumber";
		public static const AUTO_COLLAPSE:String = "autocollapse";
		public static const WRAP_LIST_ITEMS:String = "wraplistitems";
		
		public static const LINK_ACTION:String = "action";
		public static const LINK_SLIDE:String = "slide";
		
		public static const STATUS_CORRECT:String = "correct";
		public static const STATUS_INCORRECT:String = "incorrect";
		public static const STATUS_INCOMPLETE:String = "incomplete";
		public static const STATUS_NONE:String = "none";

		public static const MARGIN_TEXT_LEFT:int = 12;
		public static const MARGIN_TOP:int = 2;
		public static const MARGIN_BOTTOM:int = 2;
		public static const MARGIN_SEPARATOR:int = 9;
		public static const TEXT_HEIGHT:int = 100;
		public static const TEXT_LEADING:int = 3;
		public static const TEXT_SIZE:int = 11;
		public static const DEFAULT_NODE_HEIGHT = 19.65;

		public var background:SimpleButton;
		public var textField:FormattedTextField;
		public var quizIcon:MovieClip;

		protected var m_nUpTextColor:uint = 0x000000;
		protected var m_nOverTextColor:uint = 0x000000;
		protected var m_nSelectedTextColor:uint = 0x000000;
		protected var m_nViewedTextColor:uint = 0x0000FF;

		protected var m_xmlData:XML = null;

		protected var m_nIndent:int = 0;
		protected var m_nIndex:int = 0;
		protected var m_strNumber:String = "";
		protected var m_strSlideId:String = "";
		protected var m_strWindowId:String = "";
		protected var m_strLinkType:String = LINK_SLIDE;
		protected var m_bHasChildren:Boolean = false;

		protected var m_bViewed:Boolean = false;
		protected var m_bListTypeDirty:Boolean = false;

		// Options
		protected var m_bAutoNumber:Boolean = false;
		protected var m_bAutoCollapse:Boolean = true;
		protected var m_bWrapListItems:Boolean = false;

		public function MenuNode(oOptionManager:OptionManager, strNumber:String = "")
		{
			super();
			m_nUpColor = 0xF3F3F3;
			m_bShowHover = true;
			m_bShowSelected = true;

			var nIndexStart:int = strNumber.lastIndexOf(".");
			if (nIndexStart != -1)
			{
				m_nIndex = parseInt(strNumber.substr(nIndexStart + 1)) - 1;
			}
			m_nIndent = LEVEL_INDENT * (strNumber.split(".").length - 1);

			m_oOptionManager = oOptionManager;
			UpdateOptions();
			this.mouseChildren = true;

			if (this.textField != null)
			{
				this.NumberString = strNumber + ".";
				this.textField.Leading = TEXT_LEADING;
				this.textField.Size = TEXT_SIZE;
				this.textField.Bold = false;
				this.textField.height = TEXT_HEIGHT;
				this.textField.mouseEnabled = false;
			}
			
			QueueRedraw();
		}

		public function get Index():int
		{
			return m_nIndex;
		}

		public function set XMLData(value:XML):void
		{
			m_xmlData = value;
			if (value != null)
			{
				m_strWindowId = m_xmlData.@windowid;
				m_strTitle = m_xmlData.@displaytext;
				m_strTitle = m_strTitle.replace(new RegExp(/\r/g), " ");
				m_strTitle = m_strTitle.replace(new RegExp(/\n/g), " ");
				m_strSlideId = m_xmlData.@slideid;
				m_strLinkType = m_xmlData.@type;
				m_bHasChildren = (m_xmlData.links.children().length() > 0);
				
				if (m_strSlideId.indexOf(PLAYER_PREFIX) == 0)
				{
					m_strSlideId = m_strSlideId.substr(8);
				}
				
				if (m_strLinkType != LINK_ACTION)
				{
					var oSlide:wgISlide = Frame.CustomFrame.GetSlide(m_strSlideId);
					if (oSlide != null && oSlide.HasInteractions) {
						oSlide.addEventListener(wgPlayerEvent.INTERACTION_EVALUATED, UpdateQuizIcon);
					}
				}
				
				QueueRedraw();
			}
		}

		public function set NumberString(value:String):void
		{
			m_strNumber = value;
			QueueRedraw();
		}

		public function get SlideId():String
		{
			return m_strSlideId;
		}

		public function get WindowId():String
		{
			return m_strWindowId;
		}
		
		public function get LinkType():String
		{
			return m_strLinkType;
		}
		
		protected function Collapse():void
		{
			dispatchEvent(new MenuEvent(MenuEvent.COLLAPSE_NODES));
		}

		override public function set Selected(value:Boolean):void
		{
			if (this.Selected != value)
			{
				super.Selected = value;

				if (!m_bViewed)
				{	
					m_bViewed = CheckViewed();
				}

				UpdateTextColor();

				if (m_bSelected)
				{
					dispatchEvent(new MenuEvent(MenuEvent.EXPAND_NODES));
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
		
		protected function GetActionLinkViewed(strActionLinkId:String):Boolean
		{
			var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.GET_ACTIONLINK_VIEWED);
			evtFrame.Id = strActionLinkId;
			dispatchEvent(evtFrame);
			return evtFrame.ReturnData as Boolean;			
		}
		
		public function CheckViewed():Boolean
		{
			var m_bViewed:Boolean;
			
			if (m_strLinkType == LINK_ACTION)
			{
				m_bViewed = GetActionLinkViewed(m_strSlideId);
			}
			else
			{
				var oSlide:wgISlide = GetSlideById(m_strSlideId);
				if (oSlide != null && oSlide.Viewed)
				{
					m_bViewed = true;
				}
			}
			
			return m_bViewed;
		}

		public function AutoCollapse():void
		{
			if (m_bAutoCollapse)
			{
				dispatchEvent(new MenuEvent(MenuEvent.COLLAPSE_NODES));
			}
		}

		public function SelectSlideById(strSlideId:String):Boolean
		{
			var bFoundSlide:Boolean = false;
			if (m_strSlideId == strSlideId)
			{
				bFoundSlide = true;
				if (!m_bSelected)
				{
					this.Selected = true;
					dispatchEvent(new MenuEvent(MenuEvent.NODE_SELECTED, this, false, true));
				}
			}
			return bFoundSlide;
		}

		public function get TitleHeight():Number
		{
			return m_nHeight;
		}
		
		public function DoNodeAction()
		{
			var evtFrame:wgEventFrame;
			
			if (LinkType != MenuNode.LINK_ACTION)
			{
				evtFrame = new wgEventFrame(wgEventFrame.GOTO_SLIDE);
				evtFrame.WindowId = WindowId;
			}
			else
			{
				evtFrame = new wgEventFrame(wgEventFrame.DO_ACTION_LINK);
			}
			
			evtFrame.Id = SlideId;
			dispatchEvent(evtFrame);
		}

		override public function get height():Number
		{
			return m_nHeight;
		}

		protected function NotifyClicked():void
		{
			dispatchEvent(new MenuEvent(MenuEvent.NODE_SELECTED, this, true, true));
		}

		override public function Redraw():void
		{
			if (m_nWidth > 0)
			{
				super.Redraw();
				this.background.width = m_nWidth;
				this.background.height = m_nHeight;
				UpdateTextField();
				UpdateTextColor();
			}
		}

		protected function UpdateTextField():void
		{
			if (this.textField != null)
			{
				if (m_bWrapListItems)
				{
					this.textField.Autosize = true;
					this.textField.Wrap = true;
					if (m_bAutoNumber)
					{
						this.textField.SetHangingIndent(m_strNumber);
						this.textField.Text = m_strNumber + "\t" + m_strTitle;
					}
				}
				else
				{
					this.textField.Truncate = true;
					this.textField.ClearHangingIndent();
					this.textField.Text = (m_bAutoNumber) ? m_strNumber + " " + m_strTitle : m_strTitle;
				}

				this.textField.x = m_nIndent + MARGIN_TEXT_LEFT;
				this.textField.width = m_nWidth - this.textField.x;

				UpdateHeight();
				this.textField.y = (int(m_nHeight - this.textField.TextHeight) / 2);
				if (!m_bWrapListItems)
				{
					this.textField.y -= 1;
				}
				this.textField.height = m_nHeight - this.textField.y;
			}
		}

		protected function UpdateTextColor():void
		{
			if (this.textField != null)
			{
				this.textField.Color = (m_bViewed) ? m_nViewedTextColor : m_nUpTextColor;
			}
		}

		override public function set width(value:Number):void
		{
			if (m_nWidth != value)
			{
				super.width = value;
				if (this.textField != null)
				{
					this.textField.width = m_nWidth - (this.x + MARGIN_TEXT_LEFT);
					//UpdateHeight();
				}
			}
		}

		protected function UpdateHeight():void
		{
			if (this.textField != null)
			{
				m_nHeight = this.textField.TextHeight + MARGIN_TOP + MARGIN_BOTTOM;
			}
			this.background.height = m_nHeight;
		}

		public function AdjustViewState():void
		{
			m_bViewed = CheckViewed();
			UpdateTextColor();
		}

		override protected function SetBackgroundColor(nColor:uint):void
		{
			if (this.background != null && m_nBackgroundColor != nColor)
			{
				m_nBackgroundColor = nColor;
				var oRGB:Object = GetRGBFromColorUint(nColor);
				this.background.transform.colorTransform = new ColorTransform(0, 0, 0, 1, oRGB.R, oRGB.G, oRGB.B, 0);
			}
		}

		public function UpdateListType():void
		{
			m_bListTypeDirty = true;
			UpdateOptions();
			QueueRedraw();
		}

		protected function UpdateOptions():void
		{
			if (m_oOptionManager != null)
			{
				m_bAutoNumber = m_oOptionManager.GetOptionAsBool(MENU_OPTIONS, AUTO_NUMBER, m_bAutoNumber);
				m_bAutoCollapse = m_oOptionManager.GetOptionAsBool(MENU_OPTIONS, AUTO_COLLAPSE, m_bAutoCollapse);
				m_bWrapListItems = m_oOptionManager.GetOptionAsBool(MENU_OPTIONS, WRAP_LIST_ITEMS, m_bWrapListItems);
			}
		}

		override protected function OnOptionsChanged(evt:Event):void
		{
			super.OnOptionsChanged(evt);
			UpdateListType();
		}

		override protected function OnMouseOver(evt:MouseEvent):void
		{
			if (this.background != null)
			{
				var ptMouse:Point = new Point(evt.stageX, evt.stageY);
				ptMouse = this.background.globalToLocal(ptMouse);
				if (ptMouse.x >= 0 && ptMouse.x <= this.background.width &&
					ptMouse.y >= 0 && ptMouse.y <= this.background.height)
				{
					super.OnMouseOver(evt);
					UpdateTextColor();
				}
				
				var oCurrentSlide:wgISlide = Frame.CustomFrame.GetCurrentSlide();
				if (oCurrentSlide.SlideLock)
				{
					Frame.CustomFrame.SetLockCursor(true);
				}
			}
		}

		override protected function OnMouseOut(evt:MouseEvent):void
		{
			if (m_bHover)
			{
				super.OnMouseOut(evt);
				
				var oCurrentSlide:wgISlide = Frame.CustomFrame.GetCurrentSlide();
				if (oCurrentSlide.SlideLock)
				{
					Frame.CustomFrame.SetLockCursor(false);
				}
			}
		}

		override protected function OnClick(evt:MouseEvent):void
		{
			var oCurrentSlide:wgISlide = Frame.CustomFrame.GetCurrentSlide();
			
			if (this.textField != null && !oCurrentSlide.SlideLock)
			{
				var ptMouse:Point = new Point(evt.stageX, evt.stageY);
				ptMouse = this.textField.globalToLocal(ptMouse);
				if (ptMouse.x >= 0 && ptMouse.x <= this.textField.width &&
					ptMouse.y >= 0 && ptMouse.y <= this.textField.height)
				{
					NotifyClicked();
				}
				AdjustViewState();
			}
			evt.stopPropagation();
		}
		
		protected function UpdateQuizIcon(e:wgPlayerEvent):void
		{	
			if (m_strLinkType != LINK_ACTION && !m_bHasChildren)
			{
				quizIcon.x = this.width - quizIcon.width - MARGIN_TEXT_LEFT;
				
				var oSlide:wgISlide = Frame.CustomFrame.GetSlide(m_strSlideId);
				
				if (oSlide != null && oSlide.ShowMenuResultIcon)
				{	
					if (oSlide.Status == STATUS_CORRECT)
					{
						quizIcon.gotoAndStop(STATUS_CORRECT);
					}
					else if (oSlide.Status == STATUS_INCORRECT || oSlide.Status == STATUS_INCOMPLETE)
					{	
						quizIcon.gotoAndStop(STATUS_INCORRECT);
					}
					else
					{
						quizIcon.gotoAndStop(STATUS_NONE);
					}
				}
			}
		}
	}
}