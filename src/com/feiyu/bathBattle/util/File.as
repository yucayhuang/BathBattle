package com.feiyu.bathBattle.util
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	/**
	 * 加載遠程文件類
	 *
	 * For example:
	 *
	 * var file : File = new File();
	 * 
	 * file.onProgress = function (bytesTotal : Number, bytesLoaded : Number) : void {}
	 * (or)a
	 * file.onProgress = function (bytesTotal : Number, bytesLoaded : Number, speed : String) : void {}
	 *
	 * file.onComplete = function () : void
	 * {
	 *     ...加載完畢，處理...
	 * };
	 */
	public class File 
	{
		private var _uri : String;
		
		private var _loader : Loader;
		
		private var _applicationDomain : ApplicationDomain;
		
		private var _useNewDomain : Boolean = false;
		
		/**
		 * 加載進程調用
		 *
		 * For example:
		 *
		 * onProgress = function (bytesTotal : Number, bytesLoaded : Number) : void
		 * {
		 * };
		 */
		public var onProgress : Function;
		
		/**
		 * 加載完畢調用
		 */
		public var onComplete : Function;
		
		/**
		 * 加載錯誤
		 */
		public var onError : Function;
		
		/**
		 * 上一次加載的字節數
		 */
		private var _lastBytes : uint = 0;
		
		/**
		 * 當前加載字節數與上一次加載字節數的差值, 形式：kb.b
		 */
		private var _speed : Number = 0;
		
		/**
		 * 獲取版本信息的方法
		 */
		public static var onVersion : Function;
		
		/**
		 * url附加隨機數
		 */
		protected var _urlRnd : int = 0;
		
		public function File () 
		{
			_loader = new Loader();
			
			addTemp();
			_reloadCount = File.limit;
		}
		
		private function addEvent () : void
		{
			var li : LoaderInfo = _loader.contentLoaderInfo;
			
			li.addEventListener(Event.COMPLETE, complete);
			li.addEventListener(ProgressEvent.PROGRESS, progress);
			li.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
			li.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			li.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function removeEvent () : void
		{
			var li : LoaderInfo = _loader.contentLoaderInfo;
			
			li.removeEventListener(Event.COMPLETE, complete);
			li.removeEventListener(ProgressEvent.PROGRESS, progress);
			li.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus);
			li.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			li.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		/**
		 * 加載資源
		 *
		 * @param uri String
		 * 資源地址
		 */
		public function load (uri : String) : void 
		{
			_uri = uri;
			
			var version : String = "";
			if (onVersion is Function)
			{
				version = onVersion(uri);
				if (version != "")
				{
					version = "?v=" + version;
				}
			}
			
			if (_urlRnd)
			{
				version += (version ? "&" : "?") + "r=" + _urlRnd;
			}
			
			var request : URLRequest = new URLRequest(Verison.getVersionUrl(_uri + version));
			
			var lc : LoaderContext = new LoaderContext();
			lc.checkPolicyFile = false;
			
			lc.applicationDomain 
				= _useNewDomain
				? new ApplicationDomain()
				: new ApplicationDomain(ApplicationDomain.currentDomain);
			
			//lc.securityDomain = SecurityDomain.currentDomain;
			
			addEvent();
			if(_strategyWarInitLoading)
			{
				_loader.load(request, new LoaderContext(false,ApplicationDomain.currentDomain));
			}else
			{
				_loader.load(request, lc);
			}
		}
		
		private static var _strategyWarInitLoading:Boolean;
		public static function set strategyWarInitLoading(bool:Boolean):void
		{
			_strategyWarInitLoading = bool;
		}
		
		protected function complete (e : Event) : void 
		{
			_applicationDomain = _loader.contentLoaderInfo.applicationDomain;
			
			if (onComplete is Function)
			{
				onComplete();
			}
			
			removeEvent();
			removeTemp();
		}
		
		protected function progress (e : ProgressEvent) : void 
		{
			if (onProgress is Function)
			{
				if (onProgress.length == 3)
				{
					if (e.bytesLoaded - _lastBytes > 0)
					{
						_speed = e.bytesLoaded - _lastBytes;
						_lastBytes = e.bytesLoaded;
						
						var kb : int = _speed / 1024;
						var b : int  = _speed % 1024;
						
						_speed = kb + Math.floor(b / 1024 * 10) / 10;
					}
					
					onProgress(e.bytesTotal, e.bytesLoaded, _speed + "kb/s");
				}
				else
				{
					onProgress(e.bytesTotal, e.bytesLoaded);
				}
			}
		}
		
		private function httpStatus (e : HTTPStatusEvent) : void 
		{
			//trace('Swf HTTPStatusEvent = ', e.status);
		}
		
		private function securityErrorHandler(e : SecurityErrorEvent) : void 
		{
			trace("[File]\n======\n安全策略問題:", e, "\n======\n");
			
			delayToLoad();
		}
		
		private function ioErrorHandler (e : IOErrorEvent) : void 
		{
			trace("[File]\n======\n嘗試重載文件:", _uri, "\n======\n");
			
			delayToLoad();
		}
		
		//----------------------------------------------------------------------
		//
		//	臨時存儲
		//
		//----------------------------------------------------------------------
		
		private static var _temp : Dictionary = new Dictionary();
		
		private function addTemp () : void
		{
			File._temp[this] = 1;
		}
		
		private function removeTemp () : void
		{
			delete File._temp[this];
		}
		
		//----------------------------------------------------------------------
		//
		//	延遲加載
		//
		//----------------------------------------------------------------------
		
		private var _timer : Timer;
		
		// 重載次數限制
		public static const limit : int = 3;
		
		// 重載次數限制
		private var _reloadCount : int = File.limit;
		
		private function delayToLoad () : void
		{
			_loader.unload();
			
			if (_reloadCount <= 0)
			{
				stopLoad();
				
				removeEvent();
				removeTemp();
				
				if (onError is Function)
				{
					onError();
				}
				
				trace("[File]\n======\n找不到文件:", _uri, "\n======\n");
				return;
			}
			
			_reloadCount--;
			
			_timer = new Timer(100, 1);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, startLoad);
			_timer.start();
		}
		
		private function startLoad (e : TimerEvent) : void
		{
			stopLoad();
			
			_urlRnd++;
			if (_urlRnd == 3)
			{
				_urlRnd = Math.random() * 100;
			}
			
			load(_uri);
		}
		
		private function stopLoad () : void
		{
			_timer.stop();
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, startLoad);
		}
		
		//----------------------------------------------------------------------
		//
		//	抽取類
		//
		//----------------------------------------------------------------------
		
		/**
		 * 抽取資源庫中的類
		 *
		 * @param className String
		 * 類名稱
		 */
		public function getClassByName (className : String) : Class 
		{
			try 
			{
				return _applicationDomain.getDefinition(className) as Class;
			}
			catch (e : Error) 
			{
				throw new Error(className + ' not found in ' + _uri + '\n' + e);
			}
			
			return null;
		}
		
		public function getClassObject (className : String) : Object
		{
			var C : Class = getClassByName(className) as Class;
			return new C();
		}
		
		//----------------------------------------------------------------------
		//
		//	加載多個文件
		//
		//----------------------------------------------------------------------
		
		private static var _id : int = 0;
		private static var _processes : Object = {};
		
		/**
		 * 順序加載多個文件
		 * 
		 * @param list Array
		 * var list : Array = [url1, url2, ...];
		 * 
		 * @param callback Function
		 * 加載完畢，執行回調
		 * 
		 * var callback : Function = function (list : Array) : void
		 * {
		 *     // ...
		 * };
		 * 
		 * @param progress Function
		 * progress = function (index : int, percent : int) : void {}
		 * (or)
		 * progress = function (index : int, percent : int, speed : String) : void {}
		 * (or)
		 * progress = function (count : int, index : int, percent : int, speed : String) : void {}
		 * 
		 * @param oneCompleted Function
		 * oneCompleted = function (index : int) : void {}
		 * 
		 * @param error Function
		 * error = function (index : int) : void {}
		 */
		public static function loadList (
			list : Array, 
			callback : Function, 
			progress : Function = null, 
			oneCompleted : Function = null,
			error : Function = null
		) : int {
			_id++;
			_processes[_id] = true;
			
			loadOne(list, 0, [], callback, progress, oneCompleted, error, _id);
			
			return _id;
		}
		
		/**
		 * 停止加載隊列
		 * 
		 * @param id int
		 */
		public static function stopLoadList (id : int) : void
		{
			if (id && _processes[id])
			{
				_processes[id] = false;
			}
		}
		
		/**
		 * @param list Array
		 * @param index int
		 * @param temp Array
		 * @param callback Function
		 * @param progress Function
		 * @param oneCompleted Function
		 * @param error Function
		 */
		private static function loadOne (
			list : Array, 
			index : int, 
			temp : Array, 
			callback : Function, 
			progress : Function = null, 
			oneCompleted : Function = null,
			error : Function = null,
			id : int = 0
		) : void {
			var file : File = new File();
			temp.push(file);
			
			var len : int = list.length;
			
			file.onComplete = function () : void
			{
				if (false == _processes[id])
				{
					delete _processes[id];
					return;
				}
				
				var isOver : Boolean = index + 1 >= len;
				
				if (oneCompleted is Function)
				{
					oneCompleted(index, isOver);
				}
				
				if (isOver)
				{
					delete _processes[id];
					callback(temp);
				}
				else
				{
					loadOne(list, index + 1, temp, callback, progress, oneCompleted, error, id);
				}
			};
			
			file.onProgress = function (bytesTotal : int, bytesLoaded : int, speed : String) : void
			{
				if (progress is Function)
				{
					var percent : int = Math.floor(bytesLoaded / bytesTotal * 100);
					percent = Math.min(100, percent);
					
					if (progress.length == 4)
					{
						progress(len, index, percent, speed);
					}
					else if (progress.length == 3)
					{
						progress(index, percent, speed);
					}
					else
					{
						progress(index, percent);
					}
				}
			};
			
			file.onError = function () : void
			{
				if (error is Function)
				{
					error(index);
				}
			}
			
			file.load(list[index]);
		}
		
		//----------------------------------------------------------------------
		//
		//	外部引用
		//
		//----------------------------------------------------------------------
		
		public function get loader () : Loader 
		{
			return _loader;
		}
		
		public function get applicationDomain () : ApplicationDomain 
		{
			return _applicationDomain;
		}
		
		public function set useNewDomain (value : Boolean) : void
		{
			_useNewDomain = value;
		}
		
		/**
		 * 獲取二進制數據
		 */
		public function get bytes () : ByteArray
		{
			return _loader.contentLoaderInfo.bytes;
		}
		
		/**
		 * 獲取位圖
		 */
		public function get bitmap () : Bitmap
		{
			return _loader.content as Bitmap;
		}
	}
}