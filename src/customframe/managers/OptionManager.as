package customframe.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * The OptionManager contains logic for controlling certain options on the frame. When the status of
	 * an option is changed, the OptionManager dispatches a OPTIONS_CHANGED event.
	 */
	public class OptionManager extends EventDispatcher
	{
		public static const OPTIONS_CHANGED:String = "optionsChanged";

		public static const OPTGROUP_SIDEBAR:String = "sidebaroptions";
		public static const OPTGROUP_BOTTOMBAR:String = "bottombaroptions";
		public static const OPTGROUP_CONTROLS:String = "controls";
		public static const OPTGROUP_MENUOPTIONS:String = "menuoptions";

		public static const OPTION_TITLE_ENABLED:String = "title_enabled";
		public static const OPTION_TIME_ENABLED:String = "time_enabled";
		public static const OPTION_TIME_FORMAT:String = "time_enabled.time_format";

		public static const OPTION_TITLE_TEXT:String = "title_enabled.title_text";
		public static const OPTION_LOGO_ENABLED:String = "logo_enabled";
		public static const OPTION_LOGO_URL:String = "logo_enabled.logo_url";
		public static const OPTION_INFO_ENABLED:String = "info_enabled";
		public static const OPTION_SIDEBAR_ENABLED:String = "sidebar_enabled";
		public static const OPTION_BOTTOMBAR_ENABLED:String = "bottombar_enabled";
		public static const OPTION_DEFAULT_PRESENTER_ID:String = "info_enabled.default";
		public static const OPTION_CONTROLS_ELAPSEDANDTOTALTIME:String = "elapsedandtotaltime";
		public static const OPTION_CONTROLS_ENABLEKEYBOARDSHORTCUTS:String = "enableKeyboardShortcuts";
		
		public static const OPTION_FLOW:String = "flow";
		public static const OPTION_BEHAVIOR:String = "levelbehavior";
		public static const OPTION_RESTRICTIONS:String = "levelrestriction";
		
		public static const OPTLIST_TABS:String = "tabs";
		public static const LISTGROUP_SIDEBAR:String = "sidebar";
		public static const LISTGROUP_LINKLEFT:String = "linkleft";
		public static const LISTGROUP_LINKRIGHT:String = "rightleft";

		protected var m_xmlData:XML = null;

		public function OptionManager()
		{
			super();
		}

		public function SetXMLData(xmlData:XML)
		{
			m_xmlData = xmlData.optiongroups[0];
		}

		public function UpdateOptions(strXMLData:String)
		{
			m_xmlData = new XML(strXMLData);
			dispatchEvent(new Event(OPTIONS_CHANGED));
		}

		public function GetOption(strOptionGroup:String, strOptionName:String):XML
		{
			var xmlResult:XML = null;
			var xmlOptionGroup:XML = m_xmlData.optiongroup.(@name == strOptionGroup)[0];

			if (xmlOptionGroup != null)
			{
				var arrPath:Array = strOptionName.split(".");
				var nIndex:int = 0;
				var xmlOptionList:XMLList = xmlOptionGroup.options.option;
				var xmlOption:XML = null;
				var strCurId:String = arrPath[0];

				while (nIndex < arrPath.length)
				{
					xmlOption = xmlOptionList.(@name == arrPath[nIndex])[0];

					if (xmlOption != null)
					{
						xmlOptionList = xmlOption.options.option;
					}
					nIndex ++;
				}

				xmlResult = xmlOption;

				if (xmlResult == null)
				{
					//trace("ERROR: The option '" + strOptionName + "' does not exist in the option group '" + strOptionGroup + "'");
				}
			}
			else
			{
				//trace("ERROR: The option group '" + strOptionGroup + "' does not exist.");
			}

			return xmlResult;
		}

		public function GetOptionAsBool(strOptionGroup:String, strOptionName:String, bDefault:Boolean = false):Boolean
		{
			var xmlOption:XML = GetOption(strOptionGroup, strOptionName);
			return bDefault || (xmlOption != null && xmlOption.@value == "true");
		}

		public function GetOptionAsString(strOptionGroup:String, strOptionName:String, strDefault:String = ""):String
		{
			var xmlOption:XML = GetOption(strOptionGroup, strOptionName);
			return (xmlOption != null) ? xmlOption.@value : strDefault;
		}

		public function GetOptionAsArray(strOptionGroup:String, strOptionName:String):Array
		{
			var arrResult:Array = new Array();
			var xmlOption:XML = GetOption(strOptionGroup, strOptionName);

			if (xmlOption != null)
			{
				var nCount:int = xmlOption.items.item.length();

				for (var i:int = 0; i < nCount; ++i)
				{
					arrResult.push(xmlOption.items.item[i].@name);
				}
			}

			return arrResult;
		}

		public function GetOptionProperty(strOptionGroup:String, strOptionName:String, strPropertyName:String):String
		{
			var strResult:String = ""
			var xmlOption:XML = GetOption(strOptionGroup, strOptionName);

			if (xmlOption != null)
			{
				var xmlProperties:XMLList = xmlOption.properties.property;
				var xmlProp:XML = xmlProperties.(@name == strPropertyName)[0];

				if (xmlProp)
				{
					strResult = xmlProp.@value;
				}
				else
				{
					//trace("ERROR: The option property '" + strPropertyName + "' does not exist in the option '" + strOptionGroup + " : " + strOptionName + "'");
				}
			}

			return strResult;
		}
		
		public function GetOptionList(strOptionGroup:String, strListName:String, strListGroup:String = ""):OptionList
		{
			var xmlResult:XMLList = null;
			var xmlOptionGroup:XML = m_xmlData.optiongroup.(@name == strOptionGroup)[0];
			
			if (xmlOptionGroup != null)
			{
				var xmlOptionList:XML = xmlOptionGroup.options.optionlist.(@name == strListName)[0];
				
				if (xmlOptionList)
				{
					if (strListGroup != "")
					{
						xmlResult = xmlOptionList.listitems.children().(@group == strListGroup);
					}
					else
					{
						xmlResult = xmlOptionList.listitems.children();
					}
				}
				else
				{
					//trace("WARNING: The option list '" + strListName + "' does not exist in the option group '" + strOptionGroup + "'");
				}
			}
			else
			{
				//trace("WARNING: The option group '" + strOptionGroup + "' does not exist.");
			}
			
			return new OptionList(xmlResult);
		}
	}
}