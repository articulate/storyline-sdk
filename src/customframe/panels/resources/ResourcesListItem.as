package customframe.panels.resources
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;

	import customframe.components.list.ListItem;

	/**
	 * ResourcesListItem are the items that display in the Resources panel. They load images and display text.
	 *
	 */
	public class ResourcesListItem extends ListItem
	{
		public static const URL:String = "url";
		public static const IMAGE:String = "image";

		protected var m_strImage:String = "";
		protected var m_ldrImage:Loader = null;

		public function ResourcesListItem(xmlData:XML = null)
		{
			super(xmlData);
			m_nUpColor = 0xF3F3F3;
			m_bShowHover = true;
			m_bShowSelected = false;
			this.textField.x = 22;
		}

		override public function Redraw():void
		{
			super.Redraw();
			this.textField.width = m_nWidth - 32;
		}

		override public function SetXMLData(xmlData:XML):void
		{
			super.SetXMLData(xmlData);
			m_strData = m_xmlData.attribute(URL);
			m_strImage = m_xmlData.attribute(IMAGE);
			m_ldrImage = new Loader();

			m_ldrImage.contentLoaderInfo.addEventListener(Event.COMPLETE, CompleteHandler);
			m_ldrImage.load(new URLRequest(m_strImage));
		}

		protected function CompleteHandler(evt:Event):void
		{
			m_ldrImage.contentLoaderInfo.removeEventListener(Event.COMPLETE, CompleteHandler);
			addChild(m_ldrImage);
			m_ldrImage.content.y = int((this.height - m_ldrImage.content.height) / 2) - 1;
			m_ldrImage.content.x = int((20 - m_ldrImage.content.width) / 2);
		}
	}
}