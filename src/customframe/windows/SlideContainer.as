package customframe.windows
{
	import flash.display.Sprite;
	import flash.display.Shape;

	/**
	 * This is the logic for the SlideContainer symbol in the library (/windows/SlideContainer.)
	 *
	 * The SlideContainer is the rectangular container that the Articulate player uses as the parent for the
	 * current slide. It has a mask which is equal to its dimensions.
	 *
	 */
	public class SlideContainer extends Sprite
	{
		public var background:Sprite;

		protected var m_shMask:Shape = new Shape();

		public function SlideContainer()
		{
			super();
			addChild(m_shMask);
			this.mask = m_shMask;
			DrawMask();
		}

		override public function get width():Number
		{
			return this.background.width;
		}
		override public function set width(value:Number):void
		{
			if (this.background.width != value)
			{
				this.background.width = value;
				DrawMask();
			}
		}

		override public function get height():Number
		{
			return this.background.height;
		}
		override public function set height(value:Number):void
		{
			if (this.background.height != value)
			{
				this.background.height = value;
				DrawMask();
			}
		}

		protected function DrawMask():void
		{
			m_shMask.graphics.clear();
			m_shMask.graphics.beginFill(0xFF0000, 1);
			m_shMask.graphics.drawRect(0, 0, this.background.width, this.background.height);
			m_shMask.graphics.endFill();
		}
	}
}