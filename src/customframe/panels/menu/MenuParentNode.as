package customframe.panels.menu
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import com.articulate.wg.v3_0.*;

	import customframe.Frame;
	import customframe.managers.OptionManager;

	/**
	 * MenuParentNode is the base class for menu tree nodes that contain child nodes. It populates itself with
	 * nodes based on the XML data it is given.
	 *
	 */
	public class MenuParentNode extends MenuNode
	{
		public static const SLIDE_LINK:String = "slidelink";
		public static const SLIDE_DRAW_REF:String = "slidedrawref";
		public static const DRAW_ID:String = "drawid";

		protected var m_vecChildNodes:Vector.<MenuNode> = null;
		protected var m_nExpandedHeight:Number = 0;
		protected var m_oSlideDraws:Object = new Object();

		public function MenuParentNode(oOptionManager:OptionManager, strNumber:String = "")
		{
			super(oOptionManager, strNumber);
		}

		override public function set XMLData(value:XML):void
		{
			super.XMLData = value;
			if (value != null)
			{
				CreateChildren();
			}
		}

		public function GetChildNodeByIndex(nIndex:int):MenuNode
		{
			return (nIndex >= 0 && nIndex < m_vecChildNodes.length) ? m_vecChildNodes[nIndex] : null;
		}

		public function CreateChildren():void
		{
			m_vecChildNodes = new Vector.<MenuNode>();
			m_nExpandedHeight = m_nHeight;

			var xmlLinks:XMLList = m_xmlData.links.children();

			for each (var xmlData:XML in xmlLinks)
			{
				switch (xmlData.name().toString())
				{
					case SLIDE_LINK:
					{
						var oChildNode:MenuNode = CreateNode(xmlData, m_vecChildNodes.length);
						m_nExpandedHeight += oChildNode.height;
						break;
					}
					case SLIDE_DRAW_REF:
					{
						var vecNodes:Vector.<MenuNode> = CreateSlideDrawNodes(xmlData);
						var nTotalHeight:int = 0;
						for each (var oNode:MenuNode in vecNodes)
						{
							nTotalHeight += oNode.height;
						}
						m_nExpandedHeight += nTotalHeight;
						break;
					}
				}
			}
			QueueRedraw();
		}

		protected function CreateSlideDrawNodes(xmlData:XML):Vector.<MenuNode>
		{
			var vecNodes:Vector.<MenuNode> = new Vector.<MenuNode>();
			var strDrawId:String = xmlData.attribute(DRAW_ID);
			strDrawId = (strDrawId.indexOf(MenuNode.PLAYER_PREFIX) == 0) ? strDrawId.substr(8) : strDrawId;

			var oSlideDraw:wgISlideDraw = GetSlideDraw(strDrawId);

			if (oSlideDraw != null)
			{
				oSlideDraw.addEventListener(wgPlayerEvent.SLIDEDRAW_UPDATE, OnSlideDrawUpdate);
				var nSlideCount:int = oSlideDraw.SlideCount;

				if (nSlideCount > 0)
				{
					for (var i:int = 0; i < nSlideCount; ++i)
					{
						var oSlide:wgISlide = oSlideDraw.GetSlideAtIndex(i);
						var oNode:MenuNode = CreateNodeFromSlide(oSlide, m_vecChildNodes.length);
						vecNodes.push(oNode);
					}
					m_oSlideDraws[strDrawId] = vecNodes;
				}
			}

			return vecNodes;
		}

		protected function GetSlideDraw(strDrawId:String):wgISlideDraw
		{
			var oEvent:wgEventFrame = new wgEventFrame(wgEventFrame.GET_SLIDEDRAW);
			oEvent.Id = strDrawId;
			Frame.CustomFrame.dispatchEvent(oEvent);
			return oEvent.ReturnData as wgISlideDraw;
		}

		protected function CreateNode(xmlData:XML, nIndex:int):MenuNode
		{
			var strNumber:String = m_strNumber + (nIndex + 1);
			var bExpanded:Boolean = xmlData.@expand == "true";

			var oChildNode:MenuNode = null;

			if (xmlData.links.children().length() > 0)
			{
				oChildNode = new MenuBranchNode(m_oOptionManager, strNumber, bExpanded);
			}
			else
			{
				oChildNode = new MenuNode(m_oOptionManager, strNumber);
			}

			oChildNode.XMLData = xmlData;
			oChildNode.width = m_nWidth;
			oChildNode.addEventListener(MenuEvent.ADJUST_LAYOUT, ChildNode_OnAdjustLayout);

			if (nIndex < m_vecChildNodes.length)
			{
				m_vecChildNodes.splice(nIndex, 0, oChildNode);
			}
			else
			{
				m_vecChildNodes.push(oChildNode);
			}

			return oChildNode;
		}

		protected function get LevelIndent():int
		{
			return LEVEL_INDENT;
		}

		protected function ChildNode_OnAdjustLayout(evt:MenuEvent):void
		{
			AdjustLayout(evt.Node);
			dispatchEvent(new MenuEvent(MenuEvent.ADJUST_LAYOUT, this));
		}

		override public function SelectSlideById(strSlideId:String):Boolean
		{
			var bFoundSlide:Boolean = super.SelectSlideById(strSlideId);

			if (!bFoundSlide)
			{
				var oNode:MenuNode = null;

				if (m_vecChildNodes != null)
				{
					for (var i:int = 0; !bFoundSlide && i < m_vecChildNodes.length; ++i)
					{
						oNode = m_vecChildNodes[i];
						bFoundSlide = oNode.SelectSlideById(strSlideId);
					}
				}
			}
			return bFoundSlide;
		}

		override public function Redraw():void
		{
			if (m_nWidth > 0)
			{
				super.Redraw();
				UpdateChildrenSizeAndPosition();
			}
		}

		protected function UpdateChildrenSizeAndPosition():void
		{
			UpdateChildrenFromPosAndHeight(this.textField.y + this.textField.TextHeight + MARGIN_BOTTOM, m_nHeight);
		}

		protected function UpdateChildrenFromPosAndHeight(nYPos:Number, nExpandedHeight:Number):void
		{
			for each (var oChild:MenuNode in m_vecChildNodes)
			{
				oChild.width = m_nWidth;

				if (m_bListTypeDirty)
				{
					oChild.UpdateListType();
				}

				oChild.y = nYPos;
				oChild.Redraw();
				nYPos += oChild.height;
				nExpandedHeight += oChild.height;
			}
			m_bListTypeDirty = false;
			m_nExpandedHeight = nExpandedHeight;
		}

		protected function AdjustLayout(oNode:MenuNode = null):void
		{
			m_nExpandedHeight = (oNode != null) ? DEFAULT_NODE_HEIGHT : 0;
			
			for each (var oChild:MenuNode in m_vecChildNodes)
			{
				oChild.y = m_nExpandedHeight;
				m_nExpandedHeight += oChild.height;
			}
		}

		override public function AdjustViewState():void
		{
			super.AdjustViewState();
			for each (var oChild:MenuNode in m_vecChildNodes)
			{
				oChild.AdjustViewState();
			}
		}

		protected function CreateNodeFromSlide(oSlide:wgISlide, nPosition:int):MenuNode
		{
			var xml:XML = <slidelink slideid={oSlide.AbsoluteId} displaytext={oSlide.Title} expand={false}/>;
			return CreateNode(xml, nPosition);
		}

		protected function OnSlideDrawUpdate(evt:wgPlayerEvent):void
		{
			var oSlideDraw:wgISlideDraw = evt.SlideDraw;
			var vecNodes:Vector.<MenuNode> = m_oSlideDraws[oSlideDraw.AbsoluteId];
			var nFirstPosition:int = vecNodes[0].Index;
			var nLastPosition:int = vecNodes[vecNodes.length - 1].Index;
			var nOldChildCount:int = vecNodes.length;

			for each (var oNode:MenuNode in vecNodes)
			{
				oNode.Destroy();
			}

			m_vecChildNodes.splice(nFirstPosition, nLastPosition - nFirstPosition + 1);

			m_oSlideDraws[oSlideDraw.AbsoluteId] = new Vector.<MenuNode>();
			// Create nodes for the new slides
			for (var i:int = 0; i < oSlideDraw.SlideCount; ++i)
			{
				var oSlide:wgISlide = oSlideDraw.GetSlideAtIndex(i);
				var oNewNode:MenuNode = CreateNodeFromSlide(oSlide, nFirstPosition + i);
				m_oSlideDraws[oSlideDraw.AbsoluteId].push(oNewNode);
			}
			// Recalculate child positions
			m_nExpandedHeight = DEFAULT_NODE_HEIGHT;
			for each (var oChild:MenuNode in m_vecChildNodes)
			{
				oChild.width = m_nWidth;
				oChild.x = 0;
				oChild.y = m_nExpandedHeight;

				var nIndex:int = m_vecChildNodes.indexOf(oChild);
				oChild.NumberString = m_strNumber + (nIndex + 1) + ".";
				m_nExpandedHeight += DEFAULT_NODE_HEIGHT;
			}

			if (nOldChildCount != vecNodes.length)
			{
				dispatchEvent(new MenuEvent(MenuEvent.ADJUST_LAYOUT, this));
			}
		}
	}
}