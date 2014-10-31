package customframe.panels.logo
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	import customframe.base.CustomSprite;

	/**
	 * This is the logic for the Logo symbol in the library (/panels/logo/Logo.)
	 *
	 * Logo loads and dislays an image of the logo as specified by the Articulate player.
	 *
	 */
	public class Logo extends CustomSprite
	{
		public static const DEFAULT_WIDTH:int = 220;
		public static const DEFAULT_HEIGHT:int = 120;
		public static const MARGIN:int = 10;

		public var background:MovieClip;

		protected var m_strFileName:String = "";
		protected var m_ldrImage:Loader = null;
		protected var m_bLoaded:Boolean = false;

		protected var m_nImageWidth:int = 0;
		protected var m_nImageHeight:int = 0;
		protected var m_nScale:Number = 1;
		protected var m_bDisplayFlatSide:Boolean;

		public function Logo()
		{
			super();
			this.width = DEFAULT_WIDTH;
			this.height = DEFAULT_HEIGHT;
		}

		public function get ImageHeight():int
		{
			return m_nImageHeight;
		}
		public function set ImageHeight(value:int):void
		{
			m_nImageHeight = value;
			QueueRedraw();
		}

		public function get ImageWidth():int
		{
			return m_nImageWidth;
		}
		public function set ImageWidth(value:int):void
		{
			m_nImageWidth = value;
			QueueRedraw();
		}

		public function get FileName():String
		{
			return m_strFileName;
		}
		public function set FileName(value:String):void
		{
			m_strFileName = value;
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

		public function Load():void
		{
			// Destroy the old resource
			if (m_ldrImage != null)
			{
				if (m_ldrImage.stage != null)
				{
					removeChild(m_ldrImage);
				}
				m_ldrImage = null;
			}

			m_bLoaded = false;
			// Load the Resource
			if (m_strFileName != "" && m_strFileName != null)
			{
				m_ldrImage = new Loader();
				m_ldrImage.contentLoaderInfo.addEventListener(Event.COMPLETE, Loader_onComplete);
				m_ldrImage.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, Loader_onError);
				m_ldrImage.load(new URLRequest(m_strFileName));
			}
		}

		override public function Redraw():void
		{
			super.Redraw();
			m_nScale = 1;

			if (m_nImageWidth > (this.width - MARGIN * 2))
			{
				m_nScale = (this.width - MARGIN * 2) / m_nImageWidth;
			}

			this.height = m_nImageHeight * m_nScale + MARGIN * 2;
			this.background.width = this.width;
			this.background.height = this.height;
			this.scaleX = 1;
			this.scaleY = 1;

			if (m_ldrImage != null)
			{
				m_ldrImage.x = MARGIN;
				m_ldrImage.y = MARGIN;
				m_ldrImage.scaleX = m_nScale;
				m_ldrImage.scaleY = m_nScale;
				m_ldrImage.x = (this.width - m_nImageWidth) / 2;
			}
		}

		private function Loader_onComplete(evt:Event):void
		{
			if (!m_bLoaded)
			{
				Redraw();
				m_ldrImage.contentLoaderInfo.removeEventListener(Event.COMPLETE, Loader_onComplete);
				m_ldrImage.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, Loader_onError);
				addChild(m_ldrImage);
				m_bLoaded = true;
			}
		}

		private function Loader_onError(evt:IOErrorEvent):void
		{
			m_ldrImage.contentLoaderInfo.removeEventListener(Event.COMPLETE, Loader_onComplete);
			m_ldrImage.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, Loader_onError);
		}
	}
}