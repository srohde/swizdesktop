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
	import air.net.URLMonitor;
	
	import com.codeazur.utils.AIRRemoteUpdater;
	import com.codeazur.utils.AIRRemoteUpdaterEvent;
	import com.soenkerohde.desktop.event.OnlineEvent;
	import com.soenkerohde.desktop.event.UpdateEvent;
	import com.soenkerohde.desktop.info.IUpdateInfo;
	import com.soenkerohde.desktop.info.UpdateInfo;
	
	import flash.desktop.Updater;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.swizframework.factory.IInitializingBean;
	
	/**
	 *
	 * Declare SwizUpdateBean in Swiz BeanLoader to use it.
	 *
	 */
	public class SwizUpdateBean extends EventDispatcher implements IInitializingBean, ISwizUpdateBean {
		
		protected static const logger : ILogger = Log.getLogger( "org.swizframework.desktop.SwizUpdateBean" );
		
		private var _updateUrl:String;
		private var _updateURLRequest:URLRequest;
		private var _autoCheckUpdate:Boolean = true;
		private var _autoStartUpdate:Boolean = true;
		private var _pollInterval:Number = 5000;
		private var _updateInfo:UpdateInfo;
		
		// used for online/connection check
		private var _urlMonitor:URLMonitor;
		
		// online flag
		private var _online:Boolean = false;
		
		private var _updater:AIRRemoteUpdater;
		
		/**
		 *
		 * @return updateInfo instance which is read-only.
		 *
		 */
		public function get updateInfo() : IUpdateInfo {
			return _updateInfo;
		}
		
		/**
		 *
		 * @return Online flag which indicates if the updateUrl is still reachable.
		 *
		 */
		public function get online() : Boolean {
			return _online;
		}
		
		/**
		 *
		 * @param autoCheck Flag to automatically start the update check when Swiz is initialized. Default is false.
		 *
		 */
		public function set autoCheckUpdate( autoCheck : Boolean ) : void {
			_autoCheckUpdate = autoCheck;
		}
		
		/**
		 *
		 * @param autoStart Flag to automatically download the update when a new version is available. Default is false.
		 *
		 */
		public function set autoStartUpdate( autoStart : Boolean ) : void {
			_autoStartUpdate = autoStart;
		}
		
		/**
		 *
		 * @param url Url to the application AIR file e.g.: http://domain.com/YourApp.air
		 *
		 */
		public function set updateUrl( url : String ) : void {
			_updateUrl = url;
			_updateURLRequest = new URLRequest( _updateUrl );
		}
		
		/**
		 *
		 * @param pollInterval Interval in ms how often to check if the user is still online. Default is 5000ms.
		 *
		 */
		public function set onlinePollInterval( pollInterval : Number ) : void {
			_pollInterval = pollInterval;
		}
		
		public function SwizUpdateBean() {
		}
		
		/**
		 * IInitializingBean implementation.
		 *
		 */
		public function initialize() : void {
			_updateInfo = new UpdateInfo();
			
			_updater = new AIRRemoteUpdater();
			_updater.addEventListener( AIRRemoteUpdaterEvent.VERSION_CHECK, onVersionInfo );
			_updater.addEventListener( IOErrorEvent.IO_ERROR, onUpdateError );
			_updater.addEventListener( AIRRemoteUpdaterEvent.UPDATE, updaterUpdateHandler );
			_updater.addEventListener( ProgressEvent.PROGRESS, onUpdateProgress );
			
			_updateInfo.setVersions( _updater.getLocalVersion(), null );
			
			if ( dispatchEvent( new UpdateEvent( UpdateEvent.INIT, _updateInfo ) )
				&& _autoCheckUpdate && _updateUrl != null ) {
				checkOnline();
			} else {
				logger.info( "init canceled" );
			}
		}
		
		public function checkOnline() : void {
			logger.info( "checkOnline " + _updateUrl );
			
			if ( dispatchEvent( new UpdateEvent( UpdateEvent.CHECK_ONLINE, _updateInfo ) ) ) {
				_updateInfo.phase = UpdateEvent.CHECK_ONLINE;
				
				var ur:URLRequest = new URLRequest( _updateUrl );
				ur.method = "HEAD";
				
				_urlMonitor = new URLMonitor( ur );
				_urlMonitor.pollInterval = _pollInterval;
				_urlMonitor.addEventListener( StatusEvent.STATUS, onOnlineStatus );
				_urlMonitor.start();
			} else {
				logger.info( "checkOnline canceled" );
			}
		}
		
		private var _checked:Boolean = false;
		
		protected function onOnlineStatus( event : StatusEvent ) : void {
			logger.info( "onOnlineStatus " + _urlMonitor.available );
			_online = _urlMonitor.available;
			
			dispatchEvent( new Event( "onlineChange" ) );
			
			dispatchEvent( new OnlineEvent( OnlineEvent.CHANGE, _online ) );
			
			if ( _online && !_checked ) {
				_checked = true;
				checkUpdate();
			}
		}
		
		
		public function checkUpdate( allowCancel : Boolean = true ) : void {
			logger.info( "checkForUpdate" );
			if ( !allowCancel || dispatchEvent( new UpdateEvent( UpdateEvent.CHECK_VERSION, _updateInfo ) ) ) {
				_updateInfo.phase = UpdateEvent.CHECK_VERSION;
				_updater.update( _updateURLRequest );
			} else {
				logger.info( "checkForUpdate canceled" );
			}
		}
		
		protected function onUpdateError( event : IOErrorEvent ) : void {
			logger.error( "onUpdateError " + event.text );
			dispatchEvent( event.clone() );
		}
		
		protected function onVersionInfo( event : AIRRemoteUpdaterEvent ) : void {
			logger.info( "VersionInfo: local {0} remote {1} ", _updater.localVersion, _updater.remoteVersion );
			event.preventDefault();
			_updateInfo.setVersions( _updater.localVersion, _updater.remoteVersion );
			
			if ( _autoStartUpdate && dispatchEvent( new UpdateEvent( UpdateEvent.VERSION_INFO, _updateInfo ) ) ) {
				_updateInfo.phase = UpdateEvent.VERSION_INFO;
				if ( _updateInfo.localVersion != _updateInfo.remoteVersion ) {
					downloadUpdate();
				}
			}
		}
		
		public function downloadUpdate( allowCancel : Boolean = true ) : void {
			logger.info( "downloadUpdate" );
			if ( !allowCancel || dispatchEvent( new UpdateEvent( UpdateEvent.DOWNLOAD, _updateInfo ) ) ) {
				_updateInfo.phase = UpdateEvent.DOWNLOAD;
				_updateInfo.setStarted( true );
				_updater.update( _updateURLRequest, false );
			} else {
				logger.warn( "downloadUpdate canceled" );
			}
		}
		
		protected function onUpdateProgress( event : ProgressEvent ) : void {
			_updateInfo.setProgress( event.bytesLoaded, event.bytesTotal );
			dispatchEvent( new UpdateEvent( UpdateEvent.PROGRESS, _updateInfo ) );
		}
		
		private function updaterUpdateHandler( event : AIRRemoteUpdaterEvent ) : void {
			event.preventDefault();
			_updateInfo.setComplete( true, event.file.nativePath );
			executeUpdate();
		}
		
		public function executeUpdate( allowCancel : Boolean = true ) : void {
			if ( !allowCancel || dispatchEvent( new UpdateEvent( UpdateEvent.UPDATE, _updateInfo ) ) ) {
				var updater:Updater = new Updater();
				updater.update( new File( _updateInfo.updateFilePath ), _updateInfo.remoteVersion );
			} else {
				logger.info( "executeUpdate canceled" );
			}
		}
	
	}
}