package customframe.components.list
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	import customframe.base.SizingSprite;

	/**
	 * ItemBase is a base class for list items. It contains functionality common to all list items.
	 * It contains an abstract function called "SetBackgroundColor." The idea is when the user rolls over
	 * the list item or slectes it, the background can change color.
	 */
	public class ItemBase extends SizingSprite
	{
		protected var m_nUpColor:uint = 0xFFFFFF;
		protected var m_nOverColor:uint = 0xE6E6E6;
		protected var m_nSelectedColor:uint = 0xC0E2F1;
		protected var m_nBackgroundColor:uint = 0xFFFFFF;

		protected var m_strId:String = "";
		protected var m_strTitle:String = "";
		protected var m_strData:String = "";
		protected var m_nItemIndex:int = 0;

		protected var m_bHover:Boolean = false;
		protected var m_bSelected:Boolean = false;
		protected var m_bShowHover:Boolean = false;
		protected var m_bShowSelected:Boolean = false;

		public function ItemBase()
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			this.useHandCursor = true;

			addEventListener(MouseEvent.MOUSE_OVER, OnMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, OnMouseOut);
			addEventListener(MouseEvent.CLICK, OnClick);
		}

		public function get Id():String
		{
			return m_strId;
		}

		public function get Title():String
		{
			return m_strTitle;
		}

		public function get Data():String
		{
			return m_strData;
		}

		public function get ItemHover():Boolean
		{
			return m_bHover;
		}
		public function set ItemHover(value:Boolean):void
		{
			m_bHover = value;
			var nColor:uint = (value && m_bShowHover) ? m_nOverColor : m_nUpColor;
			SetBackgroundColor(nColor);
		}

		public function get ItemIndex():uint
		{
			return m_nItemIndex;
		}
		public function set ItemIndex(value:uint):void
		{
			m_nItemIndex = value;
		}

		public function get Selected():Boolean
		{
			return m_bSelected;
		}
		
		public function set Selected(value:Boolean):void
		{
			m_bSelected = value;
			var nColor:uint = (value && m_bShowSelected) ? m_nSelectedColor : m_nUpColor;
			SetBackgroundColor(nColor);
		}

		protected function SetBackgroundColor(nColor:uint):void
		{
			// Abstract function. Implement this in subclasses.
		}

		protected function GetRGBFromColorUint(nUint:uint):Object
		{
			var oRGB:Object =
			{
				R: (nUint >> 16) & 0xFF,
				G: (nUint >> 8) & 0xFF,
				B: nUint & 0xFF
			};
			return oRGB;
		}

		protected function OnMouseOver(evt:MouseEvent):void
		{
			if (!this.Selected)
			{
				this.ItemHover = true;
			}
		}

		protected function OnMouseOut(evt:MouseEvent):void
		{
			if (!this.Selected)
			{
				this.ItemHover = false;
			}
		}

		protected function OnClick(evt:MouseEvent):void
		{
			if (!this.Selected)
			{
				this.Selected = true;
			}
		}
	}
}