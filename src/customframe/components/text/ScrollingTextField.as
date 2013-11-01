package customframe.components.text
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.*;

	import customframe.base.SizingSprite;
	import customframe.components.scrollbar.CustomScrollbar;
	import customframe.components.scrollbar.ScrollbarEvent;

	/**
	 * This is the logic for the ScrollingTextField symbol in the library (/components/text/ScrollingTextField.)
	 *
	 * The ScrollingTextField contains a Flash TextField connected to a CustomScrollbar. It handles the logic for
	 * displaying text in the tect field that may need scrolling.
	 *
	 */
	public class ScrollingTextField extends SizingSprite
	{
		public var field:TextField;
		public var scrollbar:CustomScrollbar;

		protected var m_nBackgroundColor:uint = 0xFFFFFF;
		protected var m_strHTMLText:String = "";
		protected var m_bAutoSize:Boolean = false;
		protected var m_bWrap:Boolean = false;
		protected var m_bTruncate:Boolean = false;

		public function ScrollingTextField()
		{
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			this.scrollbar.addEventListener(ScrollbarEvent.SCROLLING, Scrollbar_onScrolling);
			this.field.autoSize = TextFieldAutoSize.LEFT;
		}

		public function get Text():String
		{
			return this.field.text;
		}

		public function set Text(value:String):void
		{
			if (value != this.field.text)
			{
				this.field.text = value;
				QueueRedraw();
			}
		}

		public function get HtmlText():String
		{
			return this.field.htmlText;
		}

		public function set HtmlText(value:String):void
		{
			if (value != this.field.htmlText)
			{
				m_strHTMLText = value;
				this.field.htmlText = m_strHTMLText;
				QueueRedraw();
			}
		}

		public function ScrollTo(nPos:Number):void
		{
			this.scrollbar.ScrollTo(nPos);
		}

		override public function Redraw():void
		{
			super.Redraw();
			var nWidth:int = m_nWidth;

			if (this.field.textHeight > m_nHeight)
			{
				this.scrollbar.x = m_nWidth - this.scrollbar.width;
				this.scrollbar.ContentHeight = this.field.textHeight + 15;
				nWidth = this.scrollbar.x - 1;
				this.scrollbar.visible = true;
				this.scrollbar.height = m_nHeight;
				this.field.scrollRect = new Rectangle(0, this.scrollbar.Position, nWidth, m_nHeight);
			}
			else
			{
				this.scrollbar.visible = false;
			}

			this.field.width = nWidth;
		}

		protected function onMouseWheel(evt:MouseEvent):void
		{
			if (this.stage != null)
			{
				this.scrollbar.ScrollByLines(-Math.round(evt.delta / 3));
			}
		}

		protected function Scrollbar_onScrolling(evt:ScrollbarEvent):void
		{
			this.field.scrollRect = new Rectangle(0, this.scrollbar.Position, this.scrollbar.x - 1, m_nHeight);
		}
	}
}
