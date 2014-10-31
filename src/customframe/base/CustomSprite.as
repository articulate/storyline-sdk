package customframe.base
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	import com.articulate.wg.v3_0.wgIFocusObject;

	import customframe.managers.ControlManager;
	import customframe.managers.OptionManager;

	/**
	 * CustomSprite extends Sprite to add fuctionality common to many visual objects in the custom frame.
	 * It also has empty stubs for the necessary functions in the wgIFocusObject interface.
	 */
	public class CustomSprite extends Sprite implements wgIFocusObject
	{
		protected var m_bDirty:Boolean = true;
		protected var m_bOnStage:Boolean = false;
		protected var m_bControlsDirty:Boolean = false;

		protected var m_oControlManager:ControlManager = null;
		protected var m_oOptionManager:OptionManager = null;

		public function CustomSprite()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
		}

		public function Redraw():void
		{
			m_bDirty = false;
		}

		public function set ControlManager(value:ControlManager):void
		{
			m_oControlManager = value;

			if (m_oControlManager != null)
			{
				m_oControlManager.addEventListener(ControlManager.CONTROL_LAYOUT_CHANGED, OnControlLayoutChanged);
			}
		}

		public function set OptionManager(value:OptionManager):void
		{
			m_oOptionManager = value;

			if (m_oOptionManager != null)
			{
				m_oOptionManager.addEventListener(OptionManager.OPTIONS_CHANGED, OnOptionsChanged);
			}
		}

		public function get OnStage():Boolean
		{
			return m_bOnStage;
		}

		override public function set width(value:Number):void
		{
			if (value != super.width)
			{
				super.width = value;
				QueueRedraw();
			}
		}

		override public function set height(value:Number):void
		{
			if (value != super.height)
			{
				super.height = value;
				QueueRedraw();
			}
		}

		protected function QueueRedraw():void
		{
			m_bDirty = true;

			if (this.stage != null)
			{
				addEventListener(Event.ENTER_FRAME, OnEnterFrame);
			}
		}

		protected function OnEnterFrame(evt:Event):void
		{
			if (m_bDirty)
			{
				Redraw();
			}

			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
		}

		protected function OnControlLayoutChanged(evt:Event):void
		{
			m_bControlsDirty = true;
			QueueRedraw();
		}

		protected function OnOptionsChanged(evt:Event):void
		{
			m_bControlsDirty = true;
			QueueRedraw();
		}

		protected function OnRemovedFromStage(evt:Event)
		{
			m_bOnStage = false;

			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			removeEventListener(Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
		}

		protected function OnAddedToStage(evt:Event)
		{
			m_bOnStage = true;

			removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
		}

		public function Destroy()
		{
			if (this.stage != null && this.parent != null)
			{
				this.parent.removeChild(this);
			}

			removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
			removeEventListener(Event.ADDED_TO_STAGE, OnAddedToStage);
			removeEventListener(Event.REMOVED_FROM_STAGE, OnRemovedFromStage);
		}

		// Unimplemented Interface functions

		public function IsFocusEnabled():Boolean
		{
			return false;
		}

		public function SetFocus(bShowFocusRect:Boolean = true):Boolean
		{
			return false;
		}

		public function SetLastFocus(bShowFocusRect:Boolean = true):Boolean
		{
			return false;
		}

		public function HasFocusChildren():Boolean
		{
			return false;
		}

		public function SetNextChildFocus(bShowFocusRect:Boolean = true):Boolean
		{
			return false;
		}

		public function SetPreviousChildFocus(bShowFocusRect:Boolean = true):Boolean
		{
			return false;
		}

		public function HasFocus():Boolean
		{
			return false;
		}

		public function GetFocusParent():wgIFocusObject
		{
			return null;
		}

		public function SetFocusParent(oParent:wgIFocusObject):void
		{
			//
		}

		public function SetCurrentFocus(oFocusObject:wgIFocusObject, bParent:Boolean = false):void
		{
			//
		}
	}
}