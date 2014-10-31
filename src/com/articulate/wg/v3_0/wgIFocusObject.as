package com.articulate.wg.v3_0
{
	/**
	 * wgIFocusObject describes an object that can accept focus based on user input. It is used
	 * for accessibility.
	 *
	 */
	public interface wgIFocusObject
	{
		/**
		 * Should return true if the object or one of it's children is on stage and can recieve focus.
		 * @return
		 */
		function IsFocusEnabled():Boolean;

		/**
		 * Sets the focus to the object and returns true if sucessful
		 * @param bShowFocusRect
		 * @return
		 */
		function SetFocus(bShowFocusRect:Boolean = true):Boolean;

		/**
		 * Sets the focus to the last object in the focus list and returns true if sucessful.
		 * @param bShowFocusRect
		 * @return
		 */
		function SetLastFocus(bShowFocusRect:Boolean = true):Boolean;

		/**
		 * Returns true if the object has children that can receive focus.
		 * @return
		 */
		function HasFocusChildren():Boolean;

		/**
		 * Sets the focus to the next child object and returns true if successful.
		 * @param bShowFocusRect
		 * @return
		 */
		function SetNextChildFocus(bShowFocusRect:Boolean = true):Boolean;

		/**
		 * Sets the focus to the previous child object and returns true if successful.
		 * @param bShowFocusRect
		 * @return
		 */
		function SetPreviousChildFocus(bShowFocusRect:Boolean = true):Boolean;

		/**
		 * Returns true if the object or one of its children has focus.
		 * @return
		 */
		function HasFocus():Boolean;

		/**
		 * Returns the focus object's parent focus object.
		 * @return
		 */
		function GetFocusParent():wgIFocusObject;

		/**
		 * Sets the focus object's focus parent
		 * @param oParent
		 */
		function SetFocusParent(oParent:wgIFocusObject):void;

		/**
		 * Sets the current focus object to the specified one.
		 * @param oFocusObject The object to be focused on.
		 * @param bParent
		 */
		function SetCurrentFocus(oFocusObject:wgIFocusObject, bParent:Boolean = false):void;
	}
}