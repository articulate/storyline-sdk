package customframe.managers
{
	public class OptionList
	{
		var m_xmlList:XMLList = null;
		
		public function OptionList(xmlList:XMLList) 
		{
			m_xmlList = xmlList;
		}
		
		public function get Count():int
		{
			return m_xmlList.length();
		}
		
		public function GetListItemAt(nIndex:int):OptionListItem
		{
			return new OptionListItem(m_xmlList[nIndex]);
		}
		
		public function GetListItemByName(strName:String):OptionListItem
		{
			return new OptionListItem(m_xmlList.(@name == strName)[0]);
		}
		
	}

}