package com.articulate.wg.v3_0
{
	import flash.events.IEventDispatcher;

	/**
	 * wgISlide is the interface implemented by slides within by the Articulate player. It offers properties and methods
	 * for getting information about the slide. It also allows the frame to control playback on the slide.
	 */
	public interface wgISlide extends IEventDispatcher
	{
		/**
		 * The id of the slide.
		 */
		function get Id():String;
		/**
		 * The absolute id of the slide. An absolute id is a string containing the ids of
		 * the slide's ancester containers. It is in the form:
		 * <i>[GRANDPARENT CONTAINER ID].[PARENT CONTAINER ID].[SLIDE DRAW ID]</i>.
		 */
		function get AbsoluteId():String;
		/**
		 * The title of the slide.
		 */
		function get Title():String;
		/**
		 * Whether or not the user has viewed the slide.
		 */
		function get Viewed():Boolean;

		/**
		 * Whether to show a node for the slide in the menu tree.
		 */
		function get ShowInMenu():Boolean;
		/**
		 * Whether to show a result icon for the slide in the menu tree.
		 */
		function get ShowMenuResultIcon():Boolean;

		/**
		 * The height of the slide in pixels.
		 */
		function get height():Number;
		/**
		 * The width of the slide in pixels.
		 */
		function get width():Number;

		/**
		 * For quiz slides only: the points awarded for the slide.
		 */
		function get PointsAwarded():Number;
		/**
		 * For quiz slides only: has the user answered the question on the slide?
		 */
		function get Answered():Boolean;
		/**
		 * For quiz slides only: the status of the slide.
		 * Possible values are: <i>correct</i>, <i>incorrect</i>, <i>incomplete</i> or <i>neutral</i>.
		 */
		function get Status():String;
		/**
		 * For quiz slides only: the maximum number of points that can be earned on the slide.
		 */
		function get MaxPoints():Number;

		/**
		 * Returns true if the slide belongs to a slide bank. Returns false if not.
		 * @return
		 */
		function IsSlideBankSlide():Boolean;

		/**
		 * Returns true if the slide has any interactions. Returns false if not.
		 * @return
		 */
		function get HasInteractions():Boolean;
		/**
		 * The start time of the slide in milliseconds.
		 */
		function get StartTime():Number;
		/**
		 * Returns true if the slide is locked. Returns false if not.
		 * @return
		 */
		function get SlideLock():Boolean;
	}
}