package customframe.components.timer
{
	import com.articulate.wg.v3_0.wgITimer;

	import flash.events.Event;
	import flash.text.TextField;

	import customframe.base.CustomSprite;
	import customframe.Utils;

	/**
	 * This is the logic for the CustomTimer symbol in the library (/components/timer/CustomTimer.)
	 *
	 * The CustomTimer contains a circular clock and a text field. The clock and text field are updated based on
	 * a wgITimer object passed from the Articulate player through the frame.
	 *
	 */
	public class CustomTimer extends CustomSprite
	{
		private const CLOCK_RADIUS:int = 10;

		private const TIME_FORMAT_REMAINING:String = "remaining";
		private const TIME_FORMAT_TOTAL_ELAPSED:String = "totalelapsed";
		private const TIME_FORMAT_ELAPSED:String = "elapsed";
		private const TIME_FORMAT_NONE:String = "none";

		public var clock:Clock;
		public var timeField:TextField;

		private var m_nLastElapsed:Number = -1;
		private var m_arrTimers:Array = new Array();
		private var m_strTimeFormat:String = "";

		public function CustomTimer()
		{
			super();
			this.width = CLOCK_RADIUS * 2;
			this.height = CLOCK_RADIUS * 2;
			Redraw();
		}

		public function get TimeFormat():String
		{
			return m_strTimeFormat;
		}
		public function set TimeFormat(value:String):void
		{
			m_strTimeFormat = value;
		}

		public function get ElapsedTime():int
		{
			return this.clock.ElapsedTime;
		}
		public function set ElapsedTime(value:int):void
		{
			this.clock.ElapsedTime = value;
		}

		public function get Duration():int
		{
			return this.clock.Duration;
		}
		public function set Duration(value:int):void
		{
			this.clock.Duration = value;
		}

		override public function Redraw():void
		{
			super.Redraw();
			if (this.TimerCount > 0)
			{
				this.clock.visible = true;
				this.timeField.visible = true;
				UpdateTimer();
			}
			else
			{
				this.clock.visible = false;
				this.timeField.visible = false;
			}
		}

		public function SetTimeText(nElapsed:int, nDuration:int):void
		{
			var nTicks:int = Math.floor(nElapsed / 1000);

			if (m_nLastElapsed != nTicks)
			{
				m_nLastElapsed = nTicks;
				var strTime:String = "";

				switch (m_strTimeFormat)
				{
					case TIME_FORMAT_REMAINING:
					{
						strTime = Utils.GetTimeString(nDuration - nElapsed, false);
						break;
					}
					case TIME_FORMAT_TOTAL_ELAPSED:
					{
						strTime = Utils.GetTimeString(nElapsed) + " / " + Utils.GetTimeString(nDuration);
						break;
					}
					case TIME_FORMAT_ELAPSED:
					{
						strTime = Utils.GetTimeString(nElapsed);
						break;
					}
				}

				this.timeField.text = strTime;
			}
		}

		public function get TimerCount():int
		{
			return m_arrTimers.length;
		}

		public function AddTimer(oTimer:wgITimer):void
		{
			var index:int = m_arrTimers.indexOf(oTimer);

			if (index == -1)
			{
				m_arrTimers.push(oTimer);
				addEventListener(Event.ENTER_FRAME, UpdateTimer);
				QueueRedraw();
			}
		}

		public function RemoveTimer(oTimer:wgITimer):void
		{
			var index:int = m_arrTimers.indexOf(oTimer);

			if (index != -1)
			{
				m_arrTimers.splice(index, 1);

				if (this.TimerCount < 1)
				{
					removeEventListener(Event.ENTER_FRAME, UpdateTimer);
					QueueRedraw();
				}
			}
		}

		public function UpdateTimer(evt:Event = null):void
		{
			if (m_arrTimers.length > 0)
			{
				var oTimer:wgITimer = m_arrTimers[0];
				this.clock.ElapsedTime =  oTimer.ElapsedTime;
				this.clock.Duration = oTimer.Duration;
				SetTimeText(oTimer.ElapsedTime, oTimer.Duration);
			}
		}
	}
}