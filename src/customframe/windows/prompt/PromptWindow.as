package customframe.windows.prompt
{
	import com.articulate.wg.v3_0.wgIWindow;
	import com.articulate.wg.v3_0.wgITimeline;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	import customframe.Frame;
	import customframe.base.SizingSprite;
	import customframe.components.buttons.ControlButtons;
	import customframe.windows.SlideContainer;

	/**
	 * This is the logic for the PromptWindow symbol in the library (/windows/prompt/PromptWindow.)
	 *
	 * A PromptWindow is a dialogue that is displayed above the player.
	 */
	public class PromptWindow extends SizingSprite implements wgIWindow
	{
		public static const CONTENT_MARGIN:int = 10;
		public static const CONTENT_TOP_MARGIN:int = 54;
		public static const CONTENT_BOTTOM_MARGIN:int = 10;
		public static const BORDER_THICKNESS:int = 1;

		protected var m_oFrame:Frame = null;
		protected var m_oContentArea:PromptContentArea = new PromptContentArea();

		public var background:Sprite;
		public var border:Sprite;
		public var titleField:TextField;

		public function PromptWindow(oFrame:Frame)
		{
			super();
			m_oFrame = oFrame;
			m_oContentArea.x = CONTENT_MARGIN;
			m_oContentArea.y = CONTENT_TOP_MARGIN;
			addChild(m_oContentArea);
			m_oContentArea.addEventListener(PromptContentArea.CHILD_ADDED, ContentArea_onChildAdded);
		}

		public function GetSlideContainer():Sprite
		{
			return this.m_oContentArea;
		}

		override public function Redraw():void
		{
			super.Redraw();
			this.background.width = m_nWidth;
			this.background.height = m_nHeight;
			this.border.width = m_nWidth - BORDER_THICKNESS * 2;
			this.border.height = m_nHeight - BORDER_THICKNESS * 2;
			m_oContentArea.width = m_nWidth - CONTENT_MARGIN * 2;
			m_oContentArea.height = m_nHeight - CONTENT_BOTTOM_MARGIN;
			// Center on Slide Container
			var spSlideContainer:Sprite = m_oFrame.GetSlideContainer();
			this.x = spSlideContainer.x + (spSlideContainer.width - m_nWidth) * 0.5;
			this.y = spSlideContainer.y + (spSlideContainer.height - m_nHeight) * 0.5;
		}

		public function GetSlideRect():Rectangle
		{
			return new Rectangle(m_oContentArea.x, m_oContentArea.y, m_oContentArea.width, m_oContentArea.height);
		}

		public function GetDisplayObject():DisplayObject
		{
			return this;
		}

		public function SetControlLayout(strControlLayout:String):void
		{
			// Not implemented
		}

		public function SetTitle(strTitle:String):void
		{
			this.titleField.htmlText = strTitle;
		}

		public function get SlideScale():Number
		{
			return m_oFrame.SlideScale;
		}

		public function get ShadeAlpha():Number
		{
			return m_oFrame.ShadeAlpha;
		}

		protected function ContentArea_onChildAdded(evt:Event):void
		{
			QueueRedraw();
		}
		
		public function SetWindowTimeline(oTimeline:wgITimeline):void
		{
		}
		
		public function EnableWindowControl(strControlName:String, bEnable:Boolean):void
		{
		}
		
		public function SetControlVisible(strControlName:String, bVisible:Boolean):void
		{
		}
		
		public function get ScaleToFit():Boolean
		{
			return true;
		}
	}
}