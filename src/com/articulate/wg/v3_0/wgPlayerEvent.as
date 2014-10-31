package com.articulate.wg.v3_0
{
	import com.articulate.wg.v3_0.wgISlide;
	import com.articulate.wg.v3_0.wgISlideDraw;

	import flash.events.Event;

	/**
	 * Represents events that are related to the player.
	 */
	public class wgPlayerEvent extends Event
	{
		/**
		 * The <i>SLIDE_TRANSITION_OUT</i> constant defines the value of the <i>type</i> property of the
		 * event that is dispatched when a slide has completed transitioning out.
		 */
		public static const SLIDE_TRANSITION_OUT:String = "bw_slide_transition_out";
		/**
		 * The <i>SLIDE_TRANSITION_IN</i> constant defines the value of the <i>type</i> property of the
		 * event that is dispatched when a slide has completed transitioning in.
		 */
		public static const SLIDE_TRANSITION_IN:String = "bw_slide_transition_in";
		/**
		 * The <i>SLIDEDRAW_UPDATE</i> constant defines the value of the <i>type</i> property of the
		 * event that is dispatched when a slide draw is changed.
		 */
		public static const SLIDEDRAW_UPDATE:String = "bw_slidedraw_update";
		/**
		 * The <i>VOLUME_CHANGED</i> constant defines the value of the <i>type</i> property of the
		 * event that is dispatched when the volume is changed.
		 */
		public static const VOLUME_CHANGED:String = "bw_volume_changed";
		/**
		 * The <i>RESUME_PLAYER</i> constant defines the value of the <i>type</i> property of the
		 * event that is dispatched when playback is resumed.
		 */
		public static const RESUME_PLAYER:String = "bw_resume_player";
		/**
		 * The <i>ACTIONLINK_SELECTED</i> constant defines the value of the <i>type</i> property of the
		 * event that is dispatched when an action link is selected in the player.
		 */
		public static const ACTIONLINK_SELECTED:String = "bw_actionlink_selected";
		/**
		 * The <i>INTERACTION_EVALUATED</i> constant defines the value of the <i>type</i> property of the
		 * event that is dispatched when an interaction is evaluated.
		 */
		public static const INTERACTION_EVALUATED:String = "bw_interaction_Evaluated";

		protected var m_oSlide:wgISlide = null;
		protected var m_oSlideDraw:wgISlideDraw = null;
		protected var m_nVolume:int = 100;
		protected var m_strData:String = "";

		/**
		 * @param type The type of the event, accessible as <i>wgEventFrame.type</i>.
		 * @param scrubtime The slide (if any) connected to the event.
		 * @param bubbles Determines whether the Event object participates in the bubbling stage of the event flow.
		 * The default value is false.
		 * @param cancelable Determines whether the Event object can be canceled. The default values is false.
		 */
		public function wgPlayerEvent(type:String, slide:wgISlide = null, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			m_oSlide = slide;
			super(type, bubbles, cancelable);
		}

		/**
		 * @private
		 */
		public override function clone():Event
		{
			var evt:wgPlayerEvent =  new wgPlayerEvent(type, m_oSlide, bubbles, cancelable);
			evt.SlideDraw = m_oSlideDraw;
			evt.Volume = m_nVolume;
			return evt;
		}

		/**
		 * @private
		 */
		public override function toString():String
		{
			return formatToString("wgPlayerEvent", "type", "bubbles", "cancelable", "eventPhase");
		}

		/**
		 * The slide (if any) connected to the event. If no slide is connected to the event, is <i>null</i>.
		 */
		public function get Slide():wgISlide
		{
			return m_oSlide;
		}

		/**
		 * The slide draw (if any) connected to the event. If no slide draw is connected to the event, is <i>null</i>.
		 */
		public function get SlideDraw():wgISlideDraw
		{
			return m_oSlideDraw;
		}
		public function set SlideDraw(value:wgISlideDraw):void
		{
			m_oSlideDraw = value;
		}

		/**
		 * The player's audio volume in the range 0-100.
		 */
		public function get Volume():int
		{
			return m_nVolume;
		}
		public function set Volume(value:int):void
		{
			m_nVolume = value;
		}

		/**
		 * A data string.
		 */
		public function get Data():String
		{
			return m_strData;
		}
		public function set Data(value:String):void
		{
			m_strData = value;
		}
	}

}