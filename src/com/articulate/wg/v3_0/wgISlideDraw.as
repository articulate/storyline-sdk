package com.articulate.wg.v3_0
{
	import flash.events.IEventDispatcher;

	/**
	 * A wgISlideDraw is a collection of <i>wgISlide objects</i> that can be accessed at random.
	 */
	public interface wgISlideDraw extends IEventDispatcher
	{
		/**
		 * The id of the slide draw.
		 */
		function get Id():String;
		/**
		 * The absolute id of the slide draw. An absolute id is a string containing the ids of
		 * the slide draw's ancester containers. It is in the form:
		 * <i>[GRANDPARENT CONTAINER ID].[PARENT CONTAINER ID].[SLIDE DRAW ID]</i>.
		 */
		function get AbsoluteId():String;
		/**
		 * The number of slides in the slide draw.
		 */
		function get SlideCount():int;

		/**
		 * Returns the <i>wgISlide</i> object at the specified index. If the index is out of bounds for the slide draw,
		 * returns <i>null</i>.
		 * @param nIndex The index of the desired slide. The valid range is from 0 to one less than the slide count.
		 * @return
		 */
		function GetSlideAtIndex(nIndex:int):wgISlide;
	}
}