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

package com.soenkerohde.desktop.info {
	
	public interface IUpdateInfo {
		
		function get phase() : String;
		
		/**
		 * content of readmeUrl
		 */
		function get versionInfo() : String;
		
		[Bindable( event="startedChange" )]
		function get started() : Boolean;
		
		[Bindable( event="completeChange" )]
		function get complete() : Boolean;
		
		[Bindable( event="completeChange" )]
		function get updateFilePath() : String;
		
		// Version Properties
		
		[Bindable( event="versionChange" )]
		function get localVersion() : String;
		
		[Bindable( event="versionChange" )]
		function get remoteVersion() : String;
		
		// Progress Properties
		
		[Bindable( event="progressChange" )]
		function get percent() : uint;
		
		[Bindable( event="progressChange" )]
		function get bytesLoaded() : Number;
		
		[Bindable( event="progressChange" )]
		function get bytesTotal() : Number;
		
		[Bindable( event="progressChange" )]
		function get kiloBytePerSecond() : Number;
		
		/**
		 * returns time remaining downloading the update in seconds
		 */
		[Bindable( event="progressChange" )]
		function get timeRemaining() : Number;
	
	}
}