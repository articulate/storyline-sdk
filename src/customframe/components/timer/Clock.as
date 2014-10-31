package customframe.components.timer
{
	import flash.display.Sprite;

	import com.articulate.wg.v3_0.wgITimer;

	import customframe.base.CustomSprite;

	/**
	 * This is the logic for the Clock symbol in the library (/components/timer/Clock.)
	 *
	 * The Clock is a circle with 60 "pie" slices that are shown or hudded based on the ElapsedTime and
	 * Duration properties. The CustomTimer sets these properties.
	 *
	 */
	public class Clock extends CustomSprite implements wgITimer
	{
		public static const MINUTE:String = "Minute";
		public static const NUM_MINUTES:int = 60;

		public var Minute1:Sprite,  Minute2:Sprite,  Minute3:Sprite,  Minute4:Sprite,  Minute5:Sprite;
		public var Minute6:Sprite,  Minute7:Sprite,  Minute8:Sprite,  Minute9:Sprite,  Minute10:Sprite;
		public var Minute11:Sprite, Minute12:Sprite, Minute13:Sprite, Minute14:Sprite, Minute15:Sprite;
		public var Minute16:Sprite, Minute17:Sprite, Minute18:Sprite, Minute19:Sprite, Minute20:Sprite;
		public var Minute21:Sprite, Minute22:Sprite, Minute23:Sprite, Minute24:Sprite, Minute25:Sprite;
		public var Minute26:Sprite, Minute27:Sprite, Minute28:Sprite, Minute29:Sprite, Minute30:Sprite;
		public var Minute31:Sprite, Minute32:Sprite, Minute33:Sprite, Minute34:Sprite, Minute35:Sprite;
		public var Minute36:Sprite, Minute37:Sprite, Minute38:Sprite, Minute39:Sprite, Minute40:Sprite;
		public var Minute41:Sprite, Minute42:Sprite, Minute43:Sprite, Minute44:Sprite, Minute45:Sprite;
		public var Minute46:Sprite, Minute47:Sprite, Minute48:Sprite, Minute49:Sprite, Minute50:Sprite;
		public var Minute51:Sprite, Minute52:Sprite, Minute53:Sprite, Minute54:Sprite, Minute55:Sprite;
		public var Minute56:Sprite, Minute57:Sprite, Minute58:Sprite, Minute59:Sprite, Minute60:Sprite;

		private var m_nMinute:int = -1;
		private var m_nElapsed:int = 0;
		private var m_nDuration:int = 1;

		public function Clock()
		{
			super();
			m_nMinute = 0;
			Redraw();
		}

		public function get ElapsedTime():int
		{
			return m_nElapsed;
		}
		public function set ElapsedTime(value:int):void
		{
			m_nElapsed = value;
			QueueRedraw();
		}

		public function get Duration():int
		{
			return m_nDuration;
		}
		public function set Duration(value:int):void
		{
			m_nDuration = value;
			QueueRedraw();
		}

		override public function Redraw():void
		{
			super.Redraw();
			var nNewMinute:int = NUM_MINUTES - Math.round((m_nElapsed / m_nDuration) * NUM_MINUTES);

			if (nNewMinute != m_nMinute)
			{
				m_nMinute = nNewMinute;
				for (var i:int = 1; i <= NUM_MINUTES; ++i)
				{
					var oMinute:Sprite = this[MINUTE + i];
					oMinute.visible = i <= m_nMinute;
				}
			}
		}
	}
}