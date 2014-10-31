package com.articulate.wg.v3_0
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;

	/**
	 * wgIWindow specifies the functions that a window must implement to work with the Articulate player.
	 */
	public interface wgIWindow extends IEventDispatcher, wgIFocusObject
	{
		/**
		 * Returns a reference to a Sprite that the player will use as the container for displaying slides.
		 * @return
		 */
		function GetSlideContainer():Sprite;
		/**
		 * Returns the rectangle of the slide container.
		 * @return
		 */
		function GetSlideRect():Rectangle;
		/**
		 * Returns a reference to the window.
		 * @return
		 */
		function GetDisplayObject():DisplayObject;
		/**
		 * Sets the name of the layout which specifies the controls to be displayed for the window.
		 * @param strControlLayout
		 */
		function SetControlLayout(strControlLayout:String):void;
		/**
		 * Set the timeline for the window.
		 * @param oTimeline The wgITimeline object to set as the timeline for the window.
		 */
		function SetWindowTimeline(oTimeline:wgITimeline):void;
		/**
		 * Enable or disable a specific control.
		 * @param strControlName The name of the control to be enabled or disabled.
		 * @param bEnable True = enable control. False = disable control.
		 */
		function EnableWindowControl(strControlName:String, bEnable:Boolean):void
		/**
		 * Show or hide a specific control.
		 * @param strControlName The name of the control to be shown or hidden.
		 * @param bEnable True = show control. False = hide control.
		 */
		function SetControlVisible(strControlName:String, bVisible:Boolean):void;
		/**
		 * Displays the <i>strTitle</i> string as the title for the current slide.
		 * @param strTitle
		 */
		function SetTitle(strTitle:String):void;

		/**
		 * The x position of the window in pixels.
		 */
		function get x():Number;
		function set x(value:Number):void;

		/**
		 * The y position of the window in pixels.
		 */
		function get y():Number;
		function set y(value:Number):void;

		/**
		 * The width of the window in pixels.
		 */
		function get width():Number;
		function set width(value:Number):void;

		/**
		 * The height of the window in pixels.
		 */
		function get height():Number;
		function set height(value:Number):void;

		/**
		 * Whether or not the contents of the window are scaled to fit within the window.
		 */
		function get ScaleToFit():Boolean;
		/**
		 * The alpha of the shade rectangle that appears behind a lightbox or prompt window as a value in the range 0-100.
		 */
		function get ShadeAlpha():Number;

		/**
		 * The scale of the window as a value in the range 0-1.
		 */
		function get SlideScale():Number;
	}
}
