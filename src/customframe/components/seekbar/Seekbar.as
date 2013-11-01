package customframe.components.seekbar
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.text.TextField;

	import com.articulate.wg.v2_0.wgISlide;
	import com.articulate.wg.v2_0.wgPlayerEvent;

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

		public function get CurrentSlide():wgISlide
		{
			return m_oCurrentSlide;
		}

		public function set CurrentSlide(value:wgISlide):void
		{
			if (m_oCurrentSlide != null)
			{
				m_oCurrentSlide.removeEventListener(wgPlayerEvent.SLIDE_UPDATE_TIMELINE, UpdateSlideStatus);
			}

			m_oCurrentSlide = value;
			m_oCurrentSlide.addEventListener(wgPlayerEvent.SLIDE_UPDATE_TIMELINE, UpdateSlideStatus);
			UpdateSlideStatus();

			if (!m_bChildrenInited)
			{
				InitChildren();
			}
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

			addEventListener(Event.ENTER_FRAME, OnEnterFrame);
			m_bChildrenInited = true;
		}

		public function UpdateSlideStatus(evt:Event = null):void
		{
			if (m_oCurrentSlide.TimelinePlaying != m_bPlaying)
			{
				if (m_oCurrentSlide.TimelinePlaying)
				{
					addEventListener(Event.ENTER_FRAME, OnEnterFrame);
				}
				else
				{
					removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
				}
			}

			m_bPlaying = m_oCurrentSlide.TimelinePlaying;
			UpdateControls();
			UpdateTime();
		}

		protected function ProgressBar_onMouseDown(event:MouseEvent):void
		{
			m_nLastTime = -1;
			m_bSeekPlaying = m_oCurrentSlide.TimelinePlaying;
			m_bSeekAnimationsPlaying = m_oCurrentSlide.AnimationsPlaying;

			if (m_bSeekAnimationsPlaying)
			{
				m_oCurrentSlide.PauseSlideAnimations();
			}

			this.stage.addEventListener(MouseEvent.MOUSE_UP, ProgressBar_onMouseUp);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, ProgressBar_onMouseMove);
			ProgressBar_onMouseMove(null);
		}

		protected function ProgressBar_onMouseMove(event:MouseEvent):void
		{
			var nPosition:int = m_oCurrentSlide.Duration *
								(this.progressBar.mouseX * this.progressBar.scaleX / this.progressBar.width);

			if (m_nLastTime != nPosition)
			{
				m_nLastTime = nPosition;
				m_oCurrentSlide.SeekSlide(nPosition);
				UpdateTime();
			}
		}

		protected function ProgressBar_onMouseUp(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, ProgressBar_onMouseUp);
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, ProgressBar_onMouseMove);

			if (m_bSeekPlaying)
			{
				m_oCurrentSlide.PlayTimeline();
			}
		}

		protected function OnEnterFrame(event:Event):void
		{
			UpdateTime();
		}

		protected function UpdateTime():void
		{
			if (m_oCurrentSlide!= null)
			{
				var nDuration:Number = m_oCurrentSlide.Duration;
				var nCurTime:Number = m_oCurrentSlide.PlayHeadTime;
				var nPercentPosition = Math.min(nCurTime / nDuration, 1);
				this.progressMask.width = m_nProgressBarWidth * nPercentPosition;
				this.timeField.text = nCurTime + " / " + nDuration;
			}
		}

		private function PlayPauseHitArea_onClick(event:MouseEvent):void
		{
			event.stopImmediatePropagation();

			if (m_bPlaying)
			{
				m_oCurrentSlide.PauseSlideAnimations();
			}
			else
			{
				m_oCurrentSlide.PlaySlideAnimations();
			}

			UpdateSlideStatus();
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
			m_oCurrentSlide.ReplaySlide();
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
	}
}
