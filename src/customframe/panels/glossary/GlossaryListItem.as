package customframe.panels.glossary
{
	import customframe.components.list.ListItem;

	/**
	 * GlossaryListItems are the items that display in the upper section of the Glossary. This class subclasses
	 * ListItem and merely sets a few values to customize the appearance and behavior of the glossary items.
	 */
	public class GlossaryListItem extends ListItem
	{
		public function GlossaryListItem(xmlData:XML = null)
		{
			super(xmlData);
			m_bShowHover = false;
			m_bShowSelected = true;
			m_nUpColor = 0xE6E6E6;
			m_nSelectedColor = 0xC0E2F1;
			m_nBackgroundColor = 0xE6E6E6;
		}
	}
}