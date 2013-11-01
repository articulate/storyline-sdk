package customframe.panels.glossary
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	import customframe.base.SizingSprite;
	import customframe.components.list.List;
	import customframe.components.list.ListEvent;
	import customframe.components.text.ScrollingTextField;

	/**
	 * This is the logic for the Glossary symbol in the library (/panels/glossary/Glossary.)
	 *
	 * The Glossary is a visual panel with two sections. The top section contains a list of terms. The bottom
	 * section contains a ScrollingTextField for displaying the definition of a word when the user clicks on it.
	 *
	 */
	public class Glossary extends SizingSprite
	{
		public static const DEFAULT_WIDTH:int = 220;
		public static const DEFAULT_HEIGHT:int = 298;
		public static const VERTICAL_GAP:int = 27;
		public static const TOP_MARGIN:int = 6;
		public static const TERMS_MARGIN:int = 4;
		public static const DEFINITION_MARGIN:int = 9;

		public var termsList:List;
		public var termsLabel:TextField;
		public var termsRectangle:Sprite;
		public var definitionLabel:TextField;
		public var definitionRectangle:Sprite;
		public var definitionText:ScrollingTextField;

		private var m_xmlData:XML = null;

		private var m_bOverlayView:Boolean = false;
		private var m_nTabHeight:Number = 30;

		public function Glossary()
		{
			super();
			m_nWidth = DEFAULT_WIDTH;
			m_nHeight = DEFAULT_HEIGHT;
			this.termsList.addEventListener(ListEvent.ITEM_CLICKED, TermsList_onItemClicked);
			CreateListItems();
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

			this.termsLabel.y = nTabHeight + TOP_MARGIN;
			this.termsRectangle.y = this.termsList.y = this.termsLabel.y + VERTICAL_GAP;
			this.termsRectangle.height = nTabHeight + nMainHeight / 2 - this.termsRectangle.y;
			this.termsRectangle.width = this.width;
			this.termsList.height = this.termsRectangle.height;
			this.termsList.width = this.width - TERMS_MARGIN * 2;

			this.definitionLabel.y = this.termsRectangle.y + this.termsRectangle.height + TOP_MARGIN;
			this.definitionRectangle.width = this.width;
			this.definitionRectangle.y = this.definitionText.y = this.definitionLabel.y + VERTICAL_GAP;
			this.definitionRectangle.height = nTabHeight + nMainHeight - this.definitionRectangle.y;
			this.definitionText.height = this.definitionRectangle.height;
			this.definitionText.width = this.width - DEFINITION_MARGIN * 2;
		}

		override public function Redraw():void
		{
			super.Redraw();
			Refresh();
		}

		public function Update(xmlData:XML):void
		{
			m_xmlData = xmlData;
			this.termsList.RemoveAll();
			this.definitionText.Text = "";
			CreateListItems();
		}

		protected function CreateListItems():void
		{
			if (m_xmlData != null)
			{
				var xmlTerms:XMLList = m_xmlData.terms.term;
				var nLength:int = xmlTerms.length();

				for (var i:int = 0; i < nLength; ++i)
				{
					var oListItem:GlossaryListItem = new GlossaryListItem(xmlTerms[i]);
					this.termsList.AddListItem(oListItem);
				}
			}
		}

		protected function TermsList_onItemClicked(evt:ListEvent):void
		{
			this.definitionText.HtmlText = evt.Item.Data;
			this.definitionText.ScrollTo(0);
		}
	}
}