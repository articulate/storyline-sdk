package customframe.components.buttons
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import com.articulate.wg.v3_0.wgEventFrame;
	
	/**
	 * This is the logic for the VolumeButton symbol in the library (/components/buttons/VolumeButton.)
	 *
	 * The VolumeButton has two visual states. In its compact state it is a normal button. When clicked, it changes
	 * to the expanded state, expanding upward and displaying a slider control.
	 *
	 * A wgEventFrame.VOLUME_CHANGED is dispatched when the button on the slider control is moved.
	 */
	public class VolumeButton extends MovieClip
	{
		public static const UP:String = "Up";
		public static const OVER:String = "Over";
		public static const DOWN:String = "Down";
		public static const DEFAULT_VOLUME:int = 80;
		
		public var sliderTrack:Sprite;
		public var sliderButton:Sprite;
		public var iconMin:Sprite;
		public var iconLow:Sprite;
		public var iconHigh:Sprite;
		public var iconMax:Sprite;
		public var backgroundUp:Sprite;
		
		private var m_nVolume:int = 0;
		private var m_bMuted:Boolean = false;
		
		private var m_nSliderDragHeight:Number = 0;
		private var m_bDraggingButton:Boolean = false;
		private var m_nUpButtonHeight:Number = 0;
		
		public function VolumeButton()
		{
			super();
			this.sliderTrack.visible = false;
			this.sliderButton.visible = false;
			
			m_nSliderDragHeight = this.sliderTrack.height - this.sliderButton.height;
			m_nUpButtonHeight = this.backgroundUp.height;
			
			addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut);
			addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			
			UpdateThumb(DEFAULT_VOLUME);
		}
		
		public function get Volume():int
		{
			return m_nVolume;
		}
		
		protected function SetState(strState:String):void
		{
			this.gotoAndStop(strState);
			this.sliderTrack.visible = (strState == DOWN);
			this.sliderButton.visible = (strState == DOWN);
		}
		
		protected function UpdateThumb(nSetVolume:Number = NaN):void
		{
			var nVolume:int = 0;
			var nYPos:int = 0;
			
			if (!isNaN(nSetVolume))
			{
				nVolume = Math.round(nSetVolume);
				nYPos = Math.round((1 - nVolume / 100) * m_nSliderDragHeight);
			}
			else
			{
				nYPos = this.sliderTrack.mouseY;
				nYPos = Math.max(0, nYPos);
				nYPos = Math.min(m_nSliderDragHeight, nYPos);
				nVolume = Math.round((1 - nYPos / m_nSliderDragHeight) * 100);
			}
			
			this.sliderButton.y = this.sliderTrack.y + nYPos;
			
			if (nVolume != m_nVolume)
			{
				m_nVolume = nVolume;
				this.iconMin.visible = (m_nVolume == 0);
				this.iconLow.visible = (m_nVolume > 0 && m_nVolume < 50);
				this.iconHigh.visible = (m_nVolume >= 50 && m_nVolume < 100);
				this.iconMax.visible = (m_nVolume == 100);
				var evt:wgEventFrame = new wgEventFrame(wgEventFrame.VOLUME_CHANGED);
				evt.Volume = m_nVolume;
				dispatchEvent(evt);
			}
		}
		
		protected function get MouseIsOverButton():Boolean
		{
			return (this.mouseX >= 0 && this.mouseX <= this.width && this.mouseY >= 0 && this.mouseY <= m_nUpButtonHeight);
		}
		
		protected function OnMouseOver(evt:MouseEvent):void
		{
			if (this.currentFrameLabel == UP)
			{
				SetState(OVER);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, Stage_OnMouseUp);
			}
		}
		
		protected function OnMouseOut(evt:MouseEvent):void
		{
			if (this.currentFrameLabel == OVER)
			{
				SetState(UP);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, Stage_OnMouseUp);
			}
		}
		
		protected function OnMouseDown(evt:MouseEvent):void
		{
			evt.stopImmediatePropagation();
			
			if (this.currentFrameLabel != DOWN)
			{
				SetState(DOWN);
				m_bDraggingButton = false;
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, Stage_OnMouseMove);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, Stage_OnMouseUp);
			}
			else if (this.mouseY >= 0)
			{
				SetState(OVER);
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, Stage_OnMouseUp);
			}
			else
			{
				if (this.MouseIsOverButton)
				{
					UpdateThumb();
				}
				
				m_bDraggingButton = true;
				
				this.stage.addEventListener(MouseEvent.MOUSE_MOVE, Stage_OnMouseMove);
				this.stage.addEventListener(MouseEvent.MOUSE_UP, Stage_OnMouseUp);
			}
		}
		
		protected function Stage_OnMouseMove(evt:MouseEvent):void
		{
			if (m_bDraggingButton)
			{
				UpdateThumb();
			}
			else if (this.mouseY < 0)
			{
				m_bDraggingButton = true;
				this.stage.addEventListener(MouseEvent.MOUSE_UP, Stage_OnMouseUp);
			}
		}
		
		protected function Stage_OnMouseUp(evt:MouseEvent):void
		{
			if (m_bDraggingButton || !this.MouseIsOverButton)
			{
				if (m_bDraggingButton)
				{
					UpdateThumb();
				}
				
				m_bDraggingButton = false;
				
				if (this.MouseIsOverButton)
				{
					SetState(OVER);
				}
				else
				{
					SetState(UP);
				}
				
				this.stage.removeEventListener(MouseEvent.MOUSE_UP, Stage_OnMouseUp);
			}
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, Stage_OnMouseMove);
		}
	}
}