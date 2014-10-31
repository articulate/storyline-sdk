package customframe
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	import com.articulate.wg.v3_0.*;
	
	import customframe.base.CustomSprite;
	import customframe.components.buttons.ControlButtons;
	import customframe.components.buttons.VolumeButton;
	import customframe.panels.logo.Logo;
	import customframe.panels.info.InfoPanel;
	import customframe.panels.menu.MenuPopup;
	import customframe.components.seekbar.Seekbar;
	import customframe.components.timer.CustomTimer;
	import customframe.managers.ControlManager;
	import customframe.managers.OptionManager;
	import customframe.panels.resources.Resources;
	import customframe.panels.sidebar.Sidebar;
	import customframe.windows.Background;
	import customframe.windows.SlideContainer;
	import customframe.windows.lightbox.Lightbox;
	import customframe.windows.prompt.PromptWindow;
	import customframe.managers.OptionList;
	import customframe.managers.OptionListItem;

	/**
	 * This is the logic for the Frame symbol in the library (/Frame.)
	 *
	 * The Frame contains all the visual elements that make up the custom frame. It implements the wgIFrame interface
	 * and thus can be used as a frame for the Articulate player.
	 */
	public class Frame extends CustomSprite implements wgIFrame
	{
		public static const DEFAULT_WIDTH:int = 980;
		public static const DEFAULT_HEIGHT:int = 658;
		
		public static const CONTROL_OUTLINE:String = "outline";
		public static const CONTROL_RESOURCES:String = "resources";
		public static const CONTROL_GLOSSARY:String = "glossary";
		public static const CONTROL_TRANSCRIPT:String = "transcript";
		public static const CONTROL_QUESTIONLIST:String = "question_list";
		
		public static const CUSTOM_EVT_FIRST_SLIDE_TRIGGERED:String = "first_slide_triggered";
		public static const CUSTOM_EVT_LAST_SLIDE_TRIGGERED:String = "last_slide_triggered";

		public static const OUTLINE:String = "outline";
		public static const RESOURCES:String = "resources";
		public static const GLOSSARY:String = "glossary";
		public static const TRANSCRIPT:String = "transcript";
		public static const VOLUME:String = "volume";
		public static const SUBMIT:String = "submit";
		public static const SUBMITALL:String = "submitall";
		public static const FINISH:String = "finish";
		
		public static const NEXT:String = "next";
		public static const PREVIOUS:String = "previous";
		public static const SEEKBAR:String = "seekbar";
		public static const REPLAY:String = "replay";
		public static const PAUSE_PLAY:String = "pauseplay";
		public static const STORY_WINDOW:String = "StoryWindow";
		public static const STORY_POPUP:String = "StoryPopup";
		public static const STORY_POPUP_CONTROLS:String = "StoryPopupControls";
		public static const WIDTH:String = "width";
		public static const HEIGHT:String = "height"
		
		public static const ELAPSEDTIME_MODE_NORMAL:String = "normal";
		public static const ELAPSEDTIME_MODE_PAUSED:String = "pause";
		public static const ELAPSEDTIME_MODE_IGNORE:String = "ignore";
		
		public static const PRESENTER_NONE:String = "none";
		public static const PRESENTER_DEFAULT:String = "default";
		
		public static const OUTPUT_TYPE_QM:String = "qm";

		private const MARGIN_LEFT:int = 10;
		private const MARGIN_RIGHT:int = 10;
		private const MARGIN_LOGO_TOP:int = 10;
		private const MARGIN_BUTTON_BOTTOM:int = 15;

		public static var CustomFrame:Frame = null;

		public var timer:CustomTimer;
		public var slideContainer:SlideContainer
		public var titleField:TextField;
		public var elapsedTimeField:TextField;
		public var sidebar:Sidebar
		public var volumeButton:VolumeButton
		public var controlButtons:ControlButtons
		public var seekbar:Seekbar
		public var logo:Logo
		public var infopanel:InfoPanel;
		public var background:Background;
		public var resourcesPopup:Resources;
		public var menuPopup:MenuPopup;

		protected var m_strCurrentSlideId:String = "";
		protected var m_bPlaying:Boolean = false;
		protected var m_oPlayer:wgIPlayer = null;
		protected var m_oCurrentSlide:wgISlide = null;
		protected var m_oTimeline:wgITimeline = null;
		protected var m_xmlData:XML = null;
		protected var m_loadData:URLLoader = null;
		protected var m_strFilename:String = "";
		protected var m_strRemotePath:String = "";
		protected var m_strDefaultLayout:String = "";
		protected var m_bShowSidebar:Boolean = false;
		protected var m_bShowBottomBar:Boolean = false;
		protected var m_bShowMenu:Boolean = false;
		protected var m_bShowLogo:Boolean = false;
		protected var m_bShowInfo:Boolean = false;
		protected var m_spInfoVideo:Sprite = null;
		protected var m_strDefaultPresenterId:String = "";
		protected var m_oKeyboadShortcuts:KeyboardShortcuts = null;
		protected var m_bMuted:Boolean = false;
		protected var m_nVolume:int = 80;

		public function Frame()
		{
			CustomFrame = this;
			this.ControlManager = new ControlManager();
			this.OptionManager = new OptionManager();
			this.volumeButton.addEventListener(wgEventFrame.VOLUME_CHANGED, VolumeButton_onVolumeChanged);
			addEventListener(wgPlayerEvent.SLIDE_TRANSITION_IN, OnSlideChanged);
			addEventListener(Event.ADDED_TO_STAGE, HandleAddToStage);
			this.sidebar.CustomFrame = this;
			m_oKeyboadShortcuts = new KeyboardShortcuts(this);
		}
			
		public function AddTimer(oTimer:wgITimer):void
		{
			this.timer.AddTimer(oTimer);
			this.timer.visible = true;
			this.timer.TimeFormat = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_TIME_FORMAT);
		}

		public function RemoveTimer(oTimer:wgITimer):void
		{
			this.timer.RemoveTimer(oTimer);
			if (this.timer.TimerCount == 0)
			{
				this.timer.visible = false;
			}
		}

		public function get ShadeAlpha():Number
		{
			return 0;
		}

		public function get SlideScale():Number
		{
			return 1;
		}

		public function get ScaleToFit():Boolean
		{
			return true;
		}
		
		public function get Timeline():wgITimeline
		{
			return m_oTimeline;
		}
		
		public function GetSlide(strSlideId:String):wgISlide
		{
			var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.GET_SLIDE);
			evtFrame.Id = strSlideId;

			dispatchEvent(evtFrame);

			return evtFrame.ReturnData as wgISlide;
		}

		public function GetSlideContainer():Sprite
		{
			return this.slideContainer;
		}

		public function GetSlideRect():Rectangle
		{
			return new Rectangle(this.slideContainer.x, this.slideContainer.y, this.slideContainer.width, this.slideContainer.height);
		}

		// Returns true when the frame is ready
		public function get IsFrameReady():Boolean
		{
			return (m_xmlData != null);
		}

		public function GetDisplayObject():DisplayObject
		{
			return this;
		}

		public function GetWindow(strWindowName:String):wgIWindow
		{
			var oWindow:wgIWindow = null;

			switch (strWindowName)
			{
				case STORY_WINDOW:
				{
					oWindow = new PromptWindow(this);
					break;
				}
				case STORY_POPUP:
				{
					oWindow = new Lightbox(m_oControlManager, false);
					break;
				}
				case STORY_POPUP_CONTROLS:
				{
					oWindow = new Lightbox(m_oControlManager, true);
					break;
				}
			}

			return oWindow;
		}

		public function SetTitle(strTitle:String):void
		{
			this.titleField.text = strTitle;
			
			if (elapsedTimeField.visible){
				this.elapsedTimeField.x = this.titleField.x + this.titleField.textWidth + 10;
			}
		}
		
		private function HandleAddToStage(e:Event)
		{
			m_oKeyboadShortcuts.SetStage(this.stage);
		}
		
		private function UpdateElapsedTime(e:Event = null):void 
		{
			var strCurrentTime:String;
			
			if (m_oTimeline.StartTime == -1)
			{
				strCurrentTime = "00:00";
			}
			else if (m_oTimeline.ElapsedTimeMode == ELAPSEDTIME_MODE_PAUSED) 
			{
				strCurrentTime = Utils.GetTimeString(m_oTimeline.StartTime);
			}
			else if (m_oTimeline.ElapsedTimeMode == ELAPSEDTIME_MODE_NORMAL)
			{
				strCurrentTime =  Utils.GetTimeString(m_oTimeline.StartTime + m_oTimeline.PlayHeadTime);
			}
			
			var strElapsedTime:String = "(" + strCurrentTime + " / " + Utils.GetTimeString(m_oPlayer.LessonDuration) + ")";
			
			if (elapsedTimeField.text != strElapsedTime && elapsedTimeField.visible)
			{
				elapsedTimeField.text = strElapsedTime;
			}
		}
		
		private function UpdateTimelineStatus(e:Event):void
		{	
			if (m_oTimeline.TimelinePlaying && m_oTimeline.ElapsedTimeMode != ELAPSEDTIME_MODE_IGNORE)
			{
				addEventListener(Event.ENTER_FRAME, UpdateElapsedTime);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, UpdateElapsedTime);
				if (m_oTimeline.ElapsedTimeMode != ELAPSEDTIME_MODE_IGNORE)
				{
					UpdateElapsedTime();
				}
			}
		}
		
		public function SetDataFilename(strFilename:String, strRemotePath:String):void
		{
			m_strFilename = strFilename;
			m_strRemotePath = strRemotePath;
			var reqXMLData:URLRequest = new URLRequest(m_strRemotePath + strFilename);
			m_loadData = new URLLoader();
			m_loadData.addEventListener(IOErrorEvent.IO_ERROR, LoadErrorHandler);
			m_loadData.addEventListener(Event.COMPLETE, LoadCompleteHandler);
			m_loadData.load(reqXMLData);
		}

		public function SetLayout(strLayout:String):void
		{
			var xmlLayouts:XML = m_xmlData.layouts[0];
			var xmlLayout:XML = xmlLayouts.layout.(@name == strLayout)[0];

			if (xmlLayout)
			{
				m_oControlManager.SetControlLayout(xmlLayout.@controllayout);
			}

			m_bControlsDirty = true;
			QueueRedraw();
		}

		public function UpdateGlossary(xmlData:XML):void
		{
			this.sidebar.UpdateGlossary(xmlData);
		}

		public function UpdateResourceText(strText:String):void
		{
			m_xmlData.resource_data.@description = strText;
		}

		public function UpdateResources(strXMLData:String):void
		{
			m_xmlData.resource_data.resources = new XML(strXMLData);
		}

		public function UpdateTOC(xmlData:XML):void
		{
			this.sidebar.UpdateMenu(xmlData, m_oOptionManager);
			this.menuPopup.UpdateMenu(xmlData, m_oOptionManager);
		}

		override public function Redraw():void
		{
			if (m_bControlsDirty)
			{
				UpdateControls();
			}
			super.Redraw();
		}

		public function UpdateControls():void
		{
			// Bottom bar
			var bShowBottomBar:Boolean = m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_BOTTOMBAR, OptionManager.OPTION_BOTTOMBAR_ENABLED, true);
				
			// Volume button - m_spVolume
			this.volumeButton.visible = (m_oControlManager.IsControlEnabled(VOLUME) && bShowBottomBar);
			this.volumeButton.y = this.height - (this.volumeButton.backgroundUp.height + MARGIN_BUTTON_BOTTOM);
			
			// Control buttons
			this.controlButtons.ShowSubmit = (m_oControlManager.IsControlEnabled(SUBMIT) && bShowBottomBar);
			this.controlButtons.ShowSubmitAll = (m_oControlManager.IsControlEnabled(SUBMITALL) && bShowBottomBar);
			this.controlButtons.ShowFinish = (m_oControlManager.IsControlEnabled(FINISH) && bShowBottomBar);
			this.controlButtons.ShowNext = (m_oControlManager.IsControlEnabled(NEXT) && bShowBottomBar);
			this.controlButtons.ShowPrevious = (m_oControlManager.IsControlEnabled(PREVIOUS) && bShowBottomBar);
			this.controlButtons.x = this.width - MARGIN_RIGHT - this.controlButtons.width;
			this.controlButtons.y = this.height - (this.controlButtons.height + MARGIN_BUTTON_BOTTOM);
			
			// Sidebar
			var bShowLogo:Boolean = m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_LOGO_ENABLED) && m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_SIDEBAR_ENABLED);
			var bShowElapsedTime:Boolean = m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_CONTROLS, OptionManager.OPTION_CONTROLS_ELAPSEDANDTOTALTIME);
			
			if (bShowLogo)
			{
				this.logo.visible = true;
				this.logo.FileName = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_LOGO_URL);
				this.logo.ImageWidth =  parseInt(m_oOptionManager.GetOptionProperty(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_LOGO_URL, WIDTH));
				this.logo.ImageHeight =  parseInt(m_oOptionManager.GetOptionProperty(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_LOGO_URL, HEIGHT));
				this.logo.Load();
				this.logo.height = this.logo.ImageHeight + 16;
				this.sidebar.y = this.logo.y + this.logo.height + 8;
				logo.DisplayFlatSide = m_bShowInfo;
			}
			else
			{
				this.logo.visible = false;
				this.sidebar.y = 8;
			}
			
			if (m_bShowInfo)
			{
				this.infopanel.visible = true;
				this.infopanel.y = this.sidebar.y;
				this.sidebar.y = this.infopanel.y + this.infopanel.height + 8;
				infopanel.DisplayFlatSide = bShowLogo;
			}
			else
			{
				this.infopanel.visible = false;
			}
			
			this.sidebar.height = this.height - this.sidebar.y - 12;
			
			if (bShowElapsedTime) {
				this.elapsedTimeField.visible = true;
				
				if (m_oTimeline.ElapsedTimeMode != ELAPSEDTIME_MODE_IGNORE)
				{
					UpdateElapsedTime();
				}
				m_oTimeline.addEventListener(wgEventTimeline.UPDATE_TIMELINE, UpdateTimelineStatus);
				m_oTimeline.addEventListener(wgEventTimeline.TIMELINE_CHANGED, UpdateTimelineStatus);
			}
			else
			{
				this.elapsedTimeField.visible = false;
			}

			var oSidebarList:OptionList = m_oOptionManager.GetOptionList(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTLIST_TABS);
			var oOutlineOptions:OptionListItem = oSidebarList.GetListItemByName(CONTROL_OUTLINE);
			var bShowNotes:Boolean = (m_oControlManager.IsControlEnabled(TRANSCRIPT));
			var bShowGlossary:Boolean = (m_oControlManager.IsControlEnabled(GLOSSARY));
			var bShowResources:Boolean = m_oControlManager.IsControlEnabled(RESOURCES);
			var bShowMenu:Boolean = (m_oControlManager.IsControlEnabled(OUTLINE) && m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_SIDEBAR_ENABLED));
			var bShowMenuPopup:Boolean = (m_oControlManager.IsControlEnabled(OUTLINE) && (oOutlineOptions.Group == OptionManager.LISTGROUP_LINKLEFT || oOutlineOptions.Group == OptionManager.LISTGROUP_LINKRIGHT));
			var bShowSidebar:Boolean = m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_SIDEBAR_ENABLED) && (bShowNotes || bShowGlossary || bShowLogo || (bShowMenu && oOutlineOptions.Group == OptionManager.LISTGROUP_SIDEBAR));
			
			var leftPosition:int;
			
			if (bShowSidebar)
			{
				this.sidebar.visible = true;
				this.background.SidebarBackgroundVisible = true;
				this.slideContainer.x = this.background.SidebarBackgroundWidth + (this.width - this.background.SidebarBackgroundWidth - this.slideContainer.width) * 0.5;
				this.titleField.x = this.slideContainer.x;

				(bShowNotes) ? this.sidebar.ShowNotes() : this.sidebar.HideNotes();
				(bShowGlossary) ? this.sidebar.ShowGlossary() : this.sidebar.HideGlossary();
				(bShowMenu) ? this.sidebar.ShowMenu() : this.sidebar.HideMenu();
				leftPosition = this.sidebar.x + this.sidebar.width + (MARGIN_LEFT * 2);
			}
			else
			{
				this.sidebar.visible = false;
				this.background.SidebarBackgroundVisible = false;
				this.slideContainer.x = (this.width - this.slideContainer.width) * 0.5;
				this.titleField.x = MARGIN_LEFT;
				leftPosition = MARGIN_LEFT;
			}
			
			if (this.controlButtons.submitAllButton.visible)
			{
				this.controlButtons.submitAllButton.x = leftPosition - this.controlButtons.x;
				leftPosition = leftPosition + this.controlButtons.submitAllButton.width + MARGIN_LEFT;
			}
			
			if (this.volumeButton.visible)
			{
				this.volumeButton.x = leftPosition;
				leftPosition = this.volumeButton.x + this.volumeButton.width + MARGIN_LEFT;
			}
			
			// Seekbar
			this.seekbar.x = leftPosition;
			this.seekbar.width = this.controlButtons.x - this.seekbar.x;
			this.seekbar.visible = (m_oControlManager.IsControlEnabled(SEEKBAR) && bShowBottomBar);
			this.seekbar.ReplayButtonEnabled = (m_oControlManager.IsControlEnabled(REPLAY) && bShowBottomBar);
			this.seekbar.PlayPauseButtonEnabled = (m_oControlManager.IsControlEnabled(PAUSE_PLAY) && bShowBottomBar);
			this.seekbar.y = this.height - (this.seekbar.height + MARGIN_BUTTON_BOTTOM);
			
			if (bShowResources)
			{
				this.resourcesPopup.x = this.width - MARGIN_RIGHT - this.resourcesPopup.width
				this.resourcesPopup.visible = true;
			}
			else
			{
				this.resourcesPopup.visible = false;
			}
			
			if (bShowMenuPopup)
			{
				this.menuPopup.visible = true;
				this.titleField.y = 8;
				this.titleField.x = MARGIN_LEFT + 3;
				this.elapsedTimeField.y = 11;
				if (m_xmlData.@outputtype == OUTPUT_TYPE_QM)
				{
					this.menuPopup.UpdateLabel(MenuPopup.LABEL_QUESTION_LIST);
				}
				else
				{
					this.menuPopup.UpdateLabel(MenuPopup.LABEL_MENU);
				}
			}
			else
			{
				this.menuPopup.visible = false;
			}
			
			var nTitleBottom:Number = 0;
			var nVisibleBottom:Number = (bShowBottomBar) ? this.seekbar.y : this.height;
			
			if (m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_TITLE_ENABLED))
			{
				nTitleBottom = this.titleField.y + this.titleField.textHeight;
				
				var strProjectTitle:String = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_TITLE_TEXT);
				
				if (strProjectTitle != null)
				{
					SetTitle(strProjectTitle);
				}
			}
			else
			{
				this.titleField.visible = false;
			}
			
			this.slideContainer.y = nTitleBottom + (nVisibleBottom - nTitleBottom - this.slideContainer.height) * 0.5;
		}
		
		public function GotoFirstSlide():void
		{
			var oSlide:wgISlide = GetCurrentSlide();
			
			if (oSlide != null && !oSlide.SlideLock)
			{
				var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.TRIGGER_CUSTOM_EVENT);
				evtFrame.Id = CUSTOM_EVT_FIRST_SLIDE_TRIGGERED;

				dispatchEvent(evtFrame);
			}
		}
		
		public function GotoLastSlide():void
		{
			var oSlide:wgISlide = GetCurrentSlide();
			
			if (oSlide != null && !oSlide.SlideLock)
			{
				var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.TRIGGER_CUSTOM_EVENT);
				evtFrame.Id = CUSTOM_EVT_LAST_SLIDE_TRIGGERED;
				
				dispatchEvent(evtFrame);
			}
				
		}

		public function TriggerCustomEvent(strId:String):void
		{
			var evt:wgEventFrame = new wgEventFrame(wgEventFrame.TRIGGER_CUSTOM_EVENT);
			evt.Id = strId;
			dispatchEvent(evt);
		}

		protected function ParseXMLData():void
		{
			var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.GET_PLAYER);
			dispatchEvent(evtFrame);
			m_oPlayer = evtFrame.ReturnData as wgIPlayer;
			m_strDefaultLayout = m_xmlData.@default_layout;
			m_oControlManager.SetXMLData(m_xmlData.control_layouts[0]);
			m_oOptionManager.SetXMLData(m_xmlData.control_options[0]);
			infopanel.PresentersData = m_xmlData.presenters[0];
			SetLayout(m_strDefaultLayout);

			if (m_bOnStage)
			{
				QueueRedraw();
			}

			this.resourcesPopup.Data = m_xmlData.resource_data[0];
			UpdateGlossary(m_xmlData.glossary_data[0]);
			UpdateTOC(m_xmlData.nav_data[0].outline[0]);
			
			m_bShowInfo = m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_INFO_ENABLED) && m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_SIDEBAR_ENABLED);
				
			m_strDefaultPresenterId = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_DEFAULT_PRESENTER_ID);
			
			if (m_bShowInfo)
			{
				infopanel.SetPresenter(m_strDefaultPresenterId);
			}
			
			var evtReady:wgEventFrame = new wgEventFrame(wgEventFrame.FRAME_READY);
			dispatchEvent(evtReady);
			
			m_oKeyboadShortcuts.Enabled = (m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_CONTROLS, OptionManager.OPTION_CONTROLS_ENABLEKEYBOARDSHORTCUTS));
		}

		public function UpdateSize(nWidth:int, nHeight:int):void
		{
			this.width = nWidth;
			this.height = nHeight;
		}

		override public function get width():Number
		{
			return this.background.width;
		}
		
		override public function set width(value:Number):void
		{
			if (value != this.background.width)
			{
				this.background.width = value;
				QueueRedraw();
			}
		}

		override public function get height():Number
		{
			return this.background.height;
		}
		
		override public function set height(value:Number):void
		{
			if (value != this.background.height)
			{
				this.background.height = value;
				QueueRedraw();
			}
		}

		protected function OnSlideChanged(evt:wgPlayerEvent):void
		{
			m_oCurrentSlide = evt.Slide;

			var strBody:String = "";

			if (m_xmlData != null)
			{
				var xmlNotes:XML = m_xmlData.transcript_data[0].slidetranscripts[0];

				if (xmlNotes)
				{
					var xmlNote:XML = xmlNotes.slidetranscript.(@slideid == evt.Slide.AbsoluteId)[0];

					if (xmlNote != null)
					{
						strBody = xmlNote.text();
					}
				}
			}

			this.sidebar.UpdateNotes(m_oCurrentSlide.Title, strBody);
		}

		private function LoadErrorHandler(evt:IOErrorEvent):void
		{
			m_loadData.removeEventListener(IOErrorEvent.IO_ERROR, LoadErrorHandler);
			m_loadData.removeEventListener(Event.COMPLETE, LoadCompleteHandler);
		}

		private function LoadCompleteHandler(evt:Event):void
		{
			m_loadData.removeEventListener(IOErrorEvent.IO_ERROR, LoadErrorHandler);
			m_loadData.removeEventListener(Event.COMPLETE, LoadCompleteHandler);
			m_xmlData = new XML(evt.target.data)
			ParseXMLData();
		}

		private function VolumeButton_onVolumeChanged(evt:wgEventFrame):void
		{
			var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.VOLUME_CHANGED);
			evtFrame.Volume = evt.Volume;
			dispatchEvent(evtFrame);
		}
		
		public function SetWindowTimeline(oTimeline:wgITimeline):void
		{
			m_oTimeline = oTimeline;
			this.seekbar.Timeline = oTimeline;
		}

		
		public function ShowPresenter(bShowVideo:Boolean, nWidth:int = 0, nHeight:int = 0, bShowInfo:Boolean = true, strPresenterId:String = ""):DisplayObjectContainer
		{
			var xmlPresenters:XML = m_xmlData.presenters[0];
			if (bShowVideo || (bShowInfo && xmlPresenters != null && strPresenterId != PRESENTER_NONE))
			{
				if (!m_bShowSidebar)
				{
					m_bShowSidebar = true;
				}
				
				if (logo.visible)
				{
					logo.DisplayFlatSide = true;
				}
				
				if (bShowVideo)
				{
					m_spInfoVideo = infopanel.ShowVideo(nWidth, nHeight);
				}
				else
				{
					infopanel.RemoveVideo();
				}
				
				if (bShowInfo && strPresenterId != PRESENTER_NONE)
				{
					if (strPresenterId == "" || strPresenterId == PRESENTER_DEFAULT)
					{
						infopanel.SetPresenter(m_strDefaultPresenterId);
					}
					else
					{
						infopanel.SetPresenter(strPresenterId);
					}
				}
				else
				{
					infopanel.SetPresenter("");
				}
				
				if (!infopanel.visible)
				{
					m_bShowInfo = true;
				}
			}
			else
			{
				if (infopanel.visible)
				{
					m_bShowInfo = false;
				}
				if (logo.visible)
				{
					logo.DisplayFlatSide = false;
				}
			}
			
			UpdateControls();
			
			return m_spInfoVideo;
		}
		
		public function ShowBio():void
		{
			if (infopanel.visible)
			{
				infopanel.ToggleMoreInfo();
			}
		}
		
		public function ToggleMute():void
		{
			var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.VOLUME_CHANGED);
			
			if (m_bMuted)
			{
				evtFrame.Volume = m_nVolume;
			}
			else
			{
				m_nVolume = volumeButton.Volume;
				evtFrame.Volume = 0;
			}
			
			m_bMuted = !m_bMuted;
			
			dispatchEvent(evtFrame);
		}

		public function SetActiveTab(strTabId:String)
		{
			switch (strTabId)
			{
				case CONTROL_OUTLINE:
					this.sidebar.ShowMenu();
					break;
				case CONTROL_GLOSSARY:
					this.sidebar.ShowGlossary();
					break;
				case CONTROL_TRANSCRIPT:
					this.sidebar.ShowNotes();
					break;
				case CONTROL_RESOURCES:
					if (this.resourcesPopup.visible)
					{
						resourcesPopup.TogglePanel();
					}
					break;
			}
		}
		
		public function PlayPauseSlide():void
		{
			this.seekbar.TogglePlayPause();
		}
		
		public function SetLockCursor(bShow:Boolean):void
		{
			m_oPlayer.ShowLockCursor(bShow);
		}
		
		public function GetCurrentSlide():wgISlide
		{
			var evtFrame:wgEventFrame = new wgEventFrame(wgEventFrame.GET_CURRENT_SLIDE);

			dispatchEvent(evtFrame);

			return evtFrame.ReturnData as wgISlide;
		}
		
		public function SetControlLayout(strControlLayout:String):void
		{
			m_oControlManager.SetControlLayout(strControlLayout);
		}
		
		public function EnableFrameControl(strControlName:String, bEnable:Boolean):void
		{
			m_oControlManager.EnableFrameControl(strControlName, bEnable);
		}
		
		public function EnableWindowControl(strControlName:String, bEnable:Boolean):void
		{
			m_oControlManager.EnableFrameControl(strControlName, bEnable);
		}
		
		public function SetControlVisible(strControlName:String, bVisible:Boolean):void
		{
			m_oControlManager.SetControlVisible(strControlName, bVisible);
		}
		
		public function SetFlashVars(oFlashVars:Object):void
		{
		}

		public function ShowVideo(bShow:Boolean, nWidth:int = 0, nHeight:int = 0):DisplayObjectContainer
		{
			return null;
		}

		public function ShowPlayerFrame(bShow:Boolean):void
		{
		}

		public function DisablePlayerFrame(bDisable:Boolean):void
		{
		}

		public function UpdateOptions(strXMLData:String):void
		{
		}

		public function SetFont(strFontName:String):void
		{
		}

		public function SetColorScheme(strColorScheme:String):void
		{
		}

		public function SetStringTable(strStringTable:String):void
		{
		}

		public function SetListDisplayType(strDisplayType:String, nTooltip:int, bAutoNumber:Boolean):void
		{
		}
	}
}
