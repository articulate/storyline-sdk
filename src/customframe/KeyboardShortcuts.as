package customframe
{
	import com.articulate.wg.v3_0.wgEventFrame;
	import customframe.components.buttons.ControlButtons;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.EventDispatcher;
	
	public class KeyboardShortcuts
	{
		private const KEY_OUTLINE:int = 79;
		private const KEY_NOTES:int = 78;
		private const KEY_BIO:int = 66;
		private const KEY_MUTE:int = 77;
		private const KEY_GLOSSARY:int = 71;
		private const KEY_RESOURCES:int = 82;
		
		private const LISTENER_PRIORITY:int = -100;
		
		private var m_oFrame:Frame = null;
		private var m_oStage:Stage = null;
		
		private var m_oLastKeyEvent:KeyboardEvent = null;
		private var m_oLastKey:Object = null;		
		
		private var m_bEnabled:Boolean = true;
		
		public function KeyboardShortcuts(oFrame:Frame) 
		{
			m_oFrame = oFrame;
		}
		
		public function SetStage(stage:Stage):void
		{
			m_oStage = stage;
		}
		
		public function set Enabled(value:Boolean):void
		{
			m_bEnabled = value;
			
			if (m_bEnabled)
			{
				m_oStage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyPress, false, LISTENER_PRIORITY);
				m_oStage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp, false, LISTENER_PRIORITY);
			}
			else
			{
				m_oStage.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyPress);
				m_oStage.removeEventListener(KeyboardEvent.KEY_UP, OnKeyUp);						
			}
		}
		
		public function get Enabled():Boolean
		{
			return m_bEnabled;
		}
		
		protected function OnKeyUp(evt:KeyboardEvent):void
		{
			m_oLastKeyEvent = null;
			m_oLastKey = null;
		}		
		
		protected function OnKeyPress(evt:KeyboardEvent):void
		{
			// Prevent the event from triggering multiple times by holding down the key
			if (m_oLastKeyEvent)
			{
				if (evt.altKey == m_oLastKeyEvent.altKey)
				{
					if (evt.shiftKey == m_oLastKeyEvent.shiftKey)
					{
						if (evt.ctrlKey == m_oLastKeyEvent.ctrlKey)
						{
							if (evt.keyCode == m_oLastKeyEvent.keyCode)
							{
								return;
							}
						}
					}
				}
			}
			
			m_oLastKeyEvent = evt;
			m_oLastKey = new Object();
			m_oLastKey.Ctrl = m_oLastKeyEvent.ctrlKey;
			m_oLastKey.Shift = m_oLastKeyEvent.shiftKey;
			m_oLastKey.Alt = m_oLastKeyEvent.altKey;
			m_oLastKey.Code = -1;
			m_oLastKey.Value = "";
			
			if (evt.keyCode != Keyboard.SHIFT && evt.keyCode != Keyboard.CONTROL)
			{
				m_oLastKey.Code = evt.keyCode;
				m_oLastKey.Value = String.fromCharCode(evt.keyCode);
			}
			
			var nKeyCode:int = evt.keyCode;
			var bCtrl:Boolean = evt.ctrlKey;
			var bShift:Boolean = evt.shiftKey;
			var bAlt:Boolean = evt.altKey;
			
			if (!bCtrl && !bShift && !bAlt)
			{
				var evtFrame:wgEventFrame = null;
				switch (nKeyCode)
				{
					case Keyboard.LEFT: // Previous Slide
					case Keyboard.UP:
					case Keyboard.PAGE_UP:
						evtFrame = new wgEventFrame(wgEventFrame.TRIGGER_CUSTOM_EVENT);
						evtFrame.Id = ControlButtons.PREV_PRESSED;
						m_oFrame.dispatchEvent(evtFrame);
						break;
						
					case Keyboard.RIGHT: // Next Slide
					case Keyboard.DOWN:
					case Keyboard.PAGE_DOWN:
						evtFrame = new wgEventFrame(wgEventFrame.TRIGGER_CUSTOM_EVENT);
						evtFrame.Id = ControlButtons.NEXT_PRESSED;
						m_oFrame.dispatchEvent(evtFrame);
						break;
						
					case Keyboard.HOME: // First Slide
						m_oFrame.GotoFirstSlide();
						break;
						
					case Keyboard.END: // Last Slide
						m_oFrame.GotoLastSlide();
						break;
						
					case Keyboard.SPACE: // Toggle Play/Pause
						m_oFrame.PlayPauseSlide();
						break;
						
					case KEY_OUTLINE:
							m_oFrame.SetActiveTab(Frame.CONTROL_OUTLINE);
						break;
						
					case KEY_NOTES:
							m_oFrame.SetActiveTab(Frame.CONTROL_TRANSCRIPT);
						break;
						
					case KEY_GLOSSARY:
							m_oFrame.SetActiveTab(Frame.CONTROL_GLOSSARY);
						break;
						
					case KEY_RESOURCES:
							m_oFrame.SetActiveTab(Frame.CONTROL_RESOURCES);
						break;
						
					case KEY_BIO:
						m_oFrame.ShowBio();
						break;
						
					case KEY_MUTE:
						m_oFrame.ToggleMute();
						break;
				}
			}
		}			
	}
}