package com.articulate.wg.v3_0
{
	import com.articulate.wg.v3_0.wgITimer;
	import com.articulate.wg.v3_0.wgIWindow;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	/**
	 * wgIFrame is the interface a frame must implement to work with the Articulate player.
	 */
	public interface wgIFrame extends wgIWindow
	{
		/**
		 * Whether or not the frame has completed its setup and is ready to interact with for the Articulate player.
		 * @return
		 */
		function get IsFrameReady():Boolean;

		/**
		 * Passes the FlashVars from the main player to the Frame.
		 * @param oFlashVars An object containing the names of Flash vars and their values.
		 */
		function SetFlashVars(oFlashVars:Object):void;

		/**
		 * Set the name and location of the file where the xmldata is stored.
		 * @param strFilename
		 * @param strRemotePath
		 */
		function SetDataFilename(strFilename:String, strRemotePath:String):void;

		/**
		 * Show or hide the frame.
		 * @param bShow True = show frame. False = hide frame.
		 */
		function ShowPlayerFrame(bShow:Boolean):void;
		/**
		 * Disable or enable the frame.
		 * @param bDisable True = disable frame. False = enable frame.
		 */
		function DisablePlayerFrame(bDisable:Boolean):void;

		/**
		 * Return the wgIWindow with the specified name.
		 * @param strWindowName The name of the window to be returned.
		 * @return
		 */
		function GetWindow(strWindowName:String):wgIWindow;

		/**
		 * Add a timer object for a quiz.
		 * @param oTimer
		 */
		function AddTimer(oTimer:wgITimer):void;
		/**
		 * Remove a timer object for a quiz.
		 * @param oTimer
		 */
		function RemoveTimer(oTimer:wgITimer):void;

		/**
		 * Show (or hide) a presenter video.
		 * @param bShow True = show video. False = hide video.
		 * @param nWidth The width of the video in pixels.
		 * @param nHeight The height of the video in pixels.
		 * @return The parent container of the video.
		 */
		function ShowVideo(bShow:Boolean, nWidth:int = 0, nHeight:int = 0):DisplayObjectContainer;

		/**
		 * Show (or hide) information about a presenter.
		 * @param bShow True = show video. False = hide video.
		 * @param nWidth The width of the video (if any) in pixels.
		 * @param nHeight The height of the video (if any) in pixels.
		 * @param bShowInfo Whether or not to show the presenter information.
		 * @param strPresenterId The id of the presenter.
		 * @return The parent container of the video.
		 */
		function ShowPresenter(bShow:Boolean, nWidth:int = 0, nHeight:int = 0, bShowInfo:Boolean = true,
							   strPresenterId:String = ""):DisplayObjectContainer;

		/**
		 * Set the name of the layout to be used in the frame.
		 * @param strLayout
		 */
		function SetLayout(strLayout:String):void
		/**
		 * Sed the id of the color scheme to be used in the frame.
		 * @param strColorScheme
		 */
		function SetColorScheme(strColorScheme:String):void
		/**
		 * Set the id of the straing table to be used in the frame.
		 * @param strStringTable
		 */
		function SetStringTable(strStringTable:String):void
		/**
		 * Set a font to be used in the frame.
		 * @param strFontName The name of the font to set.
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