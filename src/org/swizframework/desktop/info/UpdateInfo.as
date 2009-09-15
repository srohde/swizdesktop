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

package org.swizframework.desktop.info {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	public class UpdateInfo extends EventDispatcher implements IUpdateInfo {
		
		protected static const logger : ILogger = Log.getLogger( "UpdateInfo" );
		
		private var _phase:String;
		private var _started:Boolean = false;
		private var _complete:Boolean = false;
		private var _updateFilePath:String;
		private var _localVersion:String = "";
		private var _remoteVersion:String = "";
		private var _versionInfo:String;
		private var _percent:uint = 0;
		private var _bytesLoaded:Number = 0;
		private var _bytesTotal:Number = 0;
		private var _kiloBytePerSecond:Number = 0;
		private var _timeRemaining:Number = 0;
		
		// set with getTimer() when started is set to true
		private var _startTime:Number;
		
		[Bindable]
		public function get phase() : String {
			return _phase;
		}
		
		public function set phase( phase : String ) : void {
			_phase = phase;
		}
		
		public function get started() : Boolean {
			return _started;
		}
		
		public function get complete() : Boolean {
			return _complete;
		}
		
		public function get updateFilePath() : String {
			return _updateFilePath;
		}
		
		public function get localVersion() : String {
			return _localVersion;
		}
		
		public function get remoteVersion() : String {
			return _remoteVersion;
		}
		
		public function get versionInfo() : String {
			return _versionInfo;
		}
		
		public function get percent() : uint {
			return _percent;
		}
		
		public function get bytesLoaded() : Number {
			return _bytesLoaded;
		}
		
		public function get bytesTotal() : Number {
			return _bytesTotal;
		}
		
		public function get kiloBytePerSecond() : Number {
			return _kiloBytePerSecond;
		}
		
		public function get timeRemaining() : Number {
			return _timeRemaining;
		}
		
		public function UpdateInfo() {
		}
		
		public function setVersions( localVersion : String, remoteVersion : String ) : void {
			_localVersion = localVersion;
			_remoteVersion = remoteVersion;
			dispatchEvent( new Event( "versionChange" ) );
		}
		
		public function setStarted( started : Boolean ) : void {
			logger.info( "setStarted " + started );
			_started = started;
			_startTime = getTimer();
			dispatchEvent( new Event( "startedChange" ) );
		}
		
		public function setComplete( complete : Boolean, updateFilePath : String ) : void {
			_complete = complete;
			_updateFilePath = updateFilePath;
			dispatchEvent( new Event( "completeChange" ) );
		}
		
		public function setProgress( bytesLoaded : Number, bytesTotal : Number ) : void {
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
			
			// calc percentage progress
			_percent = Math.round( ( bytesLoaded / bytesTotal ) * 100 );
			
			// calc download bandwidth
			var timeElapsed:Number = getTimer() - _startTime;
			_kiloBytePerSecond = Math.round( bytesLoaded / timeElapsed );
			
			// calc remaining time
			_timeRemaining = Math.round( ( (bytesTotal - bytesLoaded) / 1000 ) / _kiloBytePerSecond );
			
			dispatchEvent( new Event( "progressChange" ) );
		}
	
	}
}