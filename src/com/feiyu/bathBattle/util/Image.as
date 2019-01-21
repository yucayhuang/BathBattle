package com.feiyu.bathBattle.util
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 图片类
	 * 类似于HTML的标签<img>
	 */
	public class Image extends Sprite
	{	
		public var data:Array;
		private var _file:File;
		public function get file() : File
		{
			return _file;
		}
		private var _time:int = 0;
		private var _startTime:int = 0;
		
		public var url:String;
		public var bShowErr:Boolean = true;
		public var bDoComplete:Boolean = true;//加载失败是否执行onComplete
		
		/**
		 * 加载完毕的回调 
		 * 
		 * onComplete = function () : void
		 * {
		 *     // ...
		 * }
		 */
		public var onComplete : Function;
		
		/**
		 * 加载失败后显示的图标
		 */
		public static var errorImage : BitmapData = new BitmapData(1, 1, true, 0);
		
		/**
		 * 加载图标
		 */
		public static var loadClass : Class = Sprite;
		
		
		/**
		 * 缓存列表
		 */
		private static var _cacheList : Object = {};
		
		/**
		 * 是否已缓存
		 * 
		 * @param url String
		 */
		public static function isInCache(url : String) : Boolean
		{
			return _cacheList.hasOwnProperty(url);
		}
		
		/**
		 * @param url
		 * @param showLoading 是否显示loading
		 * @param time 淡入时间500毫秒(透明度从0->1的时间), 0.标示不需要淡入
		 */
		public function Image (url : String, showLoading : Boolean = false, time : int = 100)
		{
			getImageUrl(url, showLoading, time);
		}
		
		public function getImageUrl (url : String, showLoading : Boolean = false, time : int = 100) : void
		{

			if(url.length <= 0) return;
			this.url = url;
			
			_time = time;
			
			if (_cacheList[url])
			{
				if (_cacheList[url] is BitmapData)
				{
					addChild(new Bitmap(_cacheList[url], "auto", true));
					runComplete();
				}
				else if (_cacheList[url] is Class)
				{
					addChild(new _cacheList[url]);
					runComplete();
				}
			}
			else
			{
				_file = new File();
				_file.onComplete = completeHandler;
				_file.onError    = ioErrorHandler;
				_file.load(url);
				
				if (showLoading == true)
				{
					this.addChild(new loadClass());
				}
			}
		}
		
		public function set smoothing(b:Boolean):void
		{
		}
		
		private function ioErrorHandler () : void 
		{
			clear();
			if(bShowErr)
			{
				addChild(new Bitmap(errorImage));
			}
			
			if(bDoComplete)
			{
				runComplete();
			}
		}
		
		private function completeHandler () : void
		{
			clear();
			
			var loader : Loader = _file.loader;
			addChild(loader.content);
			
			var allowFadeIn : Boolean = true;
			
			if (loader)
			{
				var obj : Object = loader.content;
				
				if (obj is Bitmap)
				{
					(obj as Bitmap).smoothing = true;
					
					if(_cacheList[url] == null)
					{
						_cacheList[url] = (obj as Bitmap).bitmapData.clone();
					}
				}
				else if((url.indexOf("icons/farm/") != -1 || url.indexOf("icons/fate/") != -1) && _cacheList[url] == null
				|| url.indexOf("icons/study_stunt/") != -1 || url.indexOf("roles/effects/long") != -1 )
				{
					_cacheList[url] = obj.constructor as Class;
				}
			}
			
			runComplete();
		}
		
		public function runComplete () : void
		{
			listCall.push(runCompleteCallback);
			
			if (_time > 0)
			{
				fadeIn();
			}
		}
		
		private function runCompleteCallback () : void
		{
			if ((onComplete is Function) == false) return;
			
			if (onComplete.length == 0)
			{
				onComplete();
			}
			else
			{
				onComplete(this);
			}
		}
		
		private function clear () : void
		{
			while (this.numChildren)
			{
				this.removeChildAt(0);
			}
		}
		
		//----------------------------------------------------------------------
		//
		//  淡入
		//
		//----------------------------------------------------------------------
		
		private static var listFadeIn:Array = [];
		
		private static var listCall:Array = [];
		
		private static var enterFrameSprite:Sprite = new Sprite();
		
		/**
		 * 执行淡入. 在加载完成后执行, 加载前设定请在构造函数中传参数.
		 * @param time 淡入时间,单位:毫秒
		 */
		private function fadeIn() : void
		{
			_startTime = getTimer();
			alpha = 0;
			
			listFadeIn.push(fadeInPass);
		}
		
		private function fadeInPass () : void
		{
			var t:int = getTimer() - _startTime;
			this.alpha = (t/_time);
			if(this.alpha >= 1)
			{
				this.alpha = 1;
				t = listFadeIn.indexOf(fadeInPass);
				listFadeIn.splice(t, 1);
			}
		}
		
		private static function enterFrameImage(e:Event):void
		{
			var fun:Function;
			
			if(listCall.length > 0)
			{
				for each(fun in listCall)
				{
					fun();
				}
				listCall = [];
			}
			
			for each(fun in listFadeIn)
			{
				fun();
			}
		}
		
		public static function initImage():void
		{
			enterFrameSprite.addEventListener(Event.ENTER_FRAME, enterFrameImage);
		}
	}
}
import com.feiyu.flyingMan.util.Image;

Image.initImage();






























///////////////