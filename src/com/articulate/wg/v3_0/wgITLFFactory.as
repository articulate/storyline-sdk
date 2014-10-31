package com.articulate.wg.v3_0
{
	/**
	 * A wgITLFFactory object can create a fl.text.TLFTextField. (Only used to support right-to-left text.)
	 */
	public interface wgITLFFactory
	{
		/**
		 * Creates a fl.text.TLFTextField. (Only used to support right-to-left text.)
		 * @return a new TLFTextField.
		 */
		function CreateTFLTextField():*
	}
}