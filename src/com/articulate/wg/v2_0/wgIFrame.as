package com.articulate.wg.v2_0
{
	import flash.display.DisplayObject;

	/**
	 * wgIFrame is the interface a frame must implement to work with the Articulate player.
	 *
	 * <p>Note on <i>Preview Mode</i>: In addition to its normal use, the Articulate player is used during preview
	 * within Storyline, and several methods in this interface are used to control the frame exclusively during preview.
	 * The methods marked “Preview Mode Only” are not called during the normal runtime and do not need to be
	 * implemented in your custom frame.</p>
	 */
	public interface wgIFrame extends wgIWindow
	{
		/**
		 * Whether or not the frame has completed its setup and is ready to interact with for the Articulate player.
		 * @return
		 */
		function get IsFrameReady():Boolean;

		/**
		 * Specify the name and location of the file where the frame configuration xml data is stored. Once this
		 * is specified, the frame should load and parse this file.
		 * @param strFilename The filename of the xml data.
		 * @param strRemotePath The path to the folder containing the file with the xml data.
		 */
		function SetDataFilename(strFilename:String, strRemotePath:String):void;

		/**
		 * Preview mode only: Show or hide the frame.
		 * @param bShow True = show frame. False = hide frame.
		 */
		function ShowPlayerFrame(bShow:Boolean):void;

		/**
		 * Preview mode only: Disable or enable the frame.
		 * @param bDisable True = disable frame. False = enable frame.
		 */
		function DisablePlayerFrame(bDisable:Boolean):void;

		/**
		 * Return a new instance of a wgIWindow of the type specified.
		 * <p>Possible values are: <i>StoryWindow</i>, <i>StoryPopup</i> or <i>StoryPopupControls</i></p>
.
		 * @param strWindowName The name of the window to be returned.
		 * @return
		 */
		function GetWindow(strWindowName:String):wgIWindow;

		/**
		 * Display the specified timer on the frame.
		 * @param oTimer The timer to add.
		 */
		function AddTimer(oTimer:wgITimer):void;

		/**
		 * Remove the specified timer display from the frame.
		 * @param oTimer The timer to remove.
		 */
		function RemoveTimer(oTimer:wgITimer):void;

		/**
		 * Set the name of the layout to be used in the frame.
		 * @param strLayout The name of the layout to be used.
		 */
		function SetLayout(strLayout:String):void

		/**
		 * Preview mode only: Specify the color scheme to be used in the frame.
		 * @param strColorScheme The name of the color scheme to be used.
		 */
		function SetColorScheme(strColorScheme:String):void

		/**
		 * Preview mode only: Specify the string table to be used in the frame.
		 * @param strStringTable The name of the string table to be used.
		 */
		function SetStringTable(strStringTable:String):void

		/**
		 * Preview mode only: Specify a font to be used in the frame.
		 * @param strFontName The name of the font to be used.
		 */
		function SetFont(strFontName:String):void

		/**
		 * Enable or disable a specific control.
		 * @param strControlName The name of the control to be enabled or disabled.
		 * @param bEnable True = disable control. False = enable control.
		 */
		function EnableFrameControl(strControlName:String, bEnable:Boolean):void
	}
}