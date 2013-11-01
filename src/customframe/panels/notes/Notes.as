package customframe.panels.notes
{
	import flash.display.Sprite;

	import customframe.base.SizingSprite;
	import customframe.components.text.ScrollingTextField;
	import customframe.panels.sidebar.Sidebar;

	/**
	 * This is the logic for the Notes symbol in the library (/panels/notes/Notes.)
	 *
	 * The Notes panel displays the title of the current slide as well as additional information about the current slide.
	 *
	 */
	public class Notes extends SizingSprite
	{
		public static const DEFAULT_HEIGHT:int = 298;
		public static const CONTENT_BOTTOM_MARGIN:int = 5;
		public static const TITLE_HEIGHT:int = 20;
		public static const TITLE_MARGIN:int = 6;

		public var background:Sprite;
		public var line:Sprite;
		public var title:ScrollingTextField;
		public var content:ScrollingTextField;

		private var m_nTabHeight:Number = Sidebar.TAB_HEIGHT;

		public function Notes()
		{
			super();
			m_nHeight = DEFAULT_HEIGHT;
			this.width = parent.width;
			Refresh();
		}

		public function Refresh(nTabHeight:Number = NaN, nMainHeight:Number = NaN):void
		{
			if (isNaN(nTabHeight))
			{
				nTabHeight = m_nTabHeight;
			}
			else
			{
				m_nTabHeight = nTabHeight;
			}

			if (isNaN(nMainHeight))
			{
				nMainHeight = m_nHeight - m_nTabHeight;
			}
			else
			{
				m_nHeight = m_nHeight + m_nTabHeight;
			}
			this.width = this.parent.width;
			this.height = nMainHeight;
			this.y = nTabHeight;
			this.title.width = this.width - TITLE_MARGIN * 2;
			this.title.height = TITLE_HEIGHT;
			this.content.height = nMainHeight - this.content.y - CONTENT_BOTTOM_MARGIN;
			this.content.width = this.width;
		}

		public function Update(strTitle:String, strContent:String):void
		{
			this.title.HtmlText = strTitle;
			this.content.HtmlText = strContent;
			this.content.ScrollTo(0);
		}

		override public function get width():Number
		{
			return this.background.width;
		}
		override public function set width(value:Number):void
		{
			this.background.width = value;
		}

		override public function get height():Number
		{
			return this.background.height;
		}
		override public function set height(value:Number):void
		{
			this.background.height = value;
		}
	}
}