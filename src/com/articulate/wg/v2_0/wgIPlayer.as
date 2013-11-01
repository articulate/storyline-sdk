package com.articulate.wg.v2_0
{
	import flash.events.IEventDispatcher;

	/**
	 * This is the Interface that the Articulate player implements.
	 */
	public interface wgIPlayer extends IEventDispatcher
	{
		/**
		 * Get a wgITLFFactory to use for generating flash.text.TLFTextFields. (Only used to support right-to-left text.)
		 * @return
		 */
		function GetTLFFactory():wgITLFFactory

		/**
		 * @private
		 */
		function debug_trace(strMessage:String):void

		/**
		 * @private
		 */
		function PreviewMode():Boolean
	}
}