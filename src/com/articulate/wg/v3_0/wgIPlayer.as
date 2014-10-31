package com.articulate.wg.v3_0
{
	import flash.events.IEventDispatcher;

	/**
	 * This is the Interface that the Articulate player implements.
	 */
	public interface wgIPlayer extends IEventDispatcher
	{
		/**
		 * @private
		 */
		function debug_trace(strMessage:String):void
		/**
		 * Get a wgITLFFactory to use for generating flash.text.TLFTextFields. (Only used to support right-to-left text.)
		 * @return
		 */
		function GetTLFFactory():wgITLFFactory
		/**
		 * @private
		 */
		function PreviewMode():Boolean
		/**
		 * Show or hide the lock cursor.
		 */
		function ShowLockCursor(bShow:Boolean):void;

		/**
		 * Get the duration of the current lesson.
		 * @return The duration of the current lesson.
		 */
		function get LessonDuration():Number;
	}
}