package customframe.components.seekbar
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	
	import customframe.Frame;

	import com.articulate.wg.v3_0.wgISlide;
	import com.articulate.wg.v3_0.wgITimeline;
	import com.articulate.wg.v3_0.wgEventFrame;
	import com.articulate.wg.v3_0.wgEventTimeline;

	/**
	 * This is the logic for the Seekbar symbol in the library (/components/seekbar/Seekbar.)
	 *
	 * The Seekbar contains play and pause icon buttons, a progress bar and a replay button. Each of these elements
	 * may be shown or hidden as well as enabled or disabled.
	 *
	 */
	public class Seekbar extends Sprite
	{
		private const DEFAULT_TRANSFORM:ColorTransform	= new ColorTransform();
		private const FADE_TRANSFORM:ColorTransform	= new ColorTransform(1, 1, 1, 1, 64, 64, 64, 0);

		public var background:Sprite;
		public var pauseIcon:Sprite;
		public var playIcon:Sprite;
		public var playPauseHitArea:Sprite;
		public var replayIcon:Sprite;
		public var replayHitArea:Sprite;
		public var progressMask:Sprite;
		public var progressBar:Sprite;
		public var progressRectangle:Sprite;
		public var timeField:TextField;

		private var m_oTimeline:wgITimeline = null;
		private var m_oCurrentSlide:wgISlide = null;
		private var m_nLastTime:int = -1;
		private var m_bPlaying:Boolean = false;

		private var m_bSeekPlaying:Boolean = false;
		private var m_bSeekAnimationsPlaying:Boolean = false;
		private var m_bChildrenInited:Boolean = false;
		private var m_bPlayPauseButtonEnabled:Boolean = false;
		private var m_bReplayButtonEnabled:Boolean = false;
		private var m_nWidth:Number = 0;
		private var m_nProgressBarWidth:Number = 0;

		public function Seekbar()
		{
			super();
			this.pauseIcon.visible = true;
			this.playIcon.visible = false;
			this.progressRectangle.mouseEnabled = false;
			this.timeField.visible = false;
			this.width = super.width;
		}

		override public function get width():Number
		{
			return this.background.width;
		}

		override public function set width(value:Number):void
		{
			m_nWidth = value;
			this.background.width = value;
		}

		public function set Timeline(value:wgITimeline):void
		{
			m_oTimeline = value;
			m_oTimeline.addEventListener(wgEventTimeline.UPDATE_TIMELINE, UpdateTimelineStatus);
			m_oTimeline.addEventListener(wgEventTimeline.TIMELINE_CHANGED, OnTimelineChanged);
			
			UpdateTimelineStatus();
			
			if (!m_bChildrenInited)
			{
				InitChildren();
			}
		}
		
		protected function InitChildren():void
		{
			this.playIcon.mouseEnabled = false;
			this.pauseIcon.mouseEnabled = false;
			this.playPauseHitArea.buttonMode = true;
			this.playPauseHitArea.useHandCursor = true;
			this.playPauseHitArea.addEventListener(MouseEvent.MOUSE_DOWN, PlayPauseHitArea_onClick);
			this.playPauseHitArea.addEventListener(MouseEvent.ROLL_OVER, PlayPauseHitArea_onRollOver);
			this.playPauseHitArea.addEventListener(MouseEvent.ROLL_OUT, PlayPauseHitArea_onRollOut);

			this.replayIcon.mouseEnabled = false;
			this.replayHitArea.buttonMode = true;
			this.replayHitArea.useHandCursor = true;
			this.replayHitArea.addEventListener(MouseEvent.MOUSE_DOWN, ReplayHitArea_onClick);
			this.replayHitArea.addEventListener(MouseEvent.ROLL_OVER, ReplayHitArea_onRollOver);
			this.replayHitArea.addEventListener(MouseEvent.ROLL_OUT, ReplayHitArea_onRollOut);
			
			this.progressBar.addEventListener(MouseEvent.MOUSE_DOWN, ProgressBar_onMouseDown);
			this.progressBar.addEventListener(MouseEvent.MOUSE_OVER, ProgressBar_onMouseOver);
			this.progressBar.addEventListener(MouseEvent.MOUSE_OUT, ProgressBar_onMouseOut);
			
			m_bChildrenInited = true;
		}
		
		public function set PlayPauseButtonEnabled(value:Boolean):void
		{
			m_bPlayPauseButtonEnabled = this.playPauseHitArea.mouseEnabled = value;
			UpdateControls();
		}
		
		public function set ReplayButtonEnabled(value:Boolean):void
		{
			m_bReplayButtonEnabled = this.replayHitArea.mouseEnabled = value;
			UpdateControls();
		}
		
		protected function UpdateControls():void
		{
			this.playIcon.visible = m_bPlayPauseButtonEnabled && !m_bPlaying;
			this.pauseIcon.visible = m_bPlayPauseButtonEnabled && m_bPlaying;
			this.replayIcon.visible = m_bReplayButtonEnabled;
			this.replayIcon.x = m_nWidth - 35;
			this.replayHitArea.x = m_nWidth - 38;
			// Progress Bar
			this.progressRectangle.x = 8;
			this.progressMask.x = 8;
			this.progressBar.x = 8;
			m_nProgressBarWidth = m_nWidth - 22;
			this.progressBar.width = m_nProgressBarWidth;
			this.progressRectangle.width = m_nProgressBarWidth;

			if (m_bPlayPauseButtonEnabled)
			{
				this.progressRectangle.x += 24;
				this.progressMask.x += 24;
				this.progressBar.x += 24;
				m_nProgressBarWidth -= 24;
				this.progressBar.width = m_nProgressBarWidth;
				this.progressRectangle.width = m_nProgressBarWidth;
			}

			if (m_bReplayButtonEnabled)
			{
				m_nProgressBarWidth -= 27;
				this.progressBar.width = m_nProgressBarWidth;
				this.progressRectangle.width = m_nProgressBarWidth;
			}
		}

		protected function UpdateTime(evt:Event):void
		{
			var nDuration:Number = m_oTimeline.Duration;
			var nCurTime:Number = m_oTimeline.PlayHeadTime;
			var nPercentPosition = Math.min(nCurTime / nDuration, 1);
			this.progressMask.width = m_nProgressBarWidth * nPercentPosition;
			this.timeField.text = nCurTime + " / " + nDuration;
		}
		
		protected function OnTimelineChanged(evt:Event):void
		{
			UpdateTimelineStatus();
		}

		protected function UpdateTimelineStatus(evt:Event = null):void
		{
			if (m_oTimeline.TimelinePlaying)
			{
				if (!m_bPlaying)
				{
					m_bPlaying = true;
					addEventListener(Event.ENTER_FRAME, UpdateTime);
				}
			}
			else
			{
				if (m_bPlaying)
				{
					m_bPlaying = false;
					removeEventListener(Event.ENTER_FRAME, UpdateTime);
				}
			}

			UpdateTime(null);
			UpdateControls();
		}
		
		public function TogglePlayPause():void
		{
			if (m_bPlaying)
			{
				m_oTimeline.PauseAnimations();
				dispatchEvent(new wgEventFrame(wgEventFrame.PAUSE));
			}
			else
			{
				m_oTimeline.PlayAnimations();
				dispatchEvent(new wgEventFrame(wgEventFrame.RESUME));
			}
			UpdateTimelineStatus();
		}

		private function PlayPauseHitArea_onClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			TogglePlayPause();
		}

		private function PlayPauseHitArea_onRollOver(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			this.playIcon.transform.colorTransform = FADE_TRANSFORM;
			this.pauseIcon.transform.colorTransform = FADE_TRANSFORM;
		}

		private function PlayPauseHitArea_onRollOut(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			this.playIcon.transform.colorTransform = DEFAULT_TRANSFORM;
			this.pauseIcon.transform.colorTransform = DEFAULT_TRANSFORM;
		}

		protected function ReplayHitArea_onClick(evt:MouseEvent)
		{
			m_oTimeline.ReplayTimeline();
		}

		private function ReplayHitArea_onRollOver(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			this.replayIcon.transform.colorTransform = FADE_TRANSFORM;
		}

		private function ReplayHitArea_onRollOut(event:MouseEvent):void
		{
			event.stopImmediatePropagation();
			this.replayIcon.transform.colorTransform = DEFAULT_TRANSFORM;
		}
		
		protected function  ProgressBar_onMouseOver(evt:Event)
		{
			var oSlide:wgISlide = Frame.CustomFrame.GetCurrentSlide();
			if (oSlide.SlideLock)
			{
				Frame.CustomFrame.SetLockCursor(true);
			}
		}
		
		protected function  ProgressBar_onMouseOut(evt:Event)
		{	
			var oSlide:wgISlide = Frame.CustomFrame.GetCurrentSlide();
			if (oSlide.SlideLock)
			{
				Frame.CustomFrame.SetLockCursor(false);
			}
		}

		protected function ProgressBar_onMouseDown(event:MouseEvent):void
		{
			m_nLastTime = -1;
			m_bSeekPlaying = m_oTimeline.TimelinePlaying;;
			m_bSeekAnimationsPlaying = m_oTimeline.AnimationsPlaying;

			if (m_bSeekAnimationsPlaying)
			{
				m_oTimeline.PauseAnimations();
			}
			this.stage.addEventListener(MouseEvent.MOUSE_UP, ProgressBar_onMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, ProgressBar_onMouseMove);
			ProgressBar_onMouseMove(null);
		}

		protected function ProgressBar_onMouseMove(event:MouseEvent):void
		{
			var oSlide:wgISlide = Frame.CustomFrame.GetCurrentSlide();
			if (!oSlide.SlideLock)
			{
				var nPosition:int = m_oTimeline.Duration * (this.progressBar.mouseX * this.progressBar.scaleX / this.progressBar.width);
				if (m_nLastTime != nPosition)
				{
					m_nLastTime = nPosition;
					m_oTimeline.SeekTimeline(nPosition);
					UpdateTime(null);
				}
			}
		}

		protected function ProgressBar_onMouseUp(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, ProgressBar_onMouseUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, ProgressBar_onMouseMove);
			if (m_bSeekPlaying)
			{
				m_oTimeline.PlayTimeline();
			}
		}
	}
}
