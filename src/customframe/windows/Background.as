package customframe.windows
{
	import flash.display.Sprite;

	/**
	 * This is the logic for the Background symbol in the library (/windows/Background.)
	 *
	 * The Background is the visual component behind the rest of the frame. It contains a gradient area which serves as
	 * the background for the Sidebar. This sidebarBackground gradient area can be hidden if the sidebar is hidden.
	 *
	 */
	public class Background extends Sprite
	{
		public var sidebarBackground:Sprite;

		public function Background()
		{
			super();
		}

		public function get SidebarBackgroundWidth():Number
		{
			return this.sidebarBackground.width;
		}

		public function get SidebarBackgroundVisible():Boolean
		{
			return this.sidebarBackground.visible;
		}
		public function set SidebarBackgroundVisible(value:Boolean):void
		{
			this.sidebarBackground.visible = value;
		}
	}
}