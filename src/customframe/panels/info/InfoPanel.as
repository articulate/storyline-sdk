package customframe.panels.info
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	
	import com.articulate.wg.v3_0.wgITimeline;
	
	import customframe.Frame;
	import customframe.windows.SlideContainer;
	
	/**
	 * This is the logic for the InfoPanel symbol in the library (/panels/info/InfoPanel.)
	 *
	 * InfoPanel loads and displays the presenter image as well as displays the Name and Title text.
	 * It also handles display of presenter video specified by the slide and creating the InfoPanelPopup.
	 */
	public class InfoPanel extends MovieClip
	{	
		protected const DEFAULT_HEIGHT:int = 80;
		protected const VIDEO_SIDE_MARGIN:int = 20;
		protected const VIDEO_TOP_MARGIN:int = 10;
		protected const VIDEO_BOTTOM_MARGIN:int = 10;
		protected const LEFT_CELL_PERCENT:Number = .22;
		protected const RIGHT_CELL_TOP_MARGIN:int = 11;
		protected const RIGHT_CELL_LEFT_MARGIN:int = 15;
		protected const LEFT_CELL_TOP_MARGIN:int = 14;
		protected const LEFT_CELL_LEFT_MARGIN:int = 10;
		protected const TEXT_VERTICAL_OFFSET:int = -1;
		protected const MAX_IMAGE_WIDTH:int = 45;
		protected const MAX_IMAGE_HEIGHT:int = 59;
		protected const IMAGE_MARGIN:int = 11;
		
		protected const FRAME_LABEL_IMAGE:String = "image";
		protected const FRAME_LABEL_VIDEO:String = "video";
		protected const FRAME_LABEL_INFO:String = "info";
		protected const FRAME_LABEL_BIO:String = "bio";
		protected const FRAME_LABEL_EMAIL:String = "email";
		
		protected var m_strLastFileName:String = "";
		protected var m_strFileName:String = "";
		protected var m_strEmail:String = "";
		protected var m_strName:String = "";
		protected var m_strTitle:String = "";
		
		protected var m_ldrImage:Loader = null;
		protected var m_bLoader:Boolean = false;
		protected var m_bImageLoaded:Boolean = false;
		protected var m_bBio:Boolean = false;
		
		protected var m_nImageWidth:int = 0;
		protected var m_nImageHeight:int = 0;
		protected var m_nScale:Number = 1;
		
		public var background:MovieClip;
		public var nameField:TextField;
		public var titleField:TextField;
		public var moreInfo:MovieClip;
		public var imageMask:Sprite;
		public var videoMask:Sprite;
		
		protected var m_bDisplayFlatSide:Boolean = false;
		protected var m_spVideo:Sprite = null;
		protected var m_xmlPresentersData:XML;
		protected var m_xmlPresenterData:XML;
		protected var m_oPopup:InfoPanelPopup = null;
		
		public function InfoPanel()
		{
			this.gotoAndStop(FRAME_LABEL_IMAGE);
			moreInfo.gotoAndStop(FRAME_LABEL_INFO);
			imageMask.visible = false;
		}
		
		public function set DisplayFlatSide(bDisplayFlatSide:Boolean):void
		{
			if (m_bDisplayFlatSide != bDisplayFlatSide)
			{
				m_bDisplayFlatSide = bDisplayFlatSide;
				
				if (m_bDisplayFlatSide)
				{
					background.gotoAndStop("flatTop")
				}
				else 
				{
					background.gotoAndStop("roundTop")
				}
			}
		}
		
		public function set PresentersData(data:XML):void
		{
			m_xmlPresentersData = data;
		}
		
		public function set Popup(popupInstance:InfoPanelPopup):void
		{
			m_oPopup = popupInstance;
		}
		
		public function get Popup():InfoPanelPopup
		{
			return m_oPopup;
		}
		
		public function ShowMoreInfo(evt:MouseEvent = null):void
		{
			if(m_bBio)
			{
				var oFrame:Frame = Frame.CustomFrame;
				var oTimeline:wgITimeline = oFrame.Timeline;
				var oSlidContainer:SlideContainer = oFrame.slideContainer;
				if (m_oPopup == null)
				{
					m_oPopup = new InfoPanelPopup();
					
					m_oPopup.x = int(oSlidContainer.x + (oSlidContainer.width / 2) - (m_oPopup.Width / 2));
					m_oPopup.y = int(oSlidContainer.y + (oSlidContainer.height / 2) - (m_oPopup.Height / 2));
					m_oPopup.SetBlock(oFrame.width, oFrame.height);
				}
				
				m_oPopup.SetPresenter(m_xmlPresenterData);
				m_oPopup.ResumeAfterClose = oTimeline.TimelinePlaying;
				
				if (oTimeline.TimelinePlaying)
				{
					oTimeline.PauseAnimations();
				}
				
				oFrame.addChild(m_oPopup);
			}
			else if (m_strEmail != "")
			{
				var request:URLRequest = new URLRequest("mailto:" + m_strEmail);
				request.method = URLRequestMethod.POST;
				navigateToURL(request, "_self");
			}
		}
		
		public function ToggleMoreInfo():void
		{
			if (m_bBio)
			{
				if (m_oPopup != null)
				{
					m_oPopup.CloseWindow(null);
				}
				else
				{
					ShowMoreInfo(null);
				}
			}
		}	
		
		public function ShowVideo(nWidth:int, nHeight:int):Sprite 
		{
			this.gotoAndStop(FRAME_LABEL_VIDEO);
			
			var nAdjustedWidth:int = nWidth;
			var nAdjustedHeight:int = nHeight;
			
			if (nWidth > this.width - (VIDEO_SIDE_MARGIN * 2))
			{
				nAdjustedWidth = this.width - (VIDEO_SIDE_MARGIN * 2);
				nAdjustedHeight = ((this.width - (VIDEO_SIDE_MARGIN * 2)) / nWidth) * nHeight;
			}
			
			if (m_spVideo == null || nAdjustedWidth != m_spVideo.width || nAdjustedHeight != m_spVideo.height)
			{
				if (m_spVideo != null)
				{
					removeChild(m_spVideo);
					m_spVideo = null;
				}
				
				m_spVideo = new Sprite();
				
				m_spVideo.graphics.clear();
				m_spVideo.graphics.beginFill(0x000000, 0);
				m_spVideo.graphics.drawRect(0, 0, nAdjustedWidth, nAdjustedHeight);
				m_spVideo.graphics.endFill();
				m_spVideo.y = VIDEO_TOP_MARGIN;
				m_spVideo.x = VIDEO_SIDE_MARGIN;
				
				addChild(m_spVideo);
				
				videoMask.visible = false;
				videoMask.width = nAdjustedWidth;
				videoMask.height = nAdjustedHeight;
				videoMask.x = VIDEO_SIDE_MARGIN;
				videoMask.y = VIDEO_TOP_MARGIN;
				m_spVideo.mask = videoMask;
				
				if (m_bBio || m_strFileName !=  "" || m_strName !=  "" || m_strTitle !=  "" || m_strEmail != "")
				{
					background.height = m_spVideo.height + DEFAULT_HEIGHT + VIDEO_BOTTOM_MARGIN;
				}
				else 
				{
					background.height = m_spVideo.height + VIDEO_TOP_MARGIN + VIDEO_BOTTOM_MARGIN;
				}
			}
			
			UpdateControls();
			
			return m_spVideo;
		}
		
		public function RemoveVideo():void
		{
			if (m_spVideo != null)
			{
				this.gotoAndStop(FRAME_LABEL_IMAGE);
				removeChild(m_spVideo);
				m_spVideo = null;
				background.height = DEFAULT_HEIGHT;
			}
		}
		
		public function SetPresenter(strPresenterId:String):void
		{
			var presenterData:XML = null;
			
			if (strPresenterId != "" && strPresenterId != "none" && m_xmlPresentersData != null)
			{
				presenterData = m_xmlPresentersData.presenter.(@id == strPresenterId)[0];
			}
			
			if (presenterData != null)
			{	
				m_xmlPresenterData = presenterData;
				m_strFileName = presenterData.@photo;
				m_strName = presenterData.@name;
				m_strTitle = presenterData.@title;
				m_strEmail = presenterData.@email;
				
				moreInfo.addEventListener(MouseEvent.CLICK, ShowMoreInfo);
				
				if (presenterData.bioHtml[0] != null && presenterData.bioHtml[0] != "")
				{
					m_bBio = true;
				}
				else
				{
					m_bBio = false;
				}
				
				SetImgData();
			}
			else
			{
				m_strFileName = "";
				m_strName = "";
				m_strTitle= "";
				m_strEmail = "";
				m_bBio = false;
			}
			
			if (m_bBio && m_strEmail != "") 
			{
				moreInfo.gotoAndStop(FRAME_LABEL_INFO);
			}
			else if(m_bBio)
			{
				moreInfo.gotoAndStop(FRAME_LABEL_BIO);
			}
			else if (m_strEmail != "")
			{
				moreInfo.gotoAndStop(FRAME_LABEL_EMAIL);
			}
			
			UpdateControls();
		}
		
		public function SetImgData():void
		{
			if ((m_spVideo != null || m_strLastFileName != m_strFileName) && m_bImageLoaded)
			{
				// Destroy the old resource
				if (m_ldrImage.contentLoaderInfo.hasEventListener(Event.COMPLETE))
				{
					m_ldrImage.contentLoaderInfo.removeEventListener(Event.COMPLETE, HandleLoadComplete);
				}
				
				if (m_ldrImage.stage)
				{
					removeChild(m_ldrImage);
				}
				
				m_ldrImage = null;
				
				m_bImageLoaded = false;
			}
			
			if (m_strLastFileName != m_strFileName || (m_spVideo != null))
			{
				m_strLastFileName = m_strFileName;
				
				// Load the Resource
				if (m_strFileName != "" && m_strFileName != null && m_spVideo == null)
				{
					m_ldrImage = new Loader();
					
					var reqImage:URLRequest = new URLRequest(m_strFileName);
					
					m_ldrImage.contentLoaderInfo.addEventListener(Event.COMPLETE, HandleLoadComplete);
					m_ldrImage.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, HandleLoadError);
					m_ldrImage.load(reqImage);
				}
			}
		}
		
		public function HandleLoadComplete(evt:Event):void
		{
			if (!m_bImageLoaded)
			{
				m_ldrImage.contentLoaderInfo.removeEventListener(Event.COMPLETE, HandleLoadComplete);
				m_ldrImage.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, HandleLoadError);
				
				if (m_ldrImage)
				{
					m_nImageWidth = m_ldrImage.width;
					m_nImageHeight = m_ldrImage.height;
					
					m_nScale = 1;
					
					if (m_nImageWidth > MAX_IMAGE_WIDTH)
					{
						m_nScale = MAX_IMAGE_WIDTH / m_nImageWidth;
					}
					
					if (m_nImageHeight * m_nScale > MAX_IMAGE_HEIGHT)
					{
						m_nScale = MAX_IMAGE_HEIGHT / m_nImageHeight;
					}
					
					m_ldrImage.scaleX = m_nScale;
					m_ldrImage.scaleY = m_nScale;
					
					m_ldrImage.x = LEFT_CELL_LEFT_MARGIN;
					m_ldrImage.y = LEFT_CELL_TOP_MARGIN;
				}
				
				imageMask.width = m_ldrImage.width;
				imageMask.height = m_ldrImage.height;
				imageMask.x = m_ldrImage.x;
				imageMask.y = m_ldrImage.y;
				
				m_ldrImage.mask = imageMask;
				
				addChild(m_ldrImage);
				
				m_bImageLoaded = true;
			}
		}
		
		public function HandleLoadError(evt:IOErrorEvent):void
		{
			m_ldrImage.contentLoaderInfo.removeEventListener(Event.COMPLETE, HandleLoadComplete);
			m_ldrImage.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, HandleLoadError);
		}
		
		public function UpdateControls():void
		{	
			nameField.text = m_strName;
			titleField.text = m_strTitle;
			
			if (m_bBio || m_strEmail != "")
			{
				moreInfo.visible = true;
			}
			else if(moreInfo.visible)
			{
				moreInfo.visible = false;
			}
			
			var nYpos:Number;
			
			if (m_spVideo == null)
			{
				var nRightCellX:int;
				
				if (m_strFileName != "")
				{
					nRightCellX = (LEFT_CELL_PERCENT * background.width) + RIGHT_CELL_LEFT_MARGIN;
				}
				else
				{
					nRightCellX = LEFT_CELL_LEFT_MARGIN;
				}
				
				nYpos = RIGHT_CELL_TOP_MARGIN;
				
				if (nameField.text != "")
				{
					nameField.y = nYpos;
					nYpos = nameField.y + nameField.height + TEXT_VERTICAL_OFFSET;
				}
				
				
				if (titleField.text != "")
				{
					titleField.y = nYpos;
					nYpos = titleField.y + titleField.height + TEXT_VERTICAL_OFFSET;
				}
				
				if (m_bBio || m_strEmail != "")
				{
					moreInfo.y = nYpos;
				}
			}
			else
			{
				nYpos = m_spVideo.y + m_spVideo.height + RIGHT_CELL_TOP_MARGIN;
				
				if (nameField.text != "")
				{
					nameField.y = nYpos;
					nYpos = nameField.y + nameField.height + TEXT_VERTICAL_OFFSET;
				}
				
				if (titleField.text != "")
				{
					titleField.y = nYpos;
					nYpos = titleField.y + titleField.height + TEXT_VERTICAL_OFFSET;
				}
				
				if (m_bBio || m_strEmail != "")
				{
					moreInfo.y = nYpos;
				}
			}
			Frame.CustomFrame.UpdateControls();
		}
	}
}