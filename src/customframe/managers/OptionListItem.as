package customframe.managers
{
	public class OptionListItem
	{
		var m_xmlData:XML = null;
		var m_strName:String = "";
		
		public function OptionListItem(xmlData:XML) 
		{
			m_xmlData = xmlData;
		}
		
		public function get Name():String
		{
			var strResult:String = "";
			
			if (m_xmlData != null)
			{
				strResult = m_xmlData.@name;
			}
			
			return strResult;
		}
		
		public function get Value():String
		{
			var strResult:String = "";
			
			if (m_xmlData != null)
			{
				strResult = m_xmlData.@value;
			}
			
			return strResult;
		}
		
		public function get Group():String
		{
			var strResult:String = "";
			
			if (m_xmlData != null)
			{
				strResult = m_xmlData.@group;
			}
			
			return strResult;
		}
		
		public function GetPropertyValue(strPropertyName:String):String
		{
			var strResult:String = "";
			
			if (m_xmlData != null)
			{
				var xmlProperty:XML = m_xmlData.properties.property.(@name == strPropertyName)[0];
				
				if (xmlProperty != null)
				{
					strResult = xmlProperty.@value;
				}
			}
			
			return strResult;
		}
		
	}

}