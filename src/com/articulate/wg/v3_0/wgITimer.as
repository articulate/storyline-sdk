package com.articulate.wg.v3_0
{
	/**
	 * A wgITimer is an object that the frame can consult to get the elapsed time and duration of a quiz.
	 */
	public interface wgITimer
	{
		/**
		 * The duration of the quiz in milliseconds.
		 */
		function get Duration():int
		/**
		 * The time that has elapsed for the quiz in milliseconds.
		 */
		function get ElapsedTime():int
	}
}