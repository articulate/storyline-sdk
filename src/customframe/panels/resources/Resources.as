package customframe.panels.resources
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import com.articulate.wg.v3_0.*;

	import customframe.components.list.ListEvent;

	/**
	 * This is the logic for the Resources symbol in the library (/panels/resources/Resources.)
	 *
	 * The Resources popup displays a list of resource items when the user clicks on the tab.
	 *
	 */
	public class Resources extends Sprite
	{
		private const MARGIN_TEXT_BOTTOM:int = 9;
		private const MARGIN_SEPARATOR_LEFT:int = 10;
		private const MARGIN_SEPARATOR_RIGHT:int = 10;
		private const MARGIN_TEXT_LEFT:int = 8;
		private const MARGIN_TOP:int = 10;

		private const LIST_WIDTH:int = 270;
		private const LIST_HEIGHT:int = 360;

		private const BLANK_TARGET:String = "_blank";

		public var label:SimpleButton;
		public var panel:ResourcesPanel;

		private var m_xmlData:XML = null;
		private var m_nListWidth:int = 0;
		private var m_bOverlayView:Boolean = false;

		public function Resources()
		{
			super();
			addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);

			this.label.addEventListener(MouseEvent.CLICK, Label_onClick);

			this.panel.visible = false;
			this.panel.list.width = LIST_WIDTH;
			this.panel.list.height = LIST_HEIGHT;
			this.panel.list.addEventListener(ListEvent.ITEM_CLICKED, List_onItemClicked);
		}

		public function get Data():XML
		{
			return m_xmlData;
		}
		public function set Data(value:XML):void
		{
			m_xmlData = value;
			Update();
		}

		public function get OverlayView():Boolean
		{
			return m_bOverlayView;
		}
		public function set OverlayView(value:Boolean):void
		{
			if (m_bOverlayView != value)
			{
				m_bOverlayView = value;
			}
		}

		public function UpdateResourceText(strDescription:String):void
		{
			m_xmlData.@description = strDescription;
		}
		
		public function TogglePanel():void
		{
			if (this.panel.visible)
			{
				HidePanel();
			}
			else 
			{
				ShowPanel();
			}
		}

		private function Update():void
		{
			this.panel.list.RemoveAll();
			CreateListItems();
		}
		
		private function ShowPanel():void
		{
			this.panel.visible = true;
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, Stage_onMouseDown);
		}
		
		public function HidePanel():void
		{
			this.panel.visible = false;
			this.stage.removeEventListener(MouseEvent.MOUSE_DOWN, Stage_onMouseDown);
			this.label.removeEventListener(MouseEvent.CLICK, Stage_onMouseDown);
			this.label.addEventListener(MouseEvent.CLICK, Label_onClick);
		}

		protected function CreateListItems():void
		{
			var xmlResources:XMLList = m_xmlData.resources.resource;
			var nLength:int = xmlResources.length();

			for (var i:int = 0; i < nLength; ++i)
			{
				var oListItem:ResourcesListItem = new ResourcesListItem(xmlResources[i]);
				this.panel.list.AddListItem(oListItem);
			}
		}

		protected function Label_onClick(evt:MouseEvent):void
		{
			ShowPanel();
			this.label.removeEventListener(MouseEvent.CLICK, Label_onClick);
			this.label.addEventListener(MouseEvent.CLICK, Stage_onMouseDown);
		}

		protected function Stage_onMouseDown(evt:MouseEvent):void
		{
			HidePanel();
		}

		protected function OnMouseDown(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
		}

		protected function List_onItemClicked(evt:ListEvent):void
		{
			navigateToURL(new URLRequest(evt.Item.Data), BLANK_TARGET);
		}
	}
}