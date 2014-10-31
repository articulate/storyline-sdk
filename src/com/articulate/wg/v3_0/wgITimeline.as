package com.articulate.wg.v3_0
{
	import flash.events.IEventDispatcher;

	/**
	 * wgISlide specifies the properties and methods of a timeline.
	 */
	public interface wgITimeline extends IEventDispatcher
	{
		/**
		 * Moves the playback to a specific point on the timeline.
		 * @param nPosition The position to go to in milliseconds.
		 */
		function SeekTimeline(nPosition:int):void;

		/**
		 * Start playing the timeline from the beginning.
		 */
		function ReplayTimeline():void;

		/**
		 * Pause the playback of all animations.
		 */
		function PauseAnimations(bPauseSpanningVideo:Boolean = true):void

		/**
		 * Pause all animations.
		 */
		function PlayAnimations():void;

		/**
		 * Whether or not animations are currently playing.
		 */
		function get AnimationsPlaying():Boolean;

		/**
		 * Pause the timeline.
		 */
		function PauseTimeline():void;

		/**
		 * Start the timeline from its current position.
		 */
		function PlayTimeline():void;

		/**
		 * Whether or not the timeline is currently playing.
		 */
		function get TimelinePlaying():Boolean;

		/**
		 * The duration of the timeline in milliseconds.
		 */
		function get Duration():int;

		/**
		 * The current position of the timeline in milliseconds.
		 */
		function get PlayHeadTime():int;

		/**
		 * The starting time of the timeline in milliseconds.
		 */
		function get StartTime():int;

		/**
		 * Quizzing only: The mode for displaying time in the current timer. Proper values are:
		 * <i>remaining</i>, <i>totalelapsed</i>, <i>elapsed</i> or <i>none</i>
		 */
		function get ElapsedTimeMode():String;
	}
}