package  customframe.panels.info 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import customframe.Frame;
	import customframe.components.scrollbar.CustomScrollbar;
	import customframe.components.scrollbar.ScrollbarEvent;
	
	/**
	 * This is the logic for the InfoPanelPopup symbol in the library (/panels/info/InfoPanelPopup.)
	 *
	 * InfoPanelPopup displays the bio text for the specified presentor.
	 *
	 */
	public class InfoPanelPopup extends Sprite
	{	
		protected const WINDOW_MARGIN:Number = 20;
		protected const CELL_PADDING:Number = 5;
		
		public var background:Sprite;		
		public var bioField:TextField;
		public var sendEmailButton:SimpleButton;
		public var closeButton:SimpleButton;
		public var iconClose:MovieClip;
		public var block:Sprite;
		public var lightBox:Sprite;
		
		protected var m_strEmail:String = "";
		protected var m_bResumeAfterClose:Boolean = false;
		
		protected var m_nBoxWidth:Number = 340;
		protected var m_nBoxHeight:Number = 215;
		
		protected var m_spScrollBio:CustomScrollbar = null;
		
		public function InfoPanelPopup() 
		{	
			m_spScrollBio = new CustomScrollbar();
			
			iconClose.buttonMode = true;
			iconClose.addEventListener(MouseEvent.CLICK, CloseWindow);
			closeButton.addEventListener(MouseEvent.CLICK, CloseWindow);
			sendEmailButton.addEventListener(MouseEvent.CLICK, SendEmail);
			
			addChild(m_spScrollBio);
			
			m_spScrollBio.addEventListener(ScrollbarEvent.SCROLLING, ScrollBio);
			addEventListener(MouseEvent.MOUSE_WHEEL, OnMouseWheel);
			
			bioField.autoSize = TextFieldAutoSize.LEFT;
		}
		
		public function SetBlock(nWidth:int, nHeight:int):void
		{
			block.width = nWidth;
			block.height = nHeight;
			block.x = this.x * -1;
			block.y = this.y * -1;
			
			var spContainer:Sprite = Frame.CustomFrame.GetSlideContainer();
			
			lightBox.width = spContainer.width;
			lightBox.height = spContainer.height;
			lightBox.x = ((spContainer.width / 2) - (background.width / 2)) * -1;
			lightBox.y = ((spContainer.height / 2) - (background.height / 2)) * -1;
		}
		
		public function get Width():Number
		{
			return background.width;
		}
		
		public function get Height():Number
		{
			return background.height;
		}
		
		public function set ResumeAfterClose(bResumeAfterClose:Boolean):void
		{
			m_bResumeAfterClose = bResumeAfterClose;
		}
		
		protected function ScrollBio(evt:ScrollbarEvent)
		{
			var nWidth:int = background.width - 1;
			
			if (m_spScrollBio.ContentHeight > m_spScrollBio.height)
			{
				nWidth = m_spScrollBio.x - 1;
			}
			
			bioField.scrollRect = new Rectangle(0, m_spScrollBio.Position, m_nBoxWidth, m_spScrollBio.height - 3);
			
		}
		
		protected function OnMouseWheel(evt:MouseEvent):void
		{
			if (this.stage != null)
			{
				m_spScrollBio.ScrollByLines(-Math.round(evt.delta / 3));
			}
		}
		
		public function CloseWindow(evt:MouseEvent):void
		{
			if (m_bResumeAfterClose) {
				m_bResumeAfterClose = false;
				Frame.CustomFrame.Timeline.PlayAnimations();
			}
			Frame.CustomFrame.infopanel.Popup = null;
			this.parent.removeChild(this);
			m_spScrollBio.ScrollTo(0);
		}
		
		private function SendEmail(evt:MouseEvent):void
		{
			var request:URLRequest = new URLRequest("mailto:" + m_strEmail); 
			request.method = URLRequestMethod.POST;
			navigateToURL(request, "_self");
		}
		
		public function SetPresenter(presenterData:XML):void
		{
			if (presenterData.bioHtml[0])
			{
				bioField.htmlText = presenterData.bioHtml[0];
			}
			else
			{
				bioField.htmlText = "";
			}
			
			m_strEmail = presenterData.@email
			
			if (m_strEmail != "")
			{
				sendEmailButton.visible = true;
			}
			else
			{
				sendEmailButton.visible = false;
			}
			
			if (bioField.textHeight >= m_nBoxHeight)
			{
				m_spScrollBio.x = bioField.x + bioField.width;
				m_spScrollBio.y = bioField.y;
				m_spScrollBio.height = m_nBoxHeight - (WINDOW_MARGIN * 2) - CELL_PADDING - closeButton.height;
				
				m_spScrollBio.ContentHeight = bioField.textHeight + 5;
				
				ScrollBio(null);
			}
			else
			{
				m_spScrollBio.visible = false;
			}
		}
	}
}
