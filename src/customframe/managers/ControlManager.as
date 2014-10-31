package customframe.managers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 *
	 * The ControlManager contains logic for controlling the display of individual controls on the frame.
	 * It parses an XML data object to know whether a control should be shown or hidden. When the status of
	 * a control is changed, the ControlManager dispatches a CONTROL_LAYOUT_CHANGED event.
	 */
	public class ControlManager extends EventDispatcher
	{
		public static const CONTROL_LAYOUT_CHANGED:String = "controlLayoutChanged";
		public static const STATE_ENABLED:int = 1;
		public static const STATE_VISIBILE:int = 2;

		private var m_strCurrentLayout:String = "default";

		private var m_xmlData:XML = null;

		private var m_lOverrides:Object = new Object();
		private var m_bOverridden:Boolean = false;
		private var m_bHiddenFrame:Boolean = false;

		public function SetXMLData(xmlData:XML)
		{
			m_xmlData = xmlData;
			CheckForDuplicateDefinitions();
		}

		public function CheckForDuplicateDefinitions()
		{
			var nCount:int = m_xmlData.control_layout.length();
			var xmlCurLayout:XML = null;
			var xmlCurLayoutB:XML = null;

			var bDuplicate:Boolean = true;

			for (var i:int = 0; i < nCount; i ++)
			{
				xmlCurLayout = m_xmlData.control_layout[i];

				for (var j:int = i + 1; j < nCount; ++j)
				{
					bDuplicate = true;
					xmlCurLayoutB = m_xmlData.control_layout[j];

					var nChildCount:int = xmlCurLayout.control.length();

					for (var k:int = 0; k < nChildCount; ++k)
					{
						if (xmlCurLayout.control[k].toXMLString() != xmlCurLayoutB.control[k].toXMLString())
						{
							bDuplicate = false;
							break;
						}
					}

					if (bDuplicate)
					{
						trace("ERROR: DUPLICATE LAYOUT " + xmlCurLayout.@name + " == " + xmlCurLayoutB.@name);
						break;
					}
				}
			}
		}

		public function get HiddenFrameMode()
		{
			return m_bHiddenFrame;
		}
		
		public function set HiddenFrameMode(value:Boolean)
		{
			if (m_bHiddenFrame != value)
			{
				m_bHiddenFrame = value;
				dispatchEvent(new Event(CONTROL_LAYOUT_CHANGED));
			}
		}

		public function AddControlLayout(strXMLData:String)
		{
			var xmlControlLayout:XML = new XML(strXMLData);
			var strName:String = xmlControlLayout.@name;

			m_xmlData.appendChild(xmlControlLayout);
			SetControlLayout(strName);
		}

		public function GetLayoutControlEnabled(strLayout:String, strControlId:String):Boolean
		{
			var bEnabled:Boolean = false;
			var xmlControlLayout:XML = m_xmlData.control_layout.(@name == strLayout)[0];

			if (xmlControlLayout == null)
			{
				trace("ERROR: The control layout'" + strLayout + "' does not exist.");
			}
			else
			{
				var arrPath:Array = strControlId.split(".");
				var nIndex:int = 0;
				var xmlControl:XML = xmlControlLayout;
				var strCurId:String = arrPath[0];

				bEnabled = true;

				while (bEnabled && nIndex < arrPath.length)
				{
					bEnabled = false;

					if (xmlControl)
					{
						xmlControl = xmlControl.children().(@name == arrPath[nIndex])[0];

						if (xmlControl)
						{
							bEnabled = (xmlControl.@enabled == "true");

							xmlControl = xmlControl.controls[0];
						}
					}
					else
					{
						trace("The Control '" + strControlId + "' does not exist");
						break;
					}

					nIndex ++;
					strCurId += "." + arrPath[nIndex]
				}
			}

			return bEnabled;
		}

		public function SetControlLayout(strLayout:String)
		{
			if (m_strCurrentLayout != strLayout || m_bOverridden)
			{
				m_bOverridden = false;
				m_lOverrides = new Object();

				var xmlControlLayout:XML = m_xmlData.control_layout.(@name == strLayout)[0];

				if (xmlControlLayout != null)
				{
					m_strCurrentLayout = strLayout;
				}
				else
				{
					trace("ERROR: The control layout'" + strLayout + "' does not exist.");
					m_strCurrentLayout = m_xmlData.children()[0].@name;
				}

				dispatchEvent(new Event(CONTROL_LAYOUT_CHANGED));
			}
		}

		public function EnableFrameControl(strControlName:String, bEnable:Boolean):void
		{
			var nState:int = (this.IsControlEnabled(strControlName)) ? STATE_VISIBILE : 0;
			nState += (bEnable) ? STATE_ENABLED : 0;
			
			SetControlState(strControlName, nState);
		}

		public function SetControlVisible(strControlName:String, bVisible:Boolean):void
		{
			var nState:int = (bVisible) ? STATE_VISIBILE : 0;
			nState += (IsDisabledState(strControlName)) ? 0 : STATE_ENABLED;

			SetControlState(strControlName, nState);
		}

		public function IsDisabledState(strControlName:String):Boolean
		{
			return (m_lOverrides[strControlName] != null && (m_lOverrides[strControlName] & STATE_ENABLED) == 0);
		}

		public function IsControlEnabled(strControlId:String):Boolean
		{
			var bEnabled:Boolean = true;
			
			if (m_bHiddenFrame)
			{
				bEnabled = false;
			}
			else
			{
				var arrPath:Array = strControlId.split(".");
				var nIndex:int = 0;
				var xmlControlLayout:XML = m_xmlData.control_layout.(@name == m_strCurrentLayout)[0];
				var xmlControl:XML = xmlControlLayout;
				var strCurId:String = arrPath[0];
	
				while (bEnabled && nIndex < arrPath.length)
				{
					bEnabled = false;
	
					if (xmlControl)
					{
						xmlControl = xmlControl.children().(@name == arrPath[nIndex])[0];
	
						if (xmlControl)
						{
							bEnabled = (xmlControl.@enabled == "true");
							
							if (m_lOverrides[strCurId] != null)
							{
								bEnabled = ((m_lOverrides[strCurId] & STATE_VISIBILE) > 0);
							}
							
							xmlControl = xmlControl.controls[0];
						}
					}
					else
					{
						trace("The Control '" + strControlId + "' does not exist");
						break;
					}
	
					nIndex ++;
					strCurId += "." + arrPath[nIndex]
				}
			}
			
			return bEnabled;
		}
		
		protected function SetControlState(strControlName:String, nState:int):void
		{
			if (m_lOverrides[strControlName] == null || m_lOverrides[strControlName] != nState)
			{
				m_lOverrides[strControlName] = nState;
				
				dispatchEvent(new Event(CONTROL_LAYOUT_CHANGED));
			}
		}
	}
}