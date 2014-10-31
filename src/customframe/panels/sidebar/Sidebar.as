package customframe.panels.sidebar
{
	import com.articulate.wg.v3_0.wgISlide;
	import com.articulate.wg.v3_0.wgPlayerEvent;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import customframe.Frame;
	import customframe.managers.OptionManager;
	import customframe.panels.glossary.Glossary;
	import customframe.panels.menu.Menu;
	import customframe.panels.notes.Notes;

	/**
	 * This is the logic for the Sidebar symbol in the library (/panels/sidebar/Sidebar.)
	 *
	 * The Sidebar contains the Menu tree, Glossary and Notes panel. It has tabs for each of these. WHen the user
	 * clicks on a tab, the corresponding panel is displayed.
	 *
	 */
	public class Sidebar extends Sprite
	{
		public static const TAB_HEIGHT:int = 30;
		public static const DEFAULT_HEIGHT:int = 646;

		public var background:Sprite;
		public var menu:Menu;
		public var menuTabLabel:SimpleButton;
		public var menuTab:Sprite;
		public var glossary:Glossary;
		public var glossaryTab:Sprite;
		public var glossaryTabLabel:SimpleButton;
		public var notes:Notes;
		public var notesTab:Sprite;
		public var notesTabLabel:SimpleButton;

		public function Sidebar()
		{
			super();
			HideNotes();
			HideGlossary();
			ShowMenu();
			this.menuTabLabel.addEventListener(MouseEvent.CLICK, MenuTabLabel_onClick);
			this.glossaryTabLabel.addEventListener(MouseEvent.CLICK, GlossaryTabLabel_onClick);
			this.notesTabLabel.addEventListener(MouseEvent.CLICK, NotesTabLabel_onClick);
		}

		public function set CurrentSlide(value:wgISlide):void
		{
			this.menu.CurrentSlide = value;
		}

		override public function set y(value:Number):void
		{
			if (super.y != value)
			{
				super.y = value;
				this.height = DEFAULT_HEIGHT - value;
			}
		}

		override public function get width():Number
		{
			return this.background.width;
		}

		override public function get height():Number
		{
			return this.background.height + this.menuTab.height;
		}

		override public function set height(value:Number):void
		{
			var nTabHeight:Number = this.menuTab.height;
			this.background.y = nTabHeight;
			var nMainHeight:Number = value - nTabHeight;
			this.background.height = nMainHeight;
			this.menu.height = nMainHeight;
			this.glossary.height = nMainHeight;
			this.notes.height = nMainHeight;
		}

		public function get CustomFrame():Frame
		{
			return Menu(this.menu).CustomFrame;
		}

		public function set CustomFrame(value:Frame):void
		{
			Menu(this.menu).CustomFrame = value;
		}

		public function SelectMenu():void
		{
			this.menuTab.visible = true;
			this.menu.visible = true;
			this.menu.Refresh(this.menuTab.height, this.background.height);
		}

		public function DeselectMenu():void
		{
			this.menuTab.visible = false;
			this.menu.visible = false;
		}

		public function ShowMenu():void
		{
			DeselectGlossary();
			DeselectNotes();
			SelectMenu();
			this.menuTabLabel.visible = true;
		}

		public function HideMenu():void
		{
			DeselectMenu();
			this.menuTabLabel.visible = true;
		}

		public function UpdateMenu(xmlData:XML, oOptionManager:OptionManager):void
		{
			this.menu.Update(xmlData, oOptionManager);
		}

		public function ShowGlossary():void
		{
			DeselectMenu();
			DeselectNotes();
			SelectGlossary();
			this.glossaryTabLabel.visible = true;
		}

		public function HideGlossary():void
		{
			DeselectGlossary();
			this.glossaryTabLabel.visible = false;
		}

		public function SelectGlossary():void
		{
			this.glossaryTab.visible = true;
			this.glossary.visible = true;
			this.glossary.Refresh(this.menuTab.height, this.background.height);
		}

		public function DeselectGlossary():void
		{
			this.glossaryTab.visible = false;
			this.glossary.visible = false;
		}

		public function UpdateGlossary(xmlData:XML):void
		{
			this.glossary.Update(xmlData);
		}

		public function SelectNotes():void
		{
			this.notesTab.visible = true;
			this.notes.visible = true;
			this.notes.Refresh(this.menuTab.height, this.background.height);
		}

		public function DeselectNotes():void
		{
			this.notesTab.visible = false;
			this.notes.visible = false;
		}

		public function ShowNotes():void
		{
			DeselectMenu();
			DeselectGlossary();
			SelectNotes();
			this.notesTabLabel.visible = true;
			if (this.notes.height != this.background.height)
			{
				this.notes.height = this.background.height;
			}
		}

		public function HideNotes():void
		{
			DeselectNotes();
			this.notesTabLabel.visible = false;
		}

		public function UpdateNotes(strTitle:String, strContent:String):void
		{
			this.notes.Update(strTitle, strContent);
		}

		protected function MenuTabLabel_onClick(evt:MouseEvent):void
		{
			DeselectNotes();
			DeselectGlossary();
			SelectMenu();
		}

		protected function GlossaryTabLabel_onClick(evt:MouseEvent):void
		{
			DeselectMenu();
			DeselectNotes();
			ShowGlossary();
		}

		protected function NotesTabLabel_onClick(evt:MouseEvent):void
		{
			DeselectMenu();
			DeselectGlossary();
			SelectNotes();
		}
	}
}