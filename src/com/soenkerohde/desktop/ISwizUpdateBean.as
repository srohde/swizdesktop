/*
 * Copyright (C) 2009 Sönke Rohde
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

package com.soenkerohde.desktop {
	
	import com.soenkerohde.desktop.info.IUpdateInfo;
	
	import flash.events.IEventDispatcher;
	
	public interface ISwizUpdateBean extends IEventDispatcher {
		
		/**
		 * @return the UpdateInfo value object which can be used for data binding
		 */
		[Bindable( event="updateInfoChange" )]
		function get updateInfo() : IUpdateInfo;
		
		/**
		 * @return the online status
		 */
		[Bindable( event="onlineChange" )]
		function get online() : Boolean;
		
		/**
		 *
		 * @param autoCheck Flag to automatically start the update check when Swiz is initialized. Default is false.
		 *
		 */
		function set autoCheckUpdate( autoCheck : Boolean ) : void;
		
		/**
		 *
		 * @param autoStart Flag to automatically download the update when a new version is available. Default is false.
		 *
		 */
		function set autoStartUpdate( autoStart : Boolean ) : void;
		
		/**
		 * if updateUrl is set here the check starts onApplicationComplete
		 *
		 * @see checkForUpdate
		 *
		 * @url against to check for an updated version
		 */
		function set updateUrl( url : String ) : void;
		
		/**
		 * @pollinterval Value in ms how often the connection of the user should be checked. Default is 5000ms.
		 */
		function set onlinePollInterval( pollInterval : Number ) : void;
		
		/**
		 * starts the update check
		 *
		 */
		function checkUpdate( allowCancel : Boolean = true ) : void;
		
		/**
		 * starts the update download
		 *
		 * throws an error if no updateUrl is defined
		 */
		function downloadUpdate( allowCancel : Boolean = true ) : void;
		
		/**
		 * executes the uddate process which will close the application
		 *
		 * throws an error if the udpate is not downloaded yet
		 */
		function executeUpdate( allowCancel : Boolean = true ) : void;
	
	}
}