package customframe
{
	/**
	 * ...
	 * @author ...
	 */
	public class Utils 
	{
		
		public function Utils() 
		{
			
		}
		
		public static function GetTimeString(nMilliSeconds:Number, bRoundDown:Boolean = true ):String
		{
			var nTotalSeconds:int = 0;
			
			if (bRoundDown)
			{
				nTotalSeconds = Math.floor(nMilliSeconds / 1000);
			}
			else
			{
				nTotalSeconds = Math.ceil(nMilliSeconds / 1000);
			}
			var nTotalMinutes:int = Math.floor(nTotalSeconds / 60);
			var nHours:int = Math.floor(nTotalMinutes / 60);
			var nMinutes:int = Math.floor(nTotalMinutes - (nHours * 60));
			var nSeconds:int = Math.floor(nTotalSeconds - (nTotalMinutes * 60));
			var strHours:String = nHours + "";
			var strMin:String = nMinutes + "";
			var strSec:String = nSeconds + "";
			var strRet:String = "";
			
			if (strMin.length < 2)
			{
				strMin = "0" + strMin;
			}
			if (strSec.length < 2)
			{
				strSec = "0" + strSec;
			}
			if (nHours > 0)
			{
				strRet = strHours + ":" + strMin + ":" + strSec;
			}
			else
			{
				strRet = strMin + ":" + strSec;
			}
			
			return strRet;
		}		
		
	}

}