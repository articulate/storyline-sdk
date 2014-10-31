package com.articulate.wg.v3_0
{
	import flash.events.Event;

	/**
	 * Represents events that are specific to a <i>frame</i> that implements the <i>wgIFrame</i> interface.
	 * In addition, a <i>wgEventFrame</i> event can be used by the frame to obtain objects from the player.
	 * In this case, after the event has been dispatched, the requested object can be accessed through the
	 * <i>ReturnData</i> property of the event.
	 */
	public class wgEventFrame extends Event
	{
		/**
		 * The <i>FRAME_READY</i> constant defines the value of the <i>type</i> property of the
		 * event that should be dispatched from the frame when it has completed its setup proceses.
		 */
		public static const FRAME_READY:String = "wg_frm_ready";
		/**
		 * The <i>GET_CURRENT_SLIDE</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to request the current slide from the player. Once the event has been dispatched
		 * by the frame, the current frame can be accessed through the <i>ReturnData</i> property of the event.
		 */
		public static const GET_CURRENT_SLIDE:String = "wg_frm_current_slide";
		/**
		 * The <i>GET_PLAYER</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to request a reference to the player. Once the event has been dispatched
		 * by the frame, the player can be accessed through the <i>ReturnData</i> property of the event.
		 */
		public static const GET_PLAYER:String = "wg_frm_get_player";
		/**
		 * The <i>GET_SLIDEDRAW</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to request a slide draw from the player. The <i>Id</i> property of the event
		 * should be set to the the id of the desired slide draw. Once the event has been dispatched
		 * by the frame, the slide draw can be accessed through the <i>ReturnData</i> property of the event.
		 */
		public static const GET_SLIDEDRAW:String = "wg_frm_get_slidedraw";
		/**
		 * The <i>GET_SLIDE</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to request a slide from the player. The <i>Id</i> property of the event
		 * should be set to the the id of the desired slide. Once the event has been dispatched
		 * by the frame, the slide can be accessed through the <i>ReturnData</i> property of the event.
		 */
		public static const GET_SLIDE:String = "wg_frm_get_slide";
		/**
		 * The <i>GET_SLIDEBANK_SLIDE</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to request a slidebank slide from the player. Once the event has been dispatched
		 * by the frame, the slide can be accessed through the <i>ReturnData</i> property of the event.
		 */
		public static const GET_SLIDEBANK_SLIDE:String = "wg_frm_get_slidebank_slide";
		/**
		 * The <i>GOTO_SLIDE</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to tell the player to go to a specific slide. The <i>Id</i> property of the event
		 * should be set to the the ID of the desired slide.
		 */
		public static const GOTO_SLIDE:String = "wg_frm_goto_slide";
		/**
		 * The <i>SLIDE_RECT_CHANGED</i> constant defines the value of the <i>type</i> property of an event that
		 * should be dispatched by the frame whenever the rect of the slide display area has changed.
		 */
		public static const SLIDE_RECT_CHANGED:String = "wg_frm_slide_rect_changed";
		/**
		 * The <i>TRIGGER_CUSTOM_EVENT</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to have the player dispatch a custom event. The <i>Id</i> property of the event
		 * should be set to the string value of the desired event type.
		 */
		public static const TRIGGER_CUSTOM_EVENT:String = "wg_custom_event";
		/**
		 * The <i>VOLUME_CHANGED</i> constant defines the value of the <i>type</i> property of an event that
		 * should be dispatched by the frame whenever the volume has been changed through user interaction.
		 */
		public static const VOLUME_CHANGED:String = "wg_frm_volume_changed";
		/**
		 * The <i>GET_ACTIONLINK_VIEWED</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to request whether a specific action link has been viewed. The <i>Id</i> property
		 * of the event should be set to the the id of the desired action link. Once the event has been dispatched
		 * by the frame, the <i>ReturnData</i> property of the event will equal TRUE if the link has been viewed or
		 * FALSE if it has not been viewed.
		 */
		public static const GET_ACTIONLINK_VIEWED:String = "wg_actionlink_viewed";
		/**
		 * The <i>GET_ACTIONLINK_TITLE</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to request the title property of a specific action link. The <i>Id</i> property
		 * of the event should be set to the the id of the desired action link. Once the event has been dispatched
		 * by the frame, the <i>ReturnData</i> property of the event will be the action link's title as a string.
		 */
		public static const GET_ACTIONLINK_TITLE:String = "wg_actionlink_title";
		/**
		 * The <i>DO_ACTION_LINK</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to tell the player to perform the action associated with a link. The <i>Id</i>
		 * property of the event should be set to the the id of the desired action link.
		 */
		public static const DO_ACTION_LINK:String = "wg_action_link";
		/**
		 * The <i>PAUSE</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to have the player pause playback of the current timeline.
		 */
		public static const PAUSE:String = "wg_frm_pause";
		/**
		 * The <i>RESUME</i> constant defines the value of the <i>type</i> property of an event that
		 * can be used by the frame to have the player resume playback of the current timeline.
		 */
		public static const RESUME:String = "wg_frm_resume";

		private var m_strId:String = "";
		private var m_strWindowId:String = "";
		private var m_oReturnData:Object = null;
		private var m_nScrubTime:int = -1;
		private var m_nVolume:int = 80;

		/**
		 * @param type The type of the event, accessible as <i>wgEventFrame.type</i>.
		 * @param scrubtime The playback time in milliseconds.
		 * @param bubbles Determines whether the Event object participates in the bubbling stage of the event flow.
		 * The default value is false.
		 * @param cancelable Determines whether the Event object can be canceled. The default values is false.
		 */
		public function wgEventFrame(type:String, scrubtime:int = -1, bubbles:Boolean=true, cancelable:Boolean=true)
		{
			m_nScrubTime = scrubtime;
			super(type, bubbles, cancelable);
		}

		/**
		 * @private
		 */
		override public function clone():Event
		{
			var evt:wgEventFrame = new wgEventFrame(type, m_nScrubTime, bubbles, cancelable);

			evt.Id = m_strId;
			evt.ReturnData = m_oReturnData;
			evt.Volume = m_nVolume;

			return evt;
		}

		/**
		 * The id of the slide or slide draw connected to the event.
		 */
		public function get Id():String
		{
			return m_strId;
		}
		public function set Id(value:String):void
		{
			m_strId = value;
		}

		/**
		 * The id of the window connected to the event.
		 */
		public function get WindowId():String
		{
			return m_strWindowId;
		}
		public function set WindowId(value:String):void
		{
			m_strWindowId = value;
		}

		/**
		 * The current timeline value in milliseconds.
		 */
		public function get ScrubTime():int
		{
			return m_nScrubTime;
		}

		/**
		 * The ReturnData is set by the player when it respondes to the dispatched event. It will vary, depending on
		 * the type of event dispatched.
		 * <p>FRAME_READY = null</p>
		 * <p>GET_PLAYER = a reference to the IPlayer object</p>
		 * <p>GET_SLIDEDRAW = a reference the ISlideDraw object with the specified Id</p>
		 * <p>GET_SLIDE = a reference to the ISlide object with the specified Id</p>
		 * <p>GET_SLIDEBANK_SLIDE = a reference to the ISlide object with the specified Id or null if the slide has
		 * not been created</p>
		 * <p>GET_CURRENT_SLIDE = a reference to the ISlide object for the current slide</p>
		 * <p>GOTO_SLIDE = null</p>
		 * <p>TRIGGER_CUSTOM_EVENT = null</p>
		 */
		public function get ReturnData():Object
		{
			return m_oReturnData;
		}
		public function set ReturnData(value:Object):void
		{
			m_oReturnData = value;
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
	}
}