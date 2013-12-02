package customframe
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;

	import com.articulate.wg.v2_0.*;


	import customframe.base.CustomSprite;
	import customframe.components.buttons.ControlButtons;
	import customframe.components.buttons.VolumeButton;
	import customframe.components.logo.Logo;
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

		public static const OUTLINE:String = "outline";
		public static const RESOURCES:String = "resources";
		public static const GLOSSARY:String = "glossary";
		public static const TRANSCRIPT:String = "transcript";
		public static const VOLUME:String = "volume";
		public static const SUBMIT:String = "submit";
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

		private const MARGIN_LEFT:int = 10;
		private const MARGIN_RIGHT:int = 10;
		private const MARGIN_LOGO_TOP:int = 10;

		public static var CustomFrame:Frame = null;

		public var timer:CustomTimer;
		public var slideContainer:SlideContainer
		public var titleField:TextField;
		public var sidebar:Sidebar
		public var volumeButton:VolumeButton
		public var controlButtons:ControlButtons
		public var seekbar:Seekbar
		public var logo:Logo
		public var background:Background;
		public var resourcesPopup:Resources;

		protected var m_strCurrentSlideId:String = "";
		protected var m_bPlaying:Boolean = false;
		protected var m_oCurrentSlide:wgISlide = null;
		protected var m_xmlData:XML = null;
		protected var m_loadData:URLLoader = null;
		protected var m_strFilename:String = "";
		protected var m_strRemotePath:String = "";
		protected var m_strDefaultLayout:String = "";
		protected var m_bShowSidebar:Boolean = false;
		protected var m_bShowBottomBar:Boolean = false;
		protected var m_bShowMenu:Boolean = false;
		protected var m_bShowLogo:Boolean = false;

		public function Frame()
		{
			CustomFrame = this;
			this.ControlManager = new ControlManager();
			this.OptionManager = new OptionManager();
			this.volumeButton.addEventListener(wgEventFrame.VOLUME_CHANGED, VolumeButton_onVolumeChanged);
			addEventListener(wgPlayerEvent.SLIDE_TRANSITION_IN, OnSlideChanged);
		}

		public function AddTimer(oTimer:wgITimer):void
		{
			this.timer.AddTimer(oTimer);
			this.timer.visible = true;
			this.timer.TimeFormat = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_SIDEBAR,
																	   OptionManager.OPTION_TIME_FORMAT);
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
			return false;
		}

		public function GetSlideContainer():Sprite
		{
			return this.slideContainer;
		}

		public function GetSlideRect():Rectangle
		{
			return new Rectangle(this.slideContainer.x, this.slideContainer.y,
								 this.slideContainer.width, this.slideContainer.height);
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
			if (this.titleField.text != strTitle)
			{
				this.titleField.text = strTitle;
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
			var bShowBottomBar:Boolean = m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_BOTTOMBAR,
				OptionManager.OPTION_BOTTOMBAR_ENABLED, true);
			// Volume button - m_spVolume
			this.volumeButton.visible = (m_oControlManager.IsControlEnabled(VOLUME) && bShowBottomBar);
			// Control buttons
			this.controlButtons.ShowSubmit = (m_oControlManager.IsControlEnabled(SUBMIT) && bShowBottomBar);
			this.controlButtons.ShowNext = (m_oControlManager.IsControlEnabled(NEXT) && bShowBottomBar);
			this.controlButtons.ShowPrevious = (m_oControlManager.IsControlEnabled(PREVIOUS) && bShowBottomBar);
			this.controlButtons.x = this.width - MARGIN_RIGHT - this.controlButtons.width;
			// Seekbar
			this.seekbar.width = this.controlButtons.x - this.seekbar.x;
			this.seekbar.visible = (m_oControlManager.IsControlEnabled(SEEKBAR) && bShowBottomBar);
			this.seekbar.ReplayButtonEnabled = (m_oControlManager.IsControlEnabled(REPLAY) && bShowBottomBar);
			this.seekbar.PlayPauseButtonEnabled = (m_oControlManager.IsControlEnabled(PAUSE_PLAY) &&
				bShowBottomBar);
			// Sidebar
			var bShowLogo:Boolean =
				m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_LOGO_ENABLED) &&
				m_oOptionManager.GetOptionAsBool(OptionManager.OPTGROUP_SIDEBAR, OptionManager.OPTION_SIDEBAR_ENABLED);

			if (bShowLogo)
			{
				this.logo.visible = true;
				this.logo.FileName = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_SIDEBAR,
					OptionManager.OPTION_LOGO_URL);
				this.logo.ImageWidth =  parseInt(m_oOptionManager.GetOptionProperty(OptionManager.OPTGROUP_SIDEBAR,
					OptionManager.OPTION_LOGO_URL, WIDTH));
				this.logo.ImageHeight =  parseInt(m_oOptionManager.GetOptionProperty(OptionManager.OPTGROUP_SIDEBAR,
					OptionManager.OPTION_LOGO_URL, HEIGHT));
				this.logo.Load();
				this.logo.height = this.logo.ImageHeight + 16;
				this.sidebar.y = this.logo.y + this.logo.height + 8;
			}
			else
			{
				this.logo.visible = false;
				this.sidebar.y = 8;
			}

			var bShowNotes:Boolean = (m_oControlManager.IsControlEnabled(TRANSCRIPT));
			var bShowGlossary:Boolean = (m_oControlManager.IsControlEnabled(GLOSSARY));
			var bShowMenu:Boolean = (m_oControlManager.IsControlEnabled(OUTLINE));

			if (bShowNotes || bShowGlossary || bShowMenu  || bShowLogo)
			{
				this.sidebar.visible = true;
				this.background.SidebarBackgroundVisible = true;
				this.slideContainer.x = this.background.SidebarBackgroundWidth +
					(this.width - this.background.SidebarBackgroundWidth -
						this.slideContainer.width) * 0.5;
				this.titleField.x = this.slideContainer.x;
				
				(bShowNotes) ? this.sidebar.ShowNotes() : this.sidebar.HideNotes();
				(bShowGlossary) ? this.sidebar.ShowGlossary() : this.sidebar.HideGlossary();
				(bShowMenu) ? this.sidebar.ShowMenu() : this.sidebar.HideMenu();
			}
			else
			{
				this.sidebar.visible = false;
				this.background.SidebarBackgroundVisible = false;
				this.slideContainer.x = (this.width - this.slideContainer.width) * 0.5;
				this.titleField.x = MARGIN_LEFT;
			}

			var nTitleBottom:Number = this.titleField.y + this.titleField.textHeight;
			var nVisibleBottom:Number = (bShowBottomBar) ? this.seekbar.y : this.height;
			this.slideContainer.y = nTitleBottom + (nVisibleBottom - nTitleBottom - this.slideContainer.height) * 0.5;

			this.resourcesPopup.visible = m_oControlManager.IsControlEnabled(RESOURCES);

			var strProjectTitle:String = m_oOptionManager.GetOptionAsString(OptionManager.OPTGROUP_SIDEBAR,
				OptionManager.OPTION_TITLE_TEXT);

			if (strProjectTitle != null)
			{
				SetTitle(strProjectTitle);
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
			m_strDefaultLayout = m_xmlData.@default_layout;
			m_oControlManager.SetXMLData(m_xmlData.control_layouts[0]);
			m_oOptionManager.SetXMLData(m_xmlData.control_options[0]);
			SetLayout(m_strDefaultLayout);

			if (m_bOnStage)
			{
				QueueRedraw();
			}

			this.resourcesPopup.Data = m_xmlData.resource_data[0];
			UpdateGlossary(m_xmlData.glossary_data[0]);
			UpdateTOC(m_xmlData.nav_data[0].outline[0]);
			var evtReady:wgEventFrame = new wgEventFrame(wgEventFrame.FRAME_READY);
			dispatchEvent(evtReady);
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
			this.seekbar.CurrentSlide = m_oCurrentSlide;
			this.sidebar.CurrentSlide = m_oCurrentSlide;

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

		// Unimplemented Interface functions.

		public function ShowPresenter(bShow:Boolean,
									  nWidth:int = 0,
									  nHeight:int = 0,
									  bShowInfo:Boolean = true,
									  strPresenterId:String = ""):DisplayObjectContainer
		{
			return null;
		}

		public function EnableFrameControl(strControlName:String, bEnable:Boolean):void
		{
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

		public function SetActiveTab(strTabId:String)
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

		public function SetControlLayout(strControlLayout:String):void
		{
		}

		public function SetListDisplayType(strDisplayType:String, nTooltip:int, bAutoNumber:Boolean):void
		{
		}
	}
}
