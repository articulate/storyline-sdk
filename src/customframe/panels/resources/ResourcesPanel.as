package customframe.panels.resources
{
	import flash.display.Sprite;
	import flash.text.TextField;

	import customframe.components.list.List;

	/**
	 * This is the logic for the ResourcesPanel symbol in the library (/panels/resources/ResourcesPanel.)
	 *
	 * The ResourcesPanel contains a list that is populated with ResourcelistItems.
	 *
	 */
	public class ResourcesPanel extends Sprite
	{
		public var headline:TextField;
		public var background:Sprite;
		public var tab:Sprite;
		public var list:List;

		public function ResourcesPanel()
		{
			super();
		}
	}
}