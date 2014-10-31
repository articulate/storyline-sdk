package customframe.panels.menu
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.TextField;

	import com.articulate.wg.v3_0.*;

	import customframe.managers.OptionManager;

	/**
	 * This is the logic for the MenuPopup symbol in the library (/panels/menu/MenuPopup.)
	 *
	 * 
	 *
	 */
	public class MenuPopup extends Sprite
	{
		public static const LABEL_MENU:String = "Menu";
		public static const LABEL_QUESTION_LIST:String = "Question List";
		
		private static const TAB_MARGIN:int = 13;
		private static const NODE_MARGIN:int = 20;
		private static const PANEL_HEIGHT:int = 430;
		private static const PANEL_WIDTH:int = 300;
		
		public var label:SimpleButton;
		public var panel:MenuPanel;
		public var labelText:TextField;

		public function MenuPopup()
		{
			super();
			
			this.panel.visible = false;
			
			addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			this.label.addEventListener(MouseEvent.CLICK, Label_onClick);
			
			this.panel.menu.height = PANEL_HEIGHT;
			this.panel.menu.width = PANEL_WIDTH;
		}
		
		public function UpdateMenu(xmlData:XML, oOptionManager:OptionManager):void
		{
			this.panel.menu.Update(xmlData, oOptionManager);
		}
		
		public function UpdateLabel(labelText:String):void
		{
			this.labelText.text = labelText;
			this.panel.tab.width = this.labelText.textWidth + TAB_MARGIN;
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
	}
}