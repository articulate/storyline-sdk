package customframe.windows.lightbox
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	import com.articulate.wg.v2_0.wgEventWindow;
	import com.articulate.wg.v2_0.wgIWindow;

	import customframe.base.SizingSprite;
	import customframe.components.buttons.ControlButtons;
	import customframe.managers.ControlManager;
	import customframe.windows.SlideContainer;

	/**
	 * This is the logic for the Lightbox symbol in the library (/windows/lightbox/Lightbox.)
	 *
	 * A Lightbox is a slide that is displayed in a modal window above the rest of the player. It is scaled
	 * so that it fits comfortablywithinthe dimensions of the player window. It contains a close button so the
	 * user can dismiss the Lightbox and return to the normal player display.
	 *
	 */
	public class Lightbox extends SizingSprite implements wgIWindow
	{
		private const SHADE_ALPHA:Number = 70;
		private const SCALE:Number = 0.85;
		private const BORDER_WIDTH:int = 4;

		private const CONTROL_BORDER_SMALL:int = 2;
		private const CONTROL_BORDER_BOTTOM:int = 40;
		private const MARGIN_BUTTON_SPACE:int = 5;

		public var background:Sprite;
		public var closeButton:Sprite;
		public var controlButtons:ControlButtons;
		public var slideContainer:SlideContainer;

		protected var m_spSlideContainer:Sprite = new Sprite();
		protected var m_spMask:Sprite = new Sprite();
		protected var m_bShowControls:Boolean = false;
		protected var m_rectSlide:Rectangle = null;

		public function Lightbox(oControlManager:ControlManager, bShowControls:Boolean = false)
		{
			super();
			m_oControlManager = oControlManager;
			m_bShowControls = bShowControls;

			addChildAt(m_spSlideContainer, 2);
			addChild(m_spMask);

			this.closeButton.buttonMode = true;
			this.closeButton.useHandCursor = true;
			this.closeButton.addEventListener(MouseEvent.CLICK, CloseButton_onClick);
			this.controlButtons.scaleX = SCALE;
			this.controlButtons.scaleY = SCALE;

			m_spSlideContainer.mask = m_spMask;
		}

		public function get ShadeAlpha():Number
		{
			return SHADE_ALPHA;
		}

		public function get SlideScale():Number
		{
			return SCALE;
		}

		public function SetTitle(strTitle:String):void
		{

		}

		protected function CloseButton_onClick(evt:Event = null)
		{
			dispatchEvent(new wgEventWindow(wgEventWindow.EVENT_CLOSE_WINDOW));
		}

		public function GetSlideContainer():Sprite
		{
			return m_spSlideContainer;
		}

		public function SetControlLayout(strControlLayout:String):void
		{
			if (m_bShowControls)
			{
				this.controlButtons.ShowNext = ControlEnabled(strControlLayout, "next");
				this.controlButtons.ShowPrevious = ControlEnabled(strControlLayout, "previous");
				this.controlButtons.ShowSubmit = ControlEnabled(strControlLayout, "submit");
			}
		}

		public function GetSlideRect():Rectangle
		{
			if (m_bDirty)
			{
				Redraw();
			}

			return m_rectSlide;
		}

		public function GetDisplayObject():DisplayObject
		{
			return this;
		}

		override public function Redraw():void
		{
			super.Redraw();
			this.closeButton.x = (m_nWidth - BORDER_WIDTH / 2);
			this.closeButton.y = (BORDER_WIDTH / 2);

			this.controlButtons.visible = m_bShowControls;
			this.background.width = m_nWidth;
			this.background.height = m_nHeight;

			// Create the slide rect
			if (m_bShowControls)
			{
				this.slideContainer.x = BORDER_WIDTH + CONTROL_BORDER_SMALL;
				this.slideContainer.y = BORDER_WIDTH + CONTROL_BORDER_SMALL;
				m_spSlideContainer.x = BORDER_WIDTH + CONTROL_BORDER_SMALL;
				m_spSlideContainer.y = BORDER_WIDTH + CONTROL_BORDER_SMALL;
				this.slideContainer.width = m_nWidth - (BORDER_WIDTH + CONTROL_BORDER_SMALL) * 2;
				this.slideContainer.height = m_nHeight - (BORDER_WIDTH + CONTROL_BORDER_SMALL) * 2;
				m_rectSlide = new Rectangle(BORDER_WIDTH + CONTROL_BORDER_SMALL,
											BORDER_WIDTH + CONTROL_BORDER_SMALL,
											m_nWidth - BORDER_WIDTH * 2 - CONTROL_BORDER_SMALL * 2,
											m_nHeight - BORDER_WIDTH * 2 - (CONTROL_BORDER_SMALL + CONTROL_BORDER_BOTTOM));
				this.controlButtons.x = (m_rectSlide.right - this.controlButtons.width);
				this.controlButtons.y = (m_rectSlide.bottom + BORDER_WIDTH);
			}
			else
			{
				this.slideContainer.x = BORDER_WIDTH;
				this.slideContainer.y = BORDER_WIDTH;
				m_spSlideContainer.x = BORDER_WIDTH;
				m_spSlideContainer.y = BORDER_WIDTH;
				this.slideContainer.width = m_nWidth - BORDER_WIDTH * 2;
				this.slideContainer.height = m_nHeight - BORDER_WIDTH * 2;
				m_rectSlide = new Rectangle(BORDER_WIDTH, BORDER_WIDTH, m_nWidth - BORDER_WIDTH * 2,
											m_nHeight - BORDER_WIDTH * 2);
			}

			// Create the slide mask
			m_spMask.graphics.clear();
			m_spMask.graphics.beginFill(0xFF0000, 0.5);
			m_spMask.graphics.drawRect(m_rectSlide.x, m_rectSlide.y, m_rectSlide.width, m_rectSlide.height);
		}

		protected function ControlEnabled(strLayout:String, strControlId:String):Boolean
		{
			return m_oControlManager.GetLayoutControlEnabled(strLayout, strControlId);
		}
	}
}