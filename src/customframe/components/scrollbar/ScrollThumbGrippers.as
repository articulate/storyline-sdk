package customframe.components.scrollbar
{
	import flash.display.Sprite;
	import flash.display.DisplayObject;

	/**
	 * This is the logic for the ScrollThumbGrippers symbol in the library (/components/scrollbar/ScrollThumbGrippers.)
	 *
	 * The ScrollThumbGrippers are small rectangles didplayed on the scrollbar's thumb button. The number of
	 * grippers displayed depends on the height of the thumb button.
	 *
	 */
	public class ScrollThumbGrippers extends Sprite
	{
		public static const GRIPPER:String = "gripper";
		public static const NUM_GRIPPERS:int = 7;
		public static const GRIPPER_HEIGHT:int = 2;
		public static const GRIPPER_SPACING:int = 4;

		public var gripper1:Sprite, gripper2:Sprite, gripper3:Sprite, gripper4:Sprite, gripper5:Sprite;
		public var gripper6:Sprite, gripper7:Sprite;

		private var m_arrGrippers:Array = new Array();
		private var m_nNumVisibleGrippers:int = 0;

		public function ScrollThumbGrippers()
		{
			super();

			for (var i:int = 1; i <= NUM_GRIPPERS; ++i)
			{
				m_arrGrippers.push(this[GRIPPER + i]);
			}

			this.NumVisibleGrippers = 0;
		}

		public function get VisibleHeight():int
		{
			var nVisibleHeight:int = 0;

			if (m_nNumVisibleGrippers > 0)
			{
				nVisibleHeight = m_nNumVisibleGrippers * GRIPPER_HEIGHT + (m_nNumVisibleGrippers - 1) * GRIPPER_SPACING;
			}

			return nVisibleHeight;
		}

		public function get NumVisibleGrippers():int
		{
			return m_nNumVisibleGrippers;
		}

		public function set NumVisibleGrippers(value:int):void
		{
			value = Math.max(0, Math.min(NUM_GRIPPERS, value));
			m_nNumVisibleGrippers = value;

			for (var i:int = 0; i < NUM_GRIPPERS; ++i)
			{
				var m_oGripper:DisplayObject = m_arrGrippers[i];
				m_oGripper.visible = (i < value);
			}
		}
	}
}