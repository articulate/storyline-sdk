package com.articulate.wg.v2_0
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
		 * The duration of the slide in milliseconds.
		 */
		function get Duration():int;

		/**
		 * The current position of the timeline in milliseconds.
		 */
		function get PlayHeadTime():int;

		/**
		 * Whether or not the slide's timeline is currently playing.
		 */
		function get TimelinePlaying():Boolean;

		/**
		 * Whether or not the slide's animations are playing.
		 */
		function get AnimationsPlaying():Boolean;

		/**
		 * The height of the slide in pixels.
		 */
		function get height():Number;

		/**
		 * The width of the slide in pixels.
		 */
		function get width():Number;

		/**
		 * The points currently awarded for the slide. <i>For quiz slides only.</i>
		 */
		function get PointsAwarded():Number;

		/**
		 * Has the user answered the question on the slide? <i>For quiz slides only.</i>
		 */
		function get Answered():Boolean;

		/**
		 * The status of the slide. <i>For quiz slides only.</i>
		 * Possible values are: <i>correct</i>, <i>incorrect</i>, <i>incomplete</i> or <i>neutral</i>.
		 */
		function get Status():String;

		/**
		 * The maximum number of points that can be earned on the slide. <i>For quiz slides only.</i>
		 */
		function get MaxPoints():Number;

		/**
		 * Returns true if the slide belongs to a slide bank. Returns false if not.
		 * @return
		 */
		function IsSlideBankSlide():Boolean;

		/**
		 * Set the playhead to the specified time on the slide;
		 * @param nPosition
		 */
		function SeekSlide(nPosition:int):void;

		/**
		 * Start the slide over from the beginning.
		 */
		function ReplaySlide():void;

		/**
		 * Pause all animations on the slide.
		 */
		function PauseSlideAnimations():void;

		/**
		 * Play all animations on the slide.
		 */
		function PlaySlideAnimations():void;

		/**
		 * Pause the timeline for the slide.
		 */
		function PauseTimeline():void;

		/**
		 * Start the timeline for the slide.
		 */
		function PlayTimeline():void;
	}
}