package customframe.components.list
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;

	/**
	 * This is the logic for the ListItem symbol in the library (/components/list/ListItem.)
	 *
	 * ListItem objects are added to a list. They respond to mouseovers and clicks.
	 *
	 */
	public class ListItem extends ItemBase
	{
		public static const DEFAULT_WIDTH:int = 100;
		public static const DEFAULT_HEIGHT:int = 26;
		public static const TITLE:String = "title";

		public var background:SimpleButton;
		public var textField:TextField;

		protected var m_xmlData:XML = null;

		public function ListItem(xmlData:XML = null)
		{
			m_nWidth = DEFAULT_WIDTH;
			m_nHeight = DEFAULT_HEIGHT;

			super();

			if (xmlData)
			{
				SetXMLData(xmlData);
			}
		}

		public function SetXMLData(xmlData:XML):void
		{
			m_xmlData = xmlData;
			m_strTitle = m_xmlData.attribute(TITLE);
			m_strId = m_strTitle;
			m_strData = m_xmlData;
			this.textField.text = m_strTitle;
			QueueRedraw();
		}

		override public function Redraw():void
		{
			super.Redraw();
			this.background.height = m_nHeight;
			this.textField.height = m_nHeight;
			this.textField.y = int((m_nHeight - (this.textField.textHeight + 2)) / 2);
			this.background.width = m_nWidth;
			this.textField.width = m_nWidth - 20;
		}

		override protected function SetBackgroundColor(nColor:uint):void
		{
			if (m_nBackgroundColor != nColor)
			{
				m_nBackgroundColor = nColor;
				var oRGB:Object = GetRGBFromColorUint(nColor);
				this.background.transform.colorTransform = new ColorTransform(0, 0, 0, 1, oRGB.R, oRGB.G, oRGB.B, 0);
			}
		}

		protected function NotifyClicked():void
		{
			dispatchEvent(new ListEvent(ListEvent.ITEM_CLICKED, this));
		}

		override protected function OnClick(evt:MouseEvent):void
		{
			if (!m_bSelected)
			{
				NotifyClicked();
			}
			super.OnClick(evt);
		}
	}
}