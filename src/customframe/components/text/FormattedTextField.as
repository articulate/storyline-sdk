package customframe.components.text
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.*;

	import customframe.base.SizingSprite;

	/**
	 * This is the logic for the FormattedTextField symbol in the library (/components/text/FormattedTextField.)
	 *
	 * The FormattedTextField contains a Flash TextField. It adds functions for setting individual style attributes.
	 *
	 */
	public class FormattedTextField extends SizingSprite
	{
		public var field:TextField;

		protected var m_nBackgroundColor:uint = 0xFFFFFF;
		protected var m_strHTMLText:String = "";
		protected var m_oTextFormat:TextFormat = new TextFormat();
		protected var m_bAutoSize:Boolean = false;
		protected var m_bWrap:Boolean = false;
		protected var m_bTruncate:Boolean = false;

		public function FormattedTextField()
		{
			this.field.autoSize = TextFieldAutoSize.LEFT;
		}

		public function SetHangingIndent(strText:String):void
		{
			if (strText.length > 0)
			{
				this.field.text = strText;
				var nWidth:int = this.field.textWidth + 5;

				m_oTextFormat.indent = -nWidth;
				m_oTextFormat.leftMargin = nWidth;
				m_oTextFormat.tabStops = new Array(nWidth);
				ApplyFormat();
			}
		}

		public function ClearHangingIndent():void
		{
			m_oTextFormat.indent = 0;
			m_oTextFormat.leftMargin = 0;
			m_oTextFormat.tabStops = new Array();
			ApplyFormat();
		}

		protected function ApplyFormat():void
		{
			this.TextFormat = m_oTextFormat;
			this.DefaultTextFormat = m_oTextFormat;
		}

		public function get TextHeight():Number
		{
			return this.field.textHeight;
		}

		public function set DefaultTextFormat(value:TextFormat):void
		{
			this.field.defaultTextFormat = value;
		}

		public function set TextFormat(value:TextFormat):void
		{
			this.field.setTextFormat(value);
		}

		public function get Leading():Number
		{
			return m_oTextFormat.leading as Number;
		}
		public function set Leading(value:Number):void
		{
			m_oTextFormat.leading = value;
			ApplyFormat();
		}

		public function get Color():uint
		{
			return m_oTextFormat.size as uint;
		}
		public function set Color(value:uint):void
		{
			m_oTextFormat.color = value;
			ApplyFormat();
		}

		public function get Size():Number
		{
			return m_oTextFormat.size as Number;
		}
		public function set Size(value:Number):void
		{
			m_oTextFormat.size = value;
			ApplyFormat();
		}

		public function get Bold():Boolean
		{
			return m_oTextFormat.bold;
		}
		public function set Bold(value:Boolean):void
		{
			m_oTextFormat.bold = value;
			ApplyFormat();
		}

		public function get Autosize():Boolean
		{
			return m_bAutoSize;
		}
		public function set Autosize(value:Boolean):void
		{
			m_bAutoSize = value;
		}

		public function get Wrap():Boolean
		{
			return m_bWrap;
		}
		public function set Wrap(value:Boolean):void
		{
			m_bAutoSize = value;
		}

		public function get Truncate():Boolean
		{
			return m_bTruncate;
		}
		public function set Truncate(value:Boolean):void
		{
			m_bTruncate = value;
		}

		public function get Text():String
		{
			return this.field.text;
		}
		public function set Text(value:String):void
		{
			if (value != this.field.text)
			{
				this.field.text = value;
				QueueRedraw();
			}
		}

		public function get HtmlText():String
		{
			return this.field.htmlText;
		}
		public function set HtmlText(value:String):void
		{
			if (value != this.field.htmlText)
			{
				m_strHTMLText = value;
				this.field.htmlText = m_strHTMLText;
				QueueRedraw();
			}
		}
	}
}
