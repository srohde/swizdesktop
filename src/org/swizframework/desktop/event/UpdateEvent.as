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

package org.swizframework.desktop.event {
	import flash.events.Event;
	import org.swizframework.desktop.info.IUpdateInfo;
	
	public class UpdateEvent extends Event {
		
		public static const INIT : String = "init";
		public static const CHECK_ONLINE : String = "checkOnline";
		public static const CHECK_VERSION : String = "checkVersion";
		public static const VERSION_INFO : String = "versionInfo";
		public static const DOWNLOAD : String = "download";
		public static const PROGRESS : String = "progress";
		public static const UPDATE : String = "update";
		
		public var updateInfo:IUpdateInfo;
		
		public function UpdateEvent( type : String, updateInfo : IUpdateInfo, bubbles : Boolean = false, cancelable : Boolean = true ) {
			super( type, bubbles, cancelable );
			this.updateInfo = updateInfo;
		}
	
	}
}